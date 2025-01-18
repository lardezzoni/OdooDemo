FROM odoo:18.0

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pytest \
    python3-psycopg2 \
    gettext-base \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create a dedicated user with specific UID/GID
RUN usermod -u 100 odoo && groupmod -g 101 odoo

# Create necessary directories
RUN mkdir -p /var/log/odoo \
    /var/lib/odoo \
    /mnt/efs \
    /mnt/efs/filestore \
    /mnt/efs/sessions \
    /mnt/efs/addons \
    /opt/odoo/custom_addons

# Set correct ownership
RUN chown -R 100:101 /var/log/odoo \
    /var/lib/odoo \
    /opt/odoo/custom_addons \
    /mnt/efs \
    && chmod -R 775 /var/log/odoo \
    /var/lib/odoo \
    /opt/odoo/custom_addons \
    /mnt/efs

# Copy configuration and entrypoint
COPY config/odoo.conf /etc/odoo/odoo.conf.template
COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    chown 100:101 /entrypoint.sh /etc/odoo/odoo.conf.template

USER 100:101

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]