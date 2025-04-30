FROM php:8.3-fpm

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

# Install PHP extensions required by Yii2
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Yii Commands
RUN useradd -G www-data,root -u 1000 -d /home/yii2 yii2
RUN mkdir -p /home/yii2/.composer && \
    chown -R yii2:yii2 /home/yii2

# Set working directory
WORKDIR /var/www

# Create app directories with proper permissions
RUN mkdir -p /var/www/basic/web/assets /var/www/basic/runtime && \
    chown -R yii2:www-data /var/www/basic && \
    chmod -R 775 /var/www/basic/web/assets /var/www/basic/runtime

# Copy application files (assuming you'll have the Yii2 app at the root)
COPY --chown=yii2:www-data ./app/basic /var/www/basic

# Install dependencies as yii2 user
USER yii2
WORKDIR /var/www/basic
RUN composer install --no-interaction

# Set proper file permissions
USER root
RUN chown -R yii2:www-data /var/www/basic
RUN chmod -R 755 /var/www/basic/web/assets /var/www/basic/runtime

# Configure PHP-FPM
COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000
CMD ["php-fpm"]
