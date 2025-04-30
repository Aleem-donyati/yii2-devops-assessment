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
    chmod -R 775 /var/www/basic

# Copy application files (assuming you'll have the Yii2 app at the root)
COPY ./app/basic /var/www/basic

# Ensure correct ownership of all files
RUN chown -R yii2:www-data /var/www/basic

# Switch to yii2 user and install dependencies
USER yii2
WORKDIR /var/www/basic

# Install with relaxed permissions to avoid errors
RUN composer install --no-interaction --no-dev --ignore-platform-reqs || \
    (chmod -R 777 /var/www/basic/vendor && composer install --no-interaction --no-dev --ignore-platform-reqs)

# Set proper file permissions
USER root
RUN chmod -R 755 /var/www/basic/web
RUN chmod -R 775 /var/www/basic/web/assets /var/www/basic/runtime

# Configure PHP-FPM
COPY ./docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/www.conf

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:9000/ping || exit 1

EXPOSE 9000
CMD ["php-fpm"]
