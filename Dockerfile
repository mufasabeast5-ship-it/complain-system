FROM php:8.2-apache

# Install and enable the pdo_mysql extension for database connection
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite for nice URLs (if ever needed)
RUN a2enmod rewrite

# Fix for "More than one MPM loaded" error
# Force disable event/worker and enable prefork
RUN a2dismod mpm_event mpm_worker || true \
    && a2enmod mpm_prefork

# Update Apache DocumentRoot to point directly to /var/www/html
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Set default port to 80, this can be overridden by Railway
ENV PORT=80

# Configure Apache to listen on the dynamic $PORT environment variable provided by Railway
RUN sed -i 's/80/${PORT}/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Keep default apache foreground command
CMD ["apache2-foreground"]
