# Dockerfile
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/yii2 yii2
RUN mkdir -p /home/yii2/.composer && \
    chown -R yii2:yii2 /home/yii2

# Set working directory
WORKDIR /var/www

# Install Yii2 basic application
USER yii2
RUN composer create-project --prefer-dist yiisoft/yii2-app-basic basic

# Switch back to root for permissions
USER root
RUN chown -R yii2:www-data /var/www/basic
RUN chmod -R 755 /var/www/basic/web/assets /var/www/basic/runtime

# Configure PHP-FPM
COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000
CMD ["php-fpm"]