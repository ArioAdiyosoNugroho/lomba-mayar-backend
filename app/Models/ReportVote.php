<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ReportVote extends Model
{
    protected $fillable = ['report_id', 'user_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
