<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Donation;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class DonationController extends Controller
{
    // POST /donations/order
    public function createOrder(Request $request)
    {
        $validated = $request->validate([
            'amount'        => 'required|integer|min:5000|max:100000000',
            'donor_name'    => 'nullable|string|max:191',
            'donor_email'   => 'nullable|email|max:191',
            'donor_message' => 'nullable|string|max:500',
        ]);

        $treesCount = Donation::calculateTrees($validated['amount']);

        $donation = Donation::create([
            'user_id'       => $request->user()?->id,
            'amount'        => $validated['amount'],
            'currency'      => 'IDR',
            'status'        => 'pending',
            'trees_count'   => $treesCount,
            'donor_name'    => $validated['donor_name']    ?? ($request->user()?->name  ?? 'Anonim'),
            'donor_email'   => $validated['donor_email']   ?? ($request->user()?->email ?? null),
            'donor_message' => $validated['donor_message'] ?? null,
        ]);

        $checkoutUrl = $this->createMayarPayment($donation);

        if (!$checkoutUrl) {
            $donation->delete();
            return response()->json(['message' => 'Gagal membuat order pembayaran. Coba lagi.'], 500);
        }

        $donation->checkout_url = $checkoutUrl;
        $donation->save();

        return response()->json([
            'donation_id'  => $donation->id,
            'checkout_url' => $checkoutUrl,
            'trees_count'  => $treesCount,
            'amount'       => $donation->amount_formatted,
        ]);
    }

    private function createMayarPayment(Donation $donation): ?string
    {
        $apiKey   = env('MAYAR_API_KEY');
        $frontUrl = env('FRONTEND_URL', 'http://localhost:5173');

        if (!$apiKey) {
            Log::error('MAYAR_API_KEY tidak diset di .env');
            return null;
        }

        $payload = [
            'name'        => $donation->donor_name ?? 'Donatur',
            'email'       => $donation->donor_email ?? 'donatur@forestguardian.id',
            'amount'      => (int) $donation->amount,
            'mobile'      => '08000000000',
            'description' => "Donasi #{$donation->id} - Tanam {$donation->trees_count} pohon di hutan Indonesia",
            'redirectUrl' => $frontUrl . '/donation/success?donation_id=' . $donation->id,
        ];

        try {
            $response = Http::withHeaders([
                'Authorization' => "Bearer {$apiKey}",
                'Accept'        => 'application/json',
                'Content-Type'  => 'application/json',
            ])->post('https://api.mayar.id/hl/v1/payment/create', $payload);

            Log::info('Mayar API Response', [
                'status'      => $response->status(),
                'body'        => $response->body(),
                'donation_id' => $donation->id,
            ]);

            if ($response->successful()) {
                $data    = $response->json();
                $orderId = $data['data']['id']   ?? $data['id']   ?? null;
                $link    = $data['data']['link']  ?? $data['link'] ?? null;

                if ($orderId) {
                    $donation->mayar_order_id = $orderId;
                    $donation->save();
                }

                return $link;
            }

            Log::error('Mayar API Error', [
                'http_status' => $response->status(),
                'response'    => $response->json(),
                'donation_id' => $donation->id,
            ]);

            return null;

        } catch (\Exception $e) {
            Log::error('Mayar Exception: ' . $e->getMessage());
            return null;
        }
    }

    public function show(Request $request, $id)
    {
        $donation = Donation::findOrFail($id);
        $isOwner  = $request->user()?->id === $donation->user_id;
        $isAdmin  = $request->user()?->isAdmin();
        $isPublic = $request->query('allow_public') === '1';

        if (!$isOwner && !$isAdmin && !$isPublic) {
            return response()->json(['message' => 'Tidak diizinkan.'], 403);
        }

        return response()->json($donation->load('trees'));
    }

    public function myDonations(Request $request)
    {
        return response()->json(
            $request->user()->donations()->orderBy('created_at', 'desc')->paginate(10)
        );
    }

    public function leaderboard()
    {
        $leaders = Donation::with('user:id,name,avatar')
            ->where('status', 'paid')
            ->select('user_id')
            ->selectRaw('SUM(trees_count) as total_trees')
            ->selectRaw('SUM(amount) as total_amount')
            ->selectRaw('COUNT(*) as donation_count')
            ->groupBy('user_id')
            ->orderByDesc('total_trees')
            ->limit(20)
            ->get()
            ->map(fn($item, $i) => [
                'rank'           => $i + 1,
                'user'           => $item->user,
                'total_trees'    => $item->total_trees,
                'total_amount'   => 'Rp ' . number_format($item->total_amount, 0, ',', '.'),
                'donation_count' => $item->donation_count,
            ]);

        return response()->json($leaders);
    }

    public function summary()
    {
        return response()->json([
            'total_trees_planted' => Donation::where('status', 'paid')->sum('trees_count'),
            'total_donors'        => Donation::where('status', 'paid')->distinct('user_id')->count('user_id'),
            'total_donated'       => Donation::where('status', 'paid')->sum('amount'),
            'total_donations'     => Donation::where('status', 'paid')->count(),
        ]);
    }
}
