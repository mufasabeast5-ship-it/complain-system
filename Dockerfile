FROM php:8.2-apache

# Install pdo_mysql for database connection
RUN docker-php-ext-install pdo pdo_mysql

# Enable mod_rewrite
RUN a2enmod rewrite

# Aggressively remove ALL MPM config files so there's no conflict,
# then re-enable only mpm_prefork
RUN rm -f /etc/apache2/mods-enabled/mpm_*.load \
          /etc/apache2/mods-enabled/mpm_*.conf && \
    ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load && \
    ln -s /etc/apache2/mods-available/mpm_prefork.conf /etc/apache2/mods-enabled/mpm_prefork.conf

# Suppress ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Point document root directly to the api/ subfolder
ENV APACHE_DOCUMENT_ROOT /var/www/html/api
RUN sed -i 's|/var/www/html|/var/www/html/api|g' /etc/apache2/sites-available/000-default.conf

# Allow .htaccess overrides in the api folder
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# Default port (Railway overrides this at runtime via $PORT)
ENV PORT=80

# Copy custom entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Copy all project files into the container
COPY . /var/www/html

# Fix file permissions
RUN chown -R www-data:www-data /var/www/html

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
