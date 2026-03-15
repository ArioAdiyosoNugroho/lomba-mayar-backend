FROM php:8.2-fpm

# Install sistem dependensi
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    nginx

# Install ekstensi PHP yang dibutuhkan Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Copy Composer dari image resmi
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy semua file project
COPY . .

# Install dependencies (no-dev untuk production)
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Atur permission agar folder storage bisa diakses
RUN chown -W www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port yang digunakan Render
EXPOSE 80

# Jalankan server (Gunakan script sederhana atau serve)
CMD php artisan serve --host=0.0.0.0 --port=80
