#!/bin/bash
set -e

# Disable conflicting MPMs and ensure only prefork is active
a2dismod mpm_event mpm_worker 2>/dev/null || true
a2enmod mpm_prefork 2>/dev/null || true

# Railway sets $PORT at runtime (currently Port 8000 as configured)
PORT=${PORT:-8000}
echo "Starting Apache on port $PORT"

# Use robust regex to replace ANY existing port value (80, 8080, ${PORT}, etc.)
sed -i -E "s/^Listen .*/Listen $PORT/" /etc/apache2/ports.conf
sed -i -E "s/<VirtualHost \*:[^>]+>/<VirtualHost *:$PORT>/" /etc/apache2/sites-available/000-default.conf

# Print config for debugging
echo "=== ports.conf ==="
grep "Listen" /etc/apache2/ports.conf
echo "=== VirtualHost ==="
grep "VirtualHost" /etc/apache2/sites-available/000-default.conf

# Start Apache in the foreground
exec apache2-foreground
