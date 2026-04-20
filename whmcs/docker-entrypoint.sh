#!/bin/sh
set -e

# Create .htpasswd from environment variable if provided
if [ -n "$HTPASSWD_CONTENT" ]; then
    echo "$HTPASSWD_CONTENT" > /var/www/.htpasswd
    chown www-data:www-data /var/www/.htpasswd
    chmod 644 /var/www/.htpasswd
fi

# Download and install CHIP for WHMCS if requested
CHIP_BRANCH=${CHIP_BRANCH:-main}
if [ "$INSTALL_CHIP" = "true" ]; then
    echo "Downloading CHIP for WHMCS (branch: $CHIP_BRANCH)..."
    echo "URL: https://github.com/CHIPAsia/chip-for-whmcs/archive/refs/heads/${CHIP_BRANCH}.zip"
    curl -fsSL "https://github.com/CHIPAsia/chip-for-whmcs/archive/refs/heads/${CHIP_BRANCH}.zip" -o /tmp/chip.zip
    unzip -q /tmp/chip.zip -d /tmp/
    
    # The extracted folder name will be chip-for-whmcs-<branch_name>
    # We need to find the actual folder name as it might vary (e.g. main vs master)
    EXTRACTED_DIR=$(find /tmp -maxdepth 1 -type d -name "chip-for-whmcs-*" | head -n 1)
    
    if [ -d "$EXTRACTED_DIR" ]; then
        echo "Installing CHIP modules to /var/www/html/modules..."
        if [ -d "$EXTRACTED_DIR/modules" ]; then
            cp -rv "$EXTRACTED_DIR/modules"/* /var/www/html/modules/
            chown -R www-data:www-data /var/www/html/modules/
            echo "CHIP modules installed successfully."
        else
            echo "Error: modules directory not found in extracted CHIP archive."
        fi
        rm -rf "$EXTRACTED_DIR" /tmp/chip.zip
    else
        echo "Error: Could not find extracted CHIP directory."
    fi
fi

# Execute the original command
exec "$@"
