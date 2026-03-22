FROM php:8.2-apache

# Install and enable the pdo_mysql extension for database connection
RUN docker-php-ext-install pdo pdo_mysql

# Enable Apache mod_rewrite for nice URLs (if ever needed)
RUN a2enmod rewrite

# Update Apache DocumentRoot to point directly to /var/www/html
# (which will contain our PHP files)
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Expose port 80
EXPOSE 80

# Keep default apache foreground command
CMD ["apache2-foreground"]
