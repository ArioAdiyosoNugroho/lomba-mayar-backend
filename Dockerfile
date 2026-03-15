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

COPY . .

# --- BAGIAN YANG DIRUBAH/DITAMBAH ---

# 1. Pastikan folder storage dan bootstrap/cache ada
RUN mkdir -p /var/www/storage/framework/cache/data \
             /var/www/storage/framework/sessions \
             /var/www/storage/framework/views \
             /var/www/storage/logs \
             /var/www/bootstrap/cache

# 2. Perbaiki permission (Gunakan -R, bukan -W)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# 3. Install dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# 4. Clear cache sebelum deploy untuk menghindari "View path not found"
RUN php artisan config:clear
RUN php artisan view:clear

# --- SELESAI PERUBAHAN ---

EXPOSE 80

# Railway biasanya membutuhkan PORT dari environment variable
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-80}
