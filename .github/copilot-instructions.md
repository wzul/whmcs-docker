# WHMCS Docker Development Environment

This workspace is set up for WHMCS development using Docker.

## Project Overview
- **Purpose**: WHMCS development.
- **Stack**: PHP 8.3, Apache, IonCube Loader.
- **Deployment**: Intended for use with Dokploy.

## Key Conventions
- **License Reset**: WHMCS requires a license reset every time the Docker container is restarted.
- **Cron Jobs**: Instead of using Ofelia, cron jobs should be configured in the Dokploy scheduler.
  - Command: `php -q /var/www/html/crons/cron.php`
  - Frequency: Every 1 minute (`@every 1m`).
- **Security**: Basic Auth is enabled for the entire site except for the CHIP gateway callback.
  - Credentials: `username` / `password` (default)
  - Exception: `/modules/gateways/callback/chip.php` is allowed without authentication.

## File Structure
- `docker-compose.yml`: Main service definition.
- `whmcs/Dockerfile`: PHP 8.4 image with necessary extensions and Apache config.
- `whmcs/config/`: Configuration files (IonCube, Basic Auth).

## Development Workflow
- IonCube Loader is automatically downloaded during the Docker build process.
- CHIP for WHMCS is automatically downloaded and installed from GitHub during container startup if `INSTALL_CHIP=true`.
- Use named volumes for persistent WHMCS data.
