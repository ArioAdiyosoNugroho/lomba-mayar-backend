<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('reports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->onDelete('set null');
            $table->string('title');
            $table->text('description');
            $table->decimal('lat', 10, 7);
            $table->decimal('lng', 10, 7);
            $table->string('location_text')->nullable();
            $table->enum('report_type', [
                'sawit_expansion',
                'illegal_logging',
                'forest_fire',
                'land_clearing',
                'mining',
                'other'
            ]);
            $table->string('photo_path')->nullable();
            $table->decimal('area_affected', 10, 2)->nullable()->comment('in hectares');
            $table->integer('trees_lost')->nullable();
            $table->enum('severity', ['low', 'medium', 'high', 'critical'])->default('medium');
            $table->enum('status', ['pending', 'verified', 'resolved', 'rejected'])->default('pending');
            $table->text('admin_notes')->nullable();
            $table->integer('upvotes')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};
