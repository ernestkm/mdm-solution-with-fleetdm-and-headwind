#!/bin/bash

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner for the unified MDM solution
echo -e "${BLUE}"
echo "██╗   ██╗███╗   ██╗██╗███████╗██╗███████╗██████╗     ███╗   ███╗██████╗ ███╗   ███╗"
echo "██║   ██║████╗  ██║██║██╔════╝██║██╔════╝██╔══██╗    ████╗ ████║██╔══██╗████╗ ████║"
echo "██║   ██║██╔██╗ ██║██║█████╗  ██║█████╗  ██║  ██║    ██╔████╔██║██║  ██║██╔████╔██║"
echo "██║   ██║██║╚██╗██║██║██╔══╝  ██║██╔══╝  ██║  ██║    ██║╚██╔╝██║██║  ██║██║╚██╔╝██║"
echo "╚██████╔╝██║ ╚████║██║██║     ██║███████╗██████╔╝    ██║ ╚═╝ ██║██████╔╝██║ ╚═╝ ██║"
echo " ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚══════╝╚═════╝     ╚═╝     ╚═╝╚═════╝ ╚═╝     ╚═╝"
echo -e "${NC}"
echo -e "${GREEN}Starting the Unified MDM Platform...${NC}"

# Load environment variables
source .env
echo -e "${GREEN}Loaded environment variables${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi
echo -e "${GREEN}Docker is running${NC}"

# Create directories if they don't exist
mkdir -p ./data/postgres
mkdir -p ./data/mysql
mkdir -p ./data/redis
mkdir -p ./data/prometheus
mkdir -p ./data/grafana
mkdir -p ./logs
echo -e "${GREEN}Created necessary directories${NC}"

# Check for certificates and generate if they don't exist
if [ ! -d "./config/nginx/certs" ]; then
    echo -e "${YELLOW}SSL certificates not found. Generating self-signed certificates...${NC}"
    ./config/nginx/ssl-setup.sh
    echo -e "${GREEN}Generated self-signed SSL certificates${NC}"
else
    echo -e "${GREEN}SSL certificates found${NC}"
fi

# Start the containers
echo -e "${BLUE}Starting Docker containers...${NC}"
docker-compose up -d

# Wait for databases to be ready
echo -e "${YELLOW}Waiting for databases to be ready...${NC}"
sleep 10

# Initialize databases
echo -e "${BLUE}Initializing databases...${NC}"
docker-compose exec -T postgres bash -c "psql -U \$POSTGRES_USER -d \$POSTGRES_DB -f /docker-entrypoint-initdb.d/init-postgres.sql"
docker-compose exec -T mysql bash -c "mysql -u \$MYSQL_USER -p\$MYSQL_PASSWORD \$MYSQL_DATABASE < /docker-entrypoint-initdb.d/init-mysql.sql"

# Initialize MDM systems
echo -e "${BLUE}Initializing Fleet MDM...${NC}"
docker-compose exec -T fleetdm /app/init.sh

echo -e "${BLUE}Initializing Headwind MDM...${NC}"
docker-compose exec -T headwind-mdm /app/init.sh

echo -e "${BLUE}Initializing MicroMDM...${NC}"
docker-compose exec -T micromdm /app/init.sh

# Check if all services are up
echo -e "${YELLOW}Checking if all services are up...${NC}"
sleep 10

ALL_UP=true
declare -a services=("api" "frontend" "postgres" "mysql" "redis" "fleetdm" "headwind-mdm" "micromdm" "nginx" "prometheus" "grafana")

for service in "${services[@]}"; do
    STATUS=$(docker-compose ps -q $service | xargs docker inspect -f '{{.State.Running}}' 2>/dev/null)
    
    if [ "$STATUS" != "true" ]; then
        echo -e "${RED}$service is not running!${NC}"
        ALL_UP=false
    else
        echo -e "${GREEN}$service is running${NC}"
    fi
done

# Check API health
echo -e "${YELLOW}Checking API health...${NC}"
API_HEALTH=$(curl -s -k https://localhost:${NGINX_PORT:-8443}/api/health)

if [ "$API_HEALTH" = '{"status":"ok"}' ]; then
    echo -e "${GREEN}API is healthy${NC}"
else
    echo -e "${RED}API health check failed!${NC}"
    ALL_UP=false
fi

# Final status message
if [ "$ALL_UP" = true ]; then
    echo -e "${GREEN}"
    echo "✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓"
    echo "✓                                             ✓"
    echo "✓  Unified MDM Platform started successfully! ✓"
    echo "✓                                             ✓"
    echo "✓  Access the platform at:                    ✓"
    echo "✓  https://localhost:${NGINX_PORT}                  ✓"
    echo "✓                                             ✓"
    echo "✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓✓"
    echo -e "${NC}"
else
    echo -e "${RED}"
    echo "✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗"
    echo "✗                                             ✗"
    echo "✗  Some services failed to start!             ✗"
    echo "✗  Check the logs for more information        ✗"
    echo "✗                                             ✗"
    echo "✗  Run 'docker-compose logs' for details      ✗"
    echo "✗                                             ✗"
    echo "✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗✗"
    echo -e "${NC}"
    exit 1
fi