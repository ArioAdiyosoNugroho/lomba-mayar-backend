-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 15, 2026 at 01:57 AM
-- Server version: 8.0.30
-- PHP Version: 8.3.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `forest_guardian_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `donations`
--

CREATE TABLE `donations` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `amount` int NOT NULL COMMENT 'in IDR smallest unit',
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'IDR',
  `mayar_order_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mayar_payment_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','paid','failed','expired','refunded') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `trees_count` int NOT NULL DEFAULT '0' COMMENT 'calculated from amount',
  `donor_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `donor_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `donor_message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `checkout_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donations`
--

INSERT INTO `donations` (`id`, `user_id`, `amount`, `currency`, `mayar_order_id`, `mayar_payment_id`, `status`, `trees_count`, `donor_name`, `donor_email`, `donor_message`, `checkout_url`, `paid_at`, `created_at`, `updated_at`) VALUES
(1, 1, 25000, 'IDR', NULL, NULL, 'pending', 5, 'ryoseille everhard', 'test@example.com', NULL, NULL, NULL, '2026-03-13 06:37:33', '2026-03-13 06:37:33'),
(2, 1, 5000, 'IDR', NULL, NULL, 'pending', 1, 'ryoseille everhard', 'test@example.com', NULL, NULL, NULL, '2026-03-13 06:38:38', '2026-03-13 06:38:38'),
(3, 1, 25000, 'IDR', NULL, NULL, 'pending', 5, 'ryoseille everhard', 'test@example.com', NULL, NULL, NULL, '2026-03-13 07:08:53', '2026-03-13 07:08:53'),
(5, 1, 25000, 'IDR', '6e24a710-6181-4cfd-8f13-5fa217289e74', NULL, 'pending', 5, 'ryo', 'test@example.com', NULL, 'https://arrn-93272.myr.id/invoices/d2vn868fye', NULL, '2026-03-14 05:57:39', '2026-03-14 05:57:43'),
(6, 1, 25000, 'IDR', 'a5b86771-8189-4d14-a6db-082b251d89ad', NULL, 'pending', 5, 'coba bg', 'arioadiyoso@gmail.com', 'hidup!!!', 'https://arrn-93272.myr.id/invoices/p538wuudnl', NULL, '2026-03-14 06:00:07', '2026-03-14 06:00:09'),
(7, 1, 500000, 'IDR', '83bb9c24-7355-4b02-9880-b21f5c05d6d3', NULL, 'pending', 100, 'ryoseille everhard', 'test@example.com', NULL, 'https://arrn-93272.myr.id/invoices/gyos97sht2', NULL, '2026-03-14 06:47:30', '2026-03-14 06:47:32'),
(8, 2, 25000, 'IDR', '5581acad-097d-4102-a7c0-445a3656e25c', NULL, 'pending', 5, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, 'https://arrn-93272.myr.id/invoices/xgryyffrng', NULL, '2026-03-14 09:00:55', '2026-03-14 09:00:56'),
(9, 2, 25000, 'IDR', '1f17162c-862d-4877-9756-d70cb94b7486', NULL, 'pending', 5, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, 'https://arrn-93272.myr.id/invoices/5ev2gwhrbx', NULL, '2026-03-14 12:33:31', '2026-03-14 12:33:33'),
(10, 2, 25000, 'IDR', 'DEMO-YLKIPTRO', NULL, 'paid', 5, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, 'http://localhost:5173/donation/success', '2026-03-14 13:00:32', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(11, 2, 5000, 'IDR', 'DEMO-EJUMYLWT', NULL, 'paid', 1, 'Admin Forest Guardian', 'admin@forestguardian.id', 'halo semuanya', 'http://localhost:5173/donation/success', '2026-03-14 13:07:15', '2026-03-14 13:07:15', '2026-03-14 13:07:15'),
(12, 2, 25000, 'IDR', 'DEMO-VOT9BC48', NULL, 'paid', 5, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, 'http://localhost:5173/donation/success', '2026-03-14 13:24:06', '2026-03-14 13:24:06', '2026-03-14 13:24:06'),
(13, 2, 25000, 'IDR', 'c5c9b496-f3c1-41c2-a77f-c5980634db9c', NULL, 'pending', 5, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, 'https://arrn-93272.myr.id/invoices/y38n5jvwl8', NULL, '2026-03-14 13:27:37', '2026-03-14 13:27:39');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2024_01_01_000000_create_users_table', 1),
(2, '2024_01_01_000001_create_reports_table', 1),
(3, '2024_01_01_000002_create_donations_table', 1),
(4, '2024_01_01_000003_create_trees_votes_comments', 1),
(5, '2026_03_13_125820_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(7, 'App\\Models\\User', 2, 'auth_token', '6d4eae3cab4e517b8392a0ee25789bf25724108d5134539192717674a2c9f154', '[\"*\"]', '2026-03-14 18:57:17', NULL, '2026-03-14 12:25:27', '2026-03-14 18:57:17');

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `lat` decimal(10,7) NOT NULL,
  `lng` decimal(10,7) NOT NULL,
  `location_text` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `report_type` enum('sawit_expansion','illegal_logging','forest_fire','land_clearing','mining','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `area_affected` decimal(10,2) DEFAULT NULL COMMENT 'in hectares',
  `trees_lost` int DEFAULT NULL,
  `severity` enum('low','medium','high','critical') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'medium',
  `status` enum('pending','verified','resolved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_notes` text COLLATE utf8mb4_unicode_ci,
  `upvotes` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `user_id`, `title`, `description`, `lat`, `lng`, `location_text`, `report_type`, `photo_path`, `area_affected`, `trees_lost`, `severity`, `status`, `admin_notes`, `upvotes`, `created_at`, `updated_at`) VALUES
(1, 1, 'naywit nih orang', 'ngawit  njir, toloooong!!!!', '-7.5788000', '110.9831000', 'karanganyar', 'sawit_expansion', 'reports/p8rhIEnGfmfDZBtQtFZR2V4h2UsGfkMRPW6o4FeN.jpg', '20.00', 200, 'high', 'verified', NULL, 2, '2026-03-14 06:08:41', '2026-03-14 12:32:15'),
(2, 1, 'sadasdasd', 'asdasdasdasdsdadasdasd', '-7.5788000', '110.9831000', NULL, 'sawit_expansion', 'reports/xSBIKRtvAe7olqSHgTd2DDQiEVAxVhPkzNOLSHpf.jpg', '12.00', 123, 'medium', 'rejected', NULL, 0, '2026-03-14 06:38:31', '2026-03-14 07:05:55'),
(3, 1, 'woi sawit', 'sadadasdasdasdasddasd', '-7.6168800', '110.9630280', NULL, 'sawit_expansion', 'reports/U88VPmcojGVtCe1iKW7dACeToa4aktHeVGEvTUUI.jpg', '21.00', 323, 'medium', 'rejected', NULL, 0, '2026-03-14 06:48:09', '2026-03-14 07:05:53'),
(4, 2, 'tes', 'tes wowok pecinta sawit ganti bensin jadi sawit muach', '-7.5788000', '110.9831000', 'tes', 'forest_fire', 'reports/MygJrkXMMkZV4JKgZ0zbyvItevi9fwFvtC9BOcWo.gif', '21.00', 2323, 'critical', 'verified', NULL, 1, '2026-03-14 07:08:49', '2026-03-14 07:13:19'),
(5, 1, 'Kebakaran Lahan Gambut', 'Terpantau titik api besar di area lahan gambut yang berdekatan dengan konsesi sawit.', '0.5004110', '101.4472200', 'Pekanbaru, Riau', 'forest_fire', NULL, '120.50', 4500, 'critical', 'verified', NULL, 145, '2026-03-14 14:19:12', '2026-03-14 14:19:12'),
(6, 1, 'Pembalakan Liar Kayu Ulin', 'Aktivitas truk pengangkut kayu ilegal terpantau keluar masuk hutan lindung saat malam hari.', '-2.2083330', '113.9166670', 'Palangkaraya, Kalimantan Tengah', 'illegal_logging', NULL, '45.00', 800, 'high', 'verified', NULL, 89, '2026-03-14 14:19:12', '2026-03-14 14:19:12'),
(7, 1, 'Pembukaan Lahan Ilegal di Lereng Gunung', 'Terdapat pembukaan lahan yang dicurigai tanpa izin di area sabuk hijau pegunungan yang rawan longsor.', '-7.6278200', '111.1920150', 'Karanganyar, Jawa Tengah', 'land_clearing', NULL, '5.20', 150, 'medium', 'verified', NULL, 56, '2026-03-14 14:19:12', '2026-03-14 14:19:12'),
(8, 1, 'Limbah Tambang Merusak Vegetasi', 'Area hutan pesisir mulai mati akibat perluasan area tambang nikel yang tidak direklamasi.', '-2.7150000', '121.9430000', 'Morowali, Sulawesi Tengah', 'mining', NULL, '350.75', 12000, 'critical', 'verified', NULL, 210, '2026-03-14 14:19:12', '2026-03-14 07:19:51'),
(9, 2, 'Pembabatan Hutan Adat', 'Hutan primer mulai dibabat menggunakan alat berat untuk pembukaan lahan perkebunan sawit baru.', '-8.4891670', '140.4013890', 'Merauke, Papua Selatan', 'sawit_expansion', NULL, '500.00', 25000, 'critical', 'verified', NULL, 340, '2026-03-14 14:19:12', '2026-03-14 14:19:12'),
(10, 2, 'Alih Fungsi Kawasan Konservasi', 'Penebangan pohon di area resapan air untuk dijadikan kawasan villa komersial.', '-6.7360000', '107.0360000', 'Cianjur, Jawa Barat', 'other', NULL, '2.50', 80, 'low', 'verified', NULL, 24, '2026-03-14 14:19:12', '2026-03-14 14:19:12'),
(11, 2, 'lapor', 'asdasdasdasdfasdwaasdasdasd', '-7.6168980', '110.9629990', 'karnaganyar', 'illegal_logging', 'reports/dsYEkI3bdL9M6leo7f5BB4IcqwIZBubkUDVF6rXl.jpg', '12.00', 231, 'high', 'verified', NULL, 1, '2026-03-14 13:06:11', '2026-03-14 13:48:00');

-- --------------------------------------------------------

--
-- Table structure for table `report_comments`
--

CREATE TABLE `report_comments` (
  `id` bigint UNSIGNED NOT NULL,
  `report_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `report_comments`
--

INSERT INTO `report_comments` (`id`, `report_id`, `user_id`, `body`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'sawit', '2026-03-14 06:08:54', '2026-03-14 06:08:54'),
(2, 1, 2, 'mana sawitmu', '2026-03-14 12:32:22', '2026-03-14 12:32:22');

-- --------------------------------------------------------

--
-- Table structure for table `report_votes`
--

CREATE TABLE `report_votes` (
  `id` bigint UNSIGNED NOT NULL,
  `report_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `report_votes`
--

INSERT INTO `report_votes` (`id`, `report_id`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 1, 1, '2026-03-14 06:09:03', '2026-03-14 06:09:03'),
(8, 4, 2, '2026-03-14 07:13:19', '2026-03-14 07:13:19'),
(12, 1, 2, '2026-03-14 12:32:15', '2026-03-14 12:32:15'),
(13, 11, 2, '2026-03-14 13:48:00', '2026-03-14 13:48:00');

-- --------------------------------------------------------

--
-- Table structure for table `trees`
--

CREATE TABLE `trees` (
  `id` bigint UNSIGNED NOT NULL,
  `donation_id` bigint UNSIGNED NOT NULL,
  `species` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Pohon Lokal Asli',
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `location_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `planted_at` timestamp NULL DEFAULT NULL,
  `status` enum('allocated','planted','growing') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'allocated',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `trees`
--

INSERT INTO `trees` (`id`, `donation_id`, `species`, `latitude`, `longitude`, `location_name`, `planted_at`, `status`, `created_at`, `updated_at`) VALUES
(1, 10, 'Pohon Lokal Asli', '-2.5293000', '112.1879000', 'Kalimantan Tengah', '2026-03-14 13:00:32', 'planted', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(2, 10, 'Tengkawang', '-2.5146000', '112.1892000', 'Kalimantan Tengah', '2026-03-14 13:00:32', 'planted', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(3, 10, 'Bangkirai', '-2.5030000', '112.1374000', 'Kalimantan Tengah', '2026-03-14 13:00:32', 'planted', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(4, 10, 'Ramin', '-2.5240000', '112.1064000', 'Kalimantan Tengah', '2026-03-14 13:00:32', 'planted', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(5, 10, 'Tengkawang', '-2.5842000', '112.1874000', 'Kalimantan Tengah', '2026-03-14 13:00:32', 'planted', '2026-03-14 13:00:32', '2026-03-14 13:00:32'),
(6, 11, 'Pohon Lokal Asli', '-0.8286000', '104.7240000', 'Sumatera Selatan', '2026-03-14 13:07:15', 'planted', '2026-03-14 13:07:15', '2026-03-14 13:07:15'),
(7, 12, 'Pohon Lokal Asli', '-2.5087000', '112.1788000', 'Kalimantan Tengah', '2026-03-14 13:24:06', 'planted', '2026-03-14 13:24:06', '2026-03-14 13:24:06'),
(8, 12, 'Meranti', '-2.5646000', '112.1173000', 'Kalimantan Tengah', '2026-03-14 13:24:06', 'planted', '2026-03-14 13:24:06', '2026-03-14 13:24:06'),
(9, 12, 'Jelutung', '-2.5884000', '112.1420000', 'Kalimantan Tengah', '2026-03-14 13:24:06', 'planted', '2026-03-14 13:24:06', '2026-03-14 13:24:06'),
(10, 12, 'Pohon Lokal Asli', '-2.5624000', '112.0983000', 'Kalimantan Tengah', '2026-03-14 13:24:06', 'planted', '2026-03-14 13:24:06', '2026-03-14 13:24:06'),
(11, 12, 'Ulin', '-2.5104000', '112.1329000', 'Kalimantan Tengah', '2026-03-14 13:24:06', 'planted', '2026-03-14 13:24:06', '2026-03-14 13:24:06');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('user','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_trees_planted` int NOT NULL DEFAULT '0',
  `total_reports` int NOT NULL DEFAULT '0',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `avatar`, `total_trees_planted`, `total_reports`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'ryoseille everhard', 'test@example.com', NULL, '$2y$12$L9cKdr8IDdjWSHOapogfI.SXGOEEnAoh4EbQwWczHoSam/bQfH6Fy', 'user', NULL, 0, 3, NULL, '2026-03-13 06:37:25', '2026-03-14 06:48:09'),
(2, 'Admin Forest Guardian', 'admin@forestguardian.id', NULL, '$2y$12$nAC7gouJjsCMOlr0naKk..o9AcxKjs4CI5yIxQA.xmPENOKAQqVqu', 'admin', NULL, 11, 4, NULL, '2026-03-14 06:51:26', '2026-03-14 13:24:06');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `donations`
--
ALTER TABLE `donations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `donations_mayar_order_id_unique` (`mayar_order_id`),
  ADD KEY `donations_user_id_foreign` (`user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reports_user_id_foreign` (`user_id`);

--
-- Indexes for table `report_comments`
--
ALTER TABLE `report_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_comments_report_id_foreign` (`report_id`),
  ADD KEY `report_comments_user_id_foreign` (`user_id`);

--
-- Indexes for table `report_votes`
--
ALTER TABLE `report_votes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `report_votes_report_id_user_id_unique` (`report_id`,`user_id`),
  ADD KEY `report_votes_user_id_foreign` (`user_id`);

--
-- Indexes for table `trees`
--
ALTER TABLE `trees`
  ADD PRIMARY KEY (`id`),
  ADD KEY `trees_donation_id_foreign` (`donation_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `donations`
--
ALTER TABLE `donations`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `report_comments`
--
ALTER TABLE `report_comments`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `report_votes`
--
ALTER TABLE `report_votes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `trees`
--
ALTER TABLE `trees`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `donations`
--
ALTER TABLE `donations`
  ADD CONSTRAINT `donations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `report_comments`
--
ALTER TABLE `report_comments`
  ADD CONSTRAINT `report_comments_report_id_foreign` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `report_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `report_votes`
--
ALTER TABLE `report_votes`
  ADD CONSTRAINT `report_votes_report_id_foreign` FOREIGN KEY (`report_id`) REFERENCES `reports` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `report_votes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `trees`
--
ALTER TABLE `trees`
  ADD CONSTRAINT `trees_donation_id_foreign` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
