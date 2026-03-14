<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tree extends Model
{
    protected $fillable = [
        'donation_id', 'species', 'latitude', 'longitude',
        'location_name', 'planted_at', 'status',
    ];

    protected $casts = [
        'latitude'  => 'float',
        'longitude' => 'float',
        'planted_at' => 'datetime',
    ];

    public function donation()
    {
        return $this->belongsTo(Donation::class);
    }
}
