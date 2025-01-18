#!/bin/bash
set -e

# Create odoo.conf directly with environment variables

cat > /etc/odoo/odoo.conf << EOF
[options]
admin_passwd = ${ADMIN_PASSWORD}
addons_path = /usr/lib/python3/dist-packages/odoo/addons,/opt/odoo/custom_addons
db_host = ${HOST_DB}
db_port = ${PORT_DB}
db_user = ${USER_DB}
db_password = ${PASS_DB}
db_name = ${NAME_DB}
log_level = debug
log_handler = [':DEBUG']
logfile = /var/log/odoo/odoo.log
log_db = False
log_db_level = debug
data_dir = /mnt/efs
session_dir = /mnt/efs/sessions
static_http_document_root = /usr/lib/python3/dist-packages/odoo/addons/web/static
assets_debug = True
proxy_mode = True
EOF

# Create necessary directories if they don't exist
for dir in filestore sessions addons; do
    if [ ! -d /mnt/efs/$dir ]; then
        mkdir -p /mnt/efs/$dir
    fi
done

# Debug: Print environment variables
echo "Environment variables:"
echo "DB_HOST: ${DB_HOST}"
echo "DB_PORT: ${DB_PORT}"
echo "DB_USER: ${DB_USER}"
echo "DB_NAME: ${DB_NAME}"

# Debug: Show generated config
echo "Generated odoo.conf:"
cat /etc/odoo/odoo.conf

# Run Odoo with the command from base image
exec "$@"