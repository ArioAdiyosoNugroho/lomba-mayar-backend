<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Report;
use App\Models\Donation;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Admin user
        $admin = User::create([
            'name'     => 'Admin Forest Guardian',
            'email'    => 'admin@forestguardian.id',
            'password' => Hash::make('password123'),
            'role'     => 'admin',
        ]);

        // Sample users
        $users = [];
        $names = ['Budi Santoso', 'Siti Rahayu', 'Agus Pratama', 'Dewi Lestari', 'Riko Firmansyah'];
        foreach ($names as $name) {
            $users[] = User::create([
                'name'     => $name,
                'email'    => strtolower(str_replace(' ', '.', $name)) . '@gmail.com',
                'password' => Hash::make('password123'),
            ]);
        }

        // Sample reports
        $reportData = [
            [
                'title'       => 'Pembukaan Lahan Sawit Ilegal di Kalimantan Tengah',
                'description' => 'Ditemukan pembukaan lahan besar-besaran untuk perkebunan sawit di kawasan hutan lindung. Estimasi luas area yang terpengaruh sekitar 50 hektar.',
                'lat'         => -2.2161,
                'lng'         => 113.9213,
                'report_type' => 'sawit_expansion',
                'severity'    => 'critical',
                'area_affected' => 50.0,
                'trees_lost'  => 2500,
                'status'      => 'verified',
            ],
            [
                'title'       => 'Kebakaran Hutan di Riau',
                'description' => 'Kebakaran hutan terdeteksi di kawasan gambut Riau. Api sudah menyebar ke area sekitar 20 hektar.',
                'lat'         => 0.5071,
                'lng'         => 101.4478,
                'report_type' => 'forest_fire',
                'severity'    => 'critical',
                'area_affected' => 20.0,
                'trees_lost'  => 1000,
                'status'      => 'verified',
            ],
            [
                'title'       => 'Penebangan Liar di Sumatera Utara',
                'description' => 'Aktivitas penebangan kayu ilegal ditemukan di kawasan hutan Leuser. Terlihat beberapa truk keluar membawa kayu log.',
                'lat'         => 3.5952,
                'lng'         => 98.6722,
                'report_type' => 'illegal_logging',
                'severity'    => 'high',
                'area_affected' => 10.0,
                'trees_lost'  => 500,
                'status'      => 'pending',
            ],
            [
                'title'       => 'Ekspansi Sawit Mengancam Orangutan di Kalimantan Barat',
                'description' => 'Perluasan kebun sawit di dekat kawasan konservasi orangutan. Habitat terancam rusak.',
                'lat'         => -0.0236,
                'lng'         => 109.3424,
                'report_type' => 'sawit_expansion',
                'severity'    => 'high',
                'area_affected' => 30.0,
                'trees_lost'  => 1500,
                'status'      => 'verified',
            ],
            [
                'title'       => 'Pertambangan Ilegal Merusak DAS Mahakam',
                'description' => 'Aktivitas pertambangan batu bara ilegal ditemukan di dekat sungai Mahakam, Kalimantan Timur.',
                'lat'         => 0.1198,
                'lng'         => 117.4,
                'report_type' => 'mining',
                'severity'    => 'high',
                'area_affected' => 15.0,
                'trees_lost'  => 750,
                'status'      => 'pending',
            ],
        ];

        foreach ($reportData as $i => $data) {
            Report::create(array_merge($data, [
                'user_id'       => $users[$i % count($users)]->id,
                'location_text' => 'Indonesia',
            ]));
        }

        // Sample paid donations
        foreach ($users as $i => $user) {
            $amount = ($i + 1) * 25000;
            $trees  = Donation::calculateTrees($amount);
            Donation::create([
                'user_id'        => $user->id,
                'amount'         => $amount,
                'currency'       => 'IDR',
                'mayar_order_id' => 'ord_sample_' . ($i + 1),
                'status'         => 'paid',
                'trees_count'    => $trees,
                'donor_name'     => $user->name,
                'donor_email'    => $user->email,
                'paid_at'        => now()->subDays($i),
            ]);

            $user->total_trees_planted = $trees;
            $user->total_reports = 1;
            $user->save();
        }
    }
}
