#!/bin/bash
set -e

# Disable conflicting MPMs and ensure only prefork is active
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Set the port dynamically — Railway injects $PORT at runtime
PORT=${PORT:-80}
echo "Starting Apache on port $PORT"

# Update Apache config with the actual port value
sed -i "s/Listen 80/Listen $PORT/g" /etc/apache2/ports.conf
sed -i "s/<VirtualHost \*:80>/<VirtualHost *:$PORT>/g" /etc/apache2/sites-available/000-default.conf

# Start Apache in the foreground
exec apache2-foreground
