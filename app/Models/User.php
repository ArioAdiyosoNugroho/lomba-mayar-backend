<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'role',
        'avatar',
        'total_trees_planted',
        'total_reports',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function reports()
    {
        return $this->hasMany(Report::class);
    }

    public function donations()
    {
        return $this->hasMany(Donation::class);
    }

    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }

    public function recalculateTotals(): void
    {
        $this->total_trees_planted = $this->donations()->where('status', 'paid')->sum('trees_count');
        $this->total_reports = $this->reports()->whereIn('status', ['pending', 'verified'])->count();
        $this->save();
    }
}
