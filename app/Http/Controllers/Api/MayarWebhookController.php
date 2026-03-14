<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Donation;
use App\Models\Tree;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class MayarWebhookController extends Controller
{
    public function handle(Request $request)
    {
        // 1. Verify Mayar signature
        $signature = $request->header('X-Mayar-Signature')
                  ?? $request->header('Authorization');
        $secret    = env('MAYAR_WEBHOOK_SECRET');

        if ($secret && $signature) {
            $expected = hash_hmac('sha256', $request->getContent(), $secret);
            if (!hash_equals($expected, ltrim($signature, 'Bearer '))) {
                Log::warning('Mayar webhook: invalid signature');
                return response()->json(['message' => 'Invalid signature.'], 400);
            }
        }

        $payload = $request->all();
        Log::info('Mayar Webhook Received', $payload);

        // 2. Parse payload — Mayar sends different shapes; handle both
        $orderId = $payload['data']['id']
                ?? $payload['order_id']
                ?? $payload['id']
                ?? null;

        $status  = $payload['data']['status']
                ?? $payload['status']
                ?? null;

        $event   = $payload['event']
                ?? $payload['type']
                ?? null;

        if (!$orderId) {
            return response()->json(['message' => 'No order ID.'], 200);
        }

        // 3. Find and update donation
        $donation = Donation::where('mayar_order_id', $orderId)->first();

        if (!$donation) {
            Log::warning("Mayar webhook: donation not found for order {$orderId}");
            return response()->json(['message' => 'Donation not found.'], 200);
        }

        // 4. Handle different events
        if (in_array($event, ['payment.success', 'payment.paid']) ||
            in_array($status, ['paid', 'completed', 'settlement'])) {

            if ($donation->status !== 'paid') {
                $donation->status   = 'paid';
                $donation->paid_at  = now();
                $donation->mayar_payment_id = $payload['data']['payment_id']
                                            ?? $payload['payment_id'] ?? null;
                $donation->save();

                // Create tree records
                $this->allocateTrees($donation);

                // Update user totals
                if ($donation->user) {
                    $donation->user->recalculateTotals();
                }

                Log::info("Donation #{$donation->id} marked as paid. Trees: {$donation->trees_count}");
            }

        } elseif (in_array($status, ['failed', 'canceled', 'cancelled'])) {
            $donation->status = 'failed';
            $donation->save();

        } elseif ($status === 'expired') {
            $donation->status = 'expired';
            $donation->save();
        }

        return response()->json(['ok' => true, 'message' => 'Webhook processed.']);
    }

    private function allocateTrees(Donation $donation): void
    {
        // Default locations for planting (Kalimantan, Sumatra, etc.)
        $locations = [
            ['lat' => -0.0236, 'lng' => 109.3424, 'name' => 'Kalimantan Barat'],
            ['lat' => -2.5489, 'lng' => 112.1396, 'name' => 'Kalimantan Tengah'],
            ['lat' => 0.7893,  'lng' => 113.9213, 'name' => 'Kalimantan Timur'],
            ['lat' => -0.7893, 'lng' => 104.7458, 'name' => 'Sumatera Selatan'],
            ['lat' => 3.5952,  'lng' => 98.6722,  'name' => 'Sumatera Utara'],
        ];

        $species = [
            'Meranti', 'Ulin', 'Tengkawang', 'Kapur', 'Bangkirai',
            'Pohon Gaharu', 'Ramin', 'Jelutung', 'Keruing', 'Pohon Lokal Asli'
        ];

        $loc = $locations[array_rand($locations)];

        for ($i = 0; $i < $donation->trees_count; $i++) {
            Tree::create([
                'donation_id'   => $donation->id,
                'species'       => $species[array_rand($species)],
                // slight random offset so trees don't stack on one pin
                'latitude'      => $loc['lat'] + (mt_rand(-500, 500) / 10000),
                'longitude'     => $loc['lng'] + (mt_rand(-500, 500) / 10000),
                'location_name' => $loc['name'],
                'planted_at'    => now(),
                'status'        => 'allocated',
            ]);
        }
    }
}
