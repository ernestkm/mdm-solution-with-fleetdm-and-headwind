# Unified MDM Solution

A comprehensive Mobile Device Management (MDM) platform that integrates multiple open-source MDM solutions into a single, unified management interface.

## Overview

The Unified MDM Solution combines the strengths of FleetDM, Headwind MDM, and MicroMDM to provide a single pane of glass for managing diverse device ecosystems. This Docker-based platform offers simplified deployment with integrations for monitoring and management across various operating systems and device types.

### Key Features

- **Unified Dashboard**: Manage all devices from a single web interface
- **Multi-Platform Support**: iOS, Android, macOS, Windows, and Linux device management
- **Containerized Architecture**: Easily deployable via Docker Compose
- **Monitoring & Reporting**: Integrated Grafana dashboards and Prometheus metrics
- **Scalable Design**: Separate database services for different components to enable scaling

## Architecture

The solution is built using a microservices architecture with Docker containers:

```
┌─────────────────────────────────────────────────────────────────┐
│                           NGINX Proxy                           │
└───────────────────────────────┬─────────────────────────────────┘
                                │
    ┌─────────────────┬─────────┴──────────┬─────────────────┐
    │                 │                    │                 │
┌───▼───┐       ┌─────▼────┐        ┌─────▼─────┐     ┌─────▼─────┐
│FleetDM│       │Headwind  │        │ MicroMDM  │     │React      │
│       │       │MDM       │        │           │     │Frontend   │
└───┬───┘       └─────┬────┘        └─────┬─────┘     └─────┬─────┘
    │                 │                   │                 │
    └────────┬────────┴───────┬───────────┴─────────┬──────┘
             │                │                     │
         ┌───▼───┐       ┌───▼────┐           ┌────▼───┐
         │Postgres│       │ MySQL  │           │ Redis  │
         │       │       │        │           │        │
         └───────┘       └────────┘           └────────┘
             │                                     │
    ┌────────▼─────────┐                  ┌────────▼─────────┐
    │    Prometheus    │◄─────────────────┤     Grafana      │
    └──────────────────┘                  └──────────────────┘
```

## Supported Device Platforms

- **iOS/iPadOS**: Via MicroMDM
- **Android**: Via Headwind MDM
- **macOS**: Via FleetDM and MicroMDM
- **Windows**: Via FleetDM
- **Linux**: Via FleetDM

## Prerequisites

- Docker Engine (20.10+)
- Docker Compose V2
- At least 4GB RAM
- 20GB of free disk space
- Internet connectivity for container images
- Valid domain name (for SSL certificates)

## Setup and Installation

### Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/unified-mdm-solution.git
   cd unified-mdm-solution
   ```

2. Configure environment variables:
   ```bash
   cp unified-mdm/.env.example unified-mdm/.env
   # Edit the .env file with your configuration
   ```

3. Generate SSL certificates:
   ```bash
   cd unified-mdm/config/nginx
   ./ssl-setup.sh your-domain.com
   cd ../../
   ```

4. Start the services:
   ```bash
   ./start.sh
   ```

5. Access the unified dashboard:
   ```
   https://your-domain.com/
   ```

### Advanced Configuration

For detailed configuration options, see the individual component documentation in their respective directories.

## Component Descriptions

### API Gateway
- Node.js/Express service that unifies access to all MDM platforms
- Handles authentication, authorization, and request routing
- Location: `unified-mdm/api`

### Frontend
- React application with Material UI components
- Provides the unified management dashboard
- Location: `unified-mdm/frontend`

### FleetDM
- Open-source device management for macOS, Windows, and Linux
- Provides osquery-based device monitoring and management
- Location: `unified-mdm/fleetdm`

### Headwind MDM
- Android-focused device management platform
- Supports application distribution and policy enforcement
- Location: `unified-mdm/headwind-mdm`

### MicroMDM
- Apple MDM server for iOS, iPadOS, and macOS
- Handles Apple-specific device enrollment and management
- Location: `unified-mdm/micromdm`

### Monitoring
- Prometheus for metrics collection
- Grafana for visualization and dashboards
- Location: `unified-mdm/prometheus` and `unified-mdm/grafana`

## Usage Instructions

### Device Enrollment

#### iOS/iPadOS (via MicroMDM)
1. Navigate to `Devices > Add Device > iOS/iPadOS`
2. Generate enrollment profile
3. Send the enrollment link to device users

#### Android (via Headwind MDM)
1. Navigate to `Devices > Add Device > Android`
2. Follow the QR code enrollment process

#### macOS/Windows/Linux (via FleetDM)
1. Navigate to `Devices > Add Device > Desktop`
2. Download the appropriate installer
3. Run the installer on target systems

### Device Management

1. Navigate to `Devices` to view all registered devices
2. Use filters to view devices by platform, status, or compliance
3. Select a device to view details and available actions
4. Apply policies through the `Policies` section

### Reporting

1. Access built-in reports via `Reports` section
2. View Grafana dashboards for advanced visualizations at `https://your-domain.com/grafana`
3. Export reports in CSV or PDF format

## Maintenance and Troubleshooting

### Backup
Use the provided backup script to create a complete system backup:
```bash
./backup.sh
```

This creates a timestamped backup of all databases and configuration files.

### Logs
- View container logs:
  ```bash
  docker compose -f unified-mdm/docker-compose.yml logs [service-name]
  ```

- Common services to check:
  - `api` - API gateway issues
  - `frontend` - UI problems
  - `nginx` - Connection/proxy issues
  - Individual MDM components (`fleetdm`, `headwind-mdm`, `micromdm`)

### Common Issues

#### Connection Refused
- Verify NGINX is running: `docker compose ps nginx`
- Check SSL certificate validity
- Ensure ports are properly exposed

#### Device Not Appearing
- Check enrollment status in the specific MDM system
- Verify network connectivity from device to MDM server
- Check for enrollment errors in the specific MDM logs

#### Database Issues
- Use database-specific tools to verify connection:
  ```bash
  docker compose exec postgres psql -U postgres -d fleetdm
  docker compose exec mysql mysql -u root -p headwind
  ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.
