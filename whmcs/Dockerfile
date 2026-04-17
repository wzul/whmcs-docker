FROM php:8.4-apache

# Set working directory inside the container
WORKDIR /var/www/html

# Install system dependencies required for PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libicu-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libxml2-dev \
    curl \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install required PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    mysqli pdo_mysql curl mbstring gd xml zip intl soap

# Download and install IonCube Loader
RUN curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.zip -o /tmp/ioncube.zip \
    && unzip /tmp/ioncube.zip -d /tmp/ \
    && mkdir -p /usr/local/lib/php/extensions/ioncube \
    && cp /tmp/ioncube/ioncube_loader_lin_8.4.so /usr/local/lib/php/extensions/ioncube/ioncube.so \
    && rm -rf /tmp/ioncube /tmp/ioncube.zip

# Create IonCube configuration file
RUN echo "zend_extension=/usr/local/lib/php/extensions/ioncube/ioncube.so" > /usr/local/etc/php/conf.d/00-ioncube.ini

# Enable Apache rewrite module
RUN a2enmod rewrite

# Configure Apache to allow .htaccess overrides and set up Basic Auth
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Add Basic Auth configuration to Apache
RUN echo '<Directory "/var/www/html">' >> /etc/apache2/apache2.conf \
    && echo '    AuthType Basic' >> /etc/apache2/apache2.conf \
    && echo '    AuthName "Restricted Content"' >> /etc/apache2/apache2.conf \
    && echo '    AuthUserFile /var/www/.htpasswd' >> /etc/apache2/apache2.conf \
    && echo '    SetEnvIf Request_URI "^/modules/gateways/callback/chip\.php$" allow_without_auth' >> /etc/apache2/apache2.conf \
    && echo '    Order Deny,Allow' >> /etc/apache2/apache2.conf \
    && echo '    Deny from all' >> /etc/apache2/apache2.conf \
    && echo '    Satisfy Any' >> /etc/apache2/apache2.conf \
    && echo '    Allow from env=allow_without_auth' >> /etc/apache2/apache2.conf \
    && echo '    Require valid-user' >> /etc/apache2/apache2.conf \
    && echo '</Directory>' >> /etc/apache2/apache2.conf

# Set appropriate permissions for the web directory
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy and set up the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install unzip for the entrypoint script
RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
