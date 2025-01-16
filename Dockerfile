# Dockerfile
FROM odoo:16.0

# Install additional dependencies if needed
USER root
RUN pip3 install --no-cache-dir pytest psycopg2-binary
RUN apt-get update && apt-get install -y gettext-base

# Create necessary directories
RUN mkdir -p /var/log/odoo && \
    chown -R odoo:odoo /var/log/odoo

# Copy the configuration file from local path
COPY config/odoo.conf /etc/odoo/
RUN chown odoo:odoo /etc/odoo/odoo.conf

# Set environment variables (these will be overridden by ECS task definition)
ENV HOST_DB=database-3.c1cucakco5hd.sa-east-1.rds.amazonaws.com
ENV PORT_DB=5432
ENV USER_DB=odoo_admin
ENV PASS_DB=odoo_admin123
ENV NAME_DB=odoo128
ENV ADMIN_PASSWORD=admin

# Replace variables in the config file
RUN envsubst < /etc/odoo/odoo.conf > /etc/odoo/odoo.conf.tmp && \
    mv /etc/odoo/odoo.conf.tmp /etc/odoo/odoo.conf && \
    chown odoo:odoo /etc/odoo/odoo.conf

# Switch back to odoo user
USER odoo