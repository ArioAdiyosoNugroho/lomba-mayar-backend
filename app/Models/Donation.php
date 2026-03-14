<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Donation extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'amount',
        'currency',
        'mayar_order_id',
        'mayar_payment_id',
        'status',
        'trees_count',
        'donor_name',
        'donor_email',
        'donor_message',
        'checkout_url',
        'paid_at',
    ];

    protected $casts = [
        'amount' => 'integer',
        'trees_count' => 'integer',
        'paid_at' => 'datetime',
    ];

    // 1 tree per Rp 5.000
    const PRICE_PER_TREE = 5000;

    public static function calculateTrees(int $amount): int
    {
        return (int) floor($amount / self::PRICE_PER_TREE);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function trees()
    {
        return $this->hasMany(Tree::class);
    }

    public function getAmountFormattedAttribute(): string
    {
        return 'Rp ' . number_format($this->amount, 0, ',', '.');
    }

    protected $appends = ['amount_formatted'];
}
