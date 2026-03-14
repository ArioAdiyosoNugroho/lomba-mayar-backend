<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ReportController;
use App\Http\Controllers\Api\DonationController;
use App\Http\Controllers\Api\MayarWebhookController;
use App\Http\Controllers\Api\AdminController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// --------------------------------------------------
// Auth routes
// --------------------------------------------------
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login',    [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me',      [AuthController::class, 'me']);
    });
});

// --------------------------------------------------
// Public routes
// --------------------------------------------------
Route::get('/reports',          [ReportController::class, 'index']);
Route::get('/reports/map',      [ReportController::class, 'mapPins']);
Route::get('/reports/stats',    [ReportController::class, 'stats']);
Route::get('/reports/{id}',     [ReportController::class, 'show']);

Route::get('/donations/leaderboard', [DonationController::class, 'leaderboard']);
Route::get('/donations/summary',     [DonationController::class, 'summary']);

// PENTING: /donations/my harus SEBELUM /donations/{id}
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/donations/my', [DonationController::class, 'myDonations']);
});

Route::get('/donations/{id}', [DonationController::class, 'show']);

// --------------------------------------------------
// Mayar webhook (no auth — must be before sanctum group)
// --------------------------------------------------
Route::post('/webhooks/mayar', [MayarWebhookController::class, 'handle']);

// --------------------------------------------------
// Authenticated routes
// --------------------------------------------------
Route::middleware('auth:sanctum')->group(function () {

    // Reports
    Route::post('/reports',              [ReportController::class, 'store']);
    Route::put('/reports/{id}',          [ReportController::class, 'update']);
    Route::delete('/reports/{id}',       [ReportController::class, 'destroy']);
    Route::post('/reports/{id}/vote',    [ReportController::class, 'vote']);
    Route::post('/reports/{id}/comments',[ReportController::class, 'addComment']);

    // Donations
    Route::post('/donations/order',   [DonationController::class, 'createOrder']);
});

// --------------------------------------------------
// Admin routes
// --------------------------------------------------
Route::middleware(['auth:sanctum'])->prefix('admin')->group(function () {
    Route::get('/dashboard',         [AdminController::class, 'dashboard']);
    Route::get('/reports',           [AdminController::class, 'reports']);
    Route::put('/reports/{id}',      [AdminController::class, 'updateReport']);
    Route::get('/donations',         [AdminController::class, 'donations']);
});
