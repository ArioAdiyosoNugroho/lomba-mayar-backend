<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Report;
use App\Models\Donation;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AdminController extends Controller
{
    // Cek admin langsung di setiap method, bukan di constructor
    private function checkAdmin(Request $request)
    {
        if (!$request->user()?->isAdmin()) {
            abort(response()->json(['message' => 'Akses ditolak. Admin only.'], 403));
        }
    }

    public function dashboard(Request $request)
    {
        $this->checkAdmin($request);

        return response()->json([
            'users' => [
                'total'     => User::count(),
                'new_today' => User::whereDate('created_at', today())->count(),
            ],
            'reports' => [
                'total'    => Report::count(),
                'pending'  => Report::where('status', 'pending')->count(),
                'verified' => Report::where('status', 'verified')->count(),
                'resolved' => Report::where('status', 'resolved')->count(),
                'rejected' => Report::where('status', 'rejected')->count(),
            ],
            'donations' => [
                'total_paid'   => Donation::where('status', 'paid')->count(),
                'total_amount' => Donation::where('status', 'paid')->sum('amount'),
                'total_trees'  => Donation::where('status', 'paid')->sum('trees_count'),
                'pending'      => Donation::where('status', 'pending')->count(),
            ],
            'recent_reports'   => Report::with('user:id,name')->latest()->limit(5)->get(),
            'recent_donations' => Donation::with('user:id,name')
                                    ->where('status', 'paid')
                                    ->latest('paid_at')->limit(5)->get(),
        ]);
    }

    public function reports(Request $request)
    {
        $this->checkAdmin($request);

        $query = Report::with('user:id,name,email')->latest();

        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        return response()->json($query->paginate(20));
    }

    public function updateReport(Request $request, $id)
    {
        $this->checkAdmin($request);

        $report = Report::findOrFail($id);
        $validated = $request->validate([
            'status'      => 'required|in:pending,verified,resolved,rejected',
            'admin_notes' => 'nullable|string|max:1000',
        ]);

        $report->update($validated);
        return response()->json(['message' => 'Status laporan diperbarui.', 'report' => $report]);
    }

    public function donations(Request $request)
    {
        $this->checkAdmin($request);

        $query = Donation::with('user:id,name,email')->latest();

        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        return response()->json($query->paginate(20));
    }
}
