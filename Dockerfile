FROM php:8.2-fpm

# Install sistem dependensi & Nginx
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    nginx

# Install ekstensi PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copy Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copy semua file project
COPY . .

# --- PERBAIKAN START ---

# 1. Buat folder storage secara paksa agar Laravel tidak bingung
RUN mkdir -p /var/www/storage/framework/cache/data \
             /var/www/storage/framework/sessions \
             /var/www/storage/framework/views \
             /var/www/storage/logs \
             /var/www/bootstrap/cache

# 2. Perbaiki Permission (Gunakan -R untuk Recursive)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# 3. Install dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# 4. Bersihkan cache lama yang mungkin terbawa dari laptop
RUN php artisan config:clear
RUN php artisan view:clear

# --- PERBAIKAN END ---

EXPOSE 80

# Jalankan server dengan port dinamis dari Railway
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-80}
