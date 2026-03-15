<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Report extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'title',
        'description',
        'lat',
        'lng',
        'location_text',
        'report_type',
        'photo_path',
        'area_affected',
        'trees_lost',
        'severity',
        'status',
        'admin_notes',
        'upvotes',
    ];

    protected $casts = [
        'lat' => 'float',
        'lng' => 'float',
        'area_affected' => 'float',
        'trees_lost' => 'integer',
        'upvotes' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function comments()
    {
        return $this->hasMany(ReportComment::class);
    }

    public function votes()
    {
        return $this->hasMany(ReportVote::class);
    }

    public function getPhotoUrlAttribute(): ?string
    {
        if (!$this->photo_path) return null;
        // Cloudinary sudah return full https:// URL
        // Kalau masih path lama (sebelum Cloudinary), pakai asset()
        if (str_starts_with($this->photo_path, 'http')) {
            return $this->photo_path;
        }
        return str_replace('http://', 'https://', asset('storage/' . $this->photo_path));
    }

    public function getReportTypeLabelAttribute(): string
    {
        return match($this->report_type) {
            'sawit_expansion' => 'Ekspansi Sawit',
            'illegal_logging' => 'Penebangan Liar',
            'forest_fire'     => 'Kebakaran Hutan',
            'land_clearing'   => 'Pembukaan Lahan',
            'mining'          => 'Pertambangan',
            default           => 'Lainnya',
        };
    }

    protected $appends = ['photo_url', 'report_type_label'];
}
