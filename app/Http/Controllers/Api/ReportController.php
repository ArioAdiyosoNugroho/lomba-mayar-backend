<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\ReportComment;
use App\Models\ReportVote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    // -------------------------------------------------------
    // GET /reports — paginated list with filters
    // -------------------------------------------------------
    public function index(Request $request)
    {
        $query = Report::with('user:id,name,avatar')
            ->orderBy('created_at', 'desc');

        if ($request->has('type') && $request->type !== 'all') {
            $query->where('report_type', $request->type);
        }

        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        if ($request->has('severity')) {
            $query->where('severity', $request->severity);
        }

        // filter by user_id (untuk profile page)
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // bounding box for map queries
        if ($request->filled(['lat_min', 'lat_max', 'lng_min', 'lng_max'])) {
            $query->whereBetween('lat', [$request->lat_min, $request->lat_max])
                  ->whereBetween('lng', [$request->lng_min, $request->lng_max]);
        }

        $perPage = $request->get('per_page', 20);
        return response()->json($query->paginate($perPage));
    }

    // -------------------------------------------------------
    // GET /reports/map — lightweight for map pins (no pagination)
    // -------------------------------------------------------
    public function mapPins(\Illuminate\Http\Request $request)
    {
        $query = Report::select('id', 'title', 'lat', 'lng', 'report_type', 'severity', 'status', 'photo_path')
            ->whereNotNull('lat')
            ->whereNotNull('lng')
            ->whereIn('status', ['verified', 'resolved']);

        // Bounding box - hanya load titik dalam viewport peta
        if ($request->filled(['lat_min', 'lat_max', 'lng_min', 'lng_max'])) {
            $query->whereBetween('lat', [(float)$request->lat_min, (float)$request->lat_max])
                  ->whereBetween('lng', [(float)$request->lng_min, (float)$request->lng_max]);
        }

        $pins = $query->latest()->limit(500)->get()
            ->map(function ($r) {
                return [
                    'id'        => $r->id,
                    'title'     => $r->title,
                    'lat'       => (float) $r->lat,
                    'lng'       => (float) $r->lng,
                    'type'      => $r->report_type,
                    'severity'  => $r->severity,
                    'status'    => $r->status,
                    'photo_url' => $r->photo_url,
                ];
            });

        return response()->json($pins);
    }

    // -------------------------------------------------------
    // POST /reports
    // -------------------------------------------------------
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title'         => 'required|string|max:255',
            'description'   => 'required|string|min:3',
            'lat'           => 'required|numeric|between:-90,90',
            'lng'           => 'required|numeric|between:-180,180',
            'location_text' => 'nullable|string|max:255',
            'report_type'   => 'nullable|string',
            'severity'      => 'nullable|in:low,medium,high,critical',
            'area_affected' => 'nullable|numeric|min:0',
            'trees_lost'    => 'nullable|integer|min:0',
            'photo'         => 'nullable|image|mimes:jpeg,png,jpg,webp,gif|max:10240',
        ]);

        $photoPath = null;
        if ($request->hasFile('photo')) {
            $photoPath = $request->file('photo')->store('reports', 'public');
        }

        $report = Report::create([
            'user_id'       => $request->user()->id ?? null,
            'title'         => $validated['title'],
            'description'   => $validated['description'],
            'lat'           => $validated['lat'],
            'lng'           => $validated['lng'],
            'location_text' => $validated['location_text'] ?? null,
            'report_type'   => $validated['report_type'],
            'severity'      => $validated['severity'] ?? 'medium',
            'area_affected' => $validated['area_affected'] ?? null,
            'trees_lost'    => $validated['trees_lost'] ?? null,
            'photo_path'    => $photoPath,
        ]);

        // update user report count
        if ($request->user()) {
            $request->user()->increment('total_reports');
        }

        return response()->json([
            'message' => 'Laporan berhasil dikirim dan menunggu verifikasi.',
            'report'  => $report->load('user:id,name,avatar'),
        ], 201);
    }

    // -------------------------------------------------------
    // GET /reports/{id}
    // -------------------------------------------------------
    public function show($id)
    {
        $report = Report::with([
            'user:id,name,avatar,total_trees_planted',
            'comments.user:id,name,avatar',
        ])->findOrFail($id);

        return response()->json($report);
    }

    // -------------------------------------------------------
    // PUT /reports/{id} — admin only or own report (pending)
    // -------------------------------------------------------
    public function update(Request $request, $id)
    {
        $report = Report::findOrFail($id);

        // only admin or report owner (if still pending) can edit
        $user = $request->user();
        if (!$user->isAdmin() && ($report->user_id !== $user->id || $report->status !== 'pending')) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }

        $validated = $request->validate([
            'status'      => 'sometimes|in:pending,verified,resolved,rejected',
            'admin_notes' => 'sometimes|nullable|string',
            'title'       => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
        ]);

        $report->update($validated);

        return response()->json(['message' => 'Laporan diperbarui.', 'report' => $report]);
    }

    // -------------------------------------------------------
    // DELETE /reports/{id}
    // -------------------------------------------------------
    public function destroy(Request $request, $id)
    {
        $report = Report::findOrFail($id);
        $user = $request->user();

        if (!$user->isAdmin() && $report->user_id !== $user->id) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }

        if ($report->photo_path) {
            Storage::disk('public')->delete($report->photo_path);
        }

        $report->delete();
        return response()->json(['message' => 'Laporan dihapus.']);
    }

    // -------------------------------------------------------
    // POST /reports/{id}/vote
    // -------------------------------------------------------
    public function vote(Request $request, $id)
    {
        $report = Report::findOrFail($id);
        $userId = $request->user()->id;

        $existing = ReportVote::where('report_id', $id)->where('user_id', $userId)->first();

        if ($existing) {
            $existing->delete();
            $report->decrement('upvotes');
            return response()->json(['message' => 'Vote dicabut.', 'upvotes' => $report->upvotes]);
        }

        ReportVote::create(['report_id' => $id, 'user_id' => $userId]);
        $report->increment('upvotes');

        return response()->json(['message' => 'Vote ditambahkan.', 'upvotes' => $report->upvotes]);
    }

    // -------------------------------------------------------
    // POST /reports/{id}/comments
    // -------------------------------------------------------
    public function addComment(Request $request, $id)
    {
        $report = Report::findOrFail($id);
        $validated = $request->validate(['body' => 'required|string|max:1000']);

        $comment = ReportComment::create([
            'report_id' => $id,
            'user_id'   => $request->user()->id,
            'body'      => $validated['body'],
        ]);

        return response()->json([
            'message' => 'Komentar ditambahkan.',
            'comment' => $comment->load('user:id,name,avatar'),
        ], 201);
    }

    // -------------------------------------------------------
    // GET /stats — dashboard stats
    // -------------------------------------------------------
    public function stats()
    {
        $stats = [
            'total_reports'         => Report::count(),
            'verified_reports'      => Report::where('status', 'verified')->count(),
            'critical_reports'      => Report::where('severity', 'critical')->count(),
            'total_trees_lost'      => Report::whereNotNull('trees_lost')->sum('trees_lost'),
            'total_area_affected'   => Report::whereNotNull('area_affected')->sum('area_affected'),
            'reports_by_type'       => Report::select('report_type', DB::raw('count(*) as count'))
                                            ->groupBy('report_type')->get(),
            'reports_by_month'      => Report::select(
                                            DB::raw("DATE_FORMAT(created_at, '%Y-%m') as month"),
                                            DB::raw('count(*) as count')
                                        )->groupBy('month')->orderBy('month')->get(),
        ];

        return response()->json($stats);
    }
}
