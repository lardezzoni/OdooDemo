You need to install wkhtmltopdf

 install a compatible version of wkhtmltopdf that works with your system's libraries. For Ubuntu 22.04 (Jammy Jellyfish), the wkhtmltox_0.12.6.1-2.jammy_amd64.deb package is suitable.

Steps to Install:

    Download the Compatible Package:

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb

Install the Package Using apt:

sudo apt install ./wkhtmltox_0.12.6.1-2.jammy_amd64.deb

wkhtmltopdf --version

You should see the installed version (e.g., wkhtmltopdf 0.12.6).
3. Configure Wkhtmltopdf in Odoo

If Odoo cannot detect wkhtmltopdf automatically, you may need to specify its path.

    Open your Odoo configuration file (e.g., odoo.conf):

sudo nano /etc/odoo/odoo.conf

Add or update the following line to point to the wkhtmltopdf binary:

[options]
...
wkhtmltopdf_path = /usr/local/bin/wkhtmltopdf  # Update path as needed

Save the file and restart Odoo:

sudo systemctl restart odoo
