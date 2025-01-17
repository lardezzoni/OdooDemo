FROM odoo:18.0
USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3-pytest \
    python3-psycopg2 \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*
#s3 bucket add on

RUN pip3 install --no-cache-dir boto3
RUN git clone --branch 16.0 https://github.com/OCA/server-tools.git /tmp/server-tools \
    && mv /tmp/server-tools/ir_attachment_s3 /opt/odoo/custom_addons/ \
    && rm -rf /tmp/server-tools
RUN chown -R odoo:odoo /opt/odoo/custom_addons/ir_attachment_s3

# Create ALL necessary directories with proper permissions
RUN mkdir -p /var/log/odoo \
    /var/lib/odoo \
    /var/lib/odoo/filestore \
    /var/lib/odoo/sessions \
    /opt/odoo/custom_addons \
    && chown -R odoo:odoo /var/log/odoo \
    /var/lib/odoo \
    /opt/odoo/custom_addons \
    && chmod -R 777 /var/lib/odoo \
    /opt/odoo/custom_addons \
    && chmod -R g+s /var/lib/odoo  # Add sticky bit to maintain permissions

# Add a healthcheck to verify directory permissions
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD test -w /var/lib/odoo/filestore && \
        test -w /var/lib/odoo/sessions && \
        test -w /opt/odoo/custom_addons || exit 1

# Copy and configure odoo.conf
COPY config/odoo.conf /etc/odoo/
RUN chown odoo:odoo /etc/odoo/odoo.conf

# Set environment variables
ENV HOST_DB=${DB_HOST} \
    PORT_DB=${DB_PORT} \
    USER_DB=${DB_USER} \
    PASS_DB=${DB_PASSWORD} \
    NAME_DB=${DB_NAME} \
    ADMIN_PASSWORD=${ADMIN_PASSWORD} \
    S3_BUCKET=${S3_NAME} \
    S3_REGION=${S3_REGION} \
    S3_ACCESS_KEY=${S3_ACCESS_KEY} \
    S3_SECRET_KEY=${S3_SECRET_KEY}
# Process configuration
RUN envsubst < /etc/odoo/odoo.conf > /etc/odoo/odoo.conf.tmp && \
    mv /etc/odoo/odoo.conf.tmp /etc/odoo/odoo.conf && \
    chown odoo:odoo /etc/odoo/odoo.conf

USER odoo