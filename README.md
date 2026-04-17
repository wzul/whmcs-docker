# WHMCS Docker Development Environment

This repository provides a Docker-based development environment for WHMCS, optimized for PHP 8.4 and Apache.

## Features
- **PHP 8.4** with required extensions (`mysqli`, `gd`, `intl`, `soap`, etc.).
- **IonCube Loader** support.
- **Basic Auth** protection for the entire site (with callback exceptions).
- **Dokploy Ready**: Designed for deployment on Dokploy.

## Prerequisites
- Docker and Docker Compose.
- WHMCS source files (to be placed in the volume or mapped).

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd whmcs-docker
   ```

2. **Set Environment Variables**:
   Create a `.env` file or set the following variables:
   - `HTPASSWD_CONTENT`: The content for the `.htpasswd` file (e.g., `user:$apr1$...`).
   - Default: `username` / `password`
   - `INSTALL_CHIP`: Set to `true` to automatically download and install CHIP for WHMCS (default: `true`).
   - `CHIP_BRANCH`: The branch to download from GitHub (default: `main`).
   - `DB_ROOT_PASSWORD`: Root password for MariaDB.
   - `DB_NAME`: Database name (default: `whmcs`).
   - `DB_USER`: Database user (default: `whmcs_user`).
   - `DB_PASSWORD`: Database password.

3. **Run the environment**:
   ```bash
   docker compose up -d
   ```
   *Note: The IonCube Loader is automatically downloaded and configured during the build process.*

## Dokploy Configuration
- **Port Mapping**: Ensure you set the service port to **80** in Dokploy to route traffic to the Apache web server.
- **Scheduler**: Configure the WHMCS cron in the Dokploy scheduler:
  - **Command**: `php -q /var/www/html/crons/cron.php`
  - **Schedule**: `@every 1m`

### WHMCS License Reset
WHMCS requires a license reset every time the Docker container is restarted. Ensure you have access to your WHMCS account to perform this.

### Cron Jobs (Dokploy)
Instead of using internal cron managers like Ofelia, configure the cron job in the **Dokploy Scheduler**:
- **Command**: `php -q /var/www/html/crons/cron.php`
- **Schedule**: `@every 1m`

### Security & Basic Auth
The entire site is protected by Basic Auth. However, the CHIP gateway callback is excluded to allow automated payments:
- **Excluded Path**: `/modules/gateways/callback/chip.php`

## Project Structure
- `docker-compose.yml`: Service definitions and volume mapping.
- `whmcs/Dockerfile`: PHP 8.4 + Apache configuration.
- `whmcs/docker-entrypoint.sh`: Handles dynamic `.htpasswd` creation.
- `whmcs/config/`: Configuration files for IonCube and PHP.
