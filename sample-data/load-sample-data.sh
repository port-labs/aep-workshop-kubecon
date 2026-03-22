#!/bin/bash

# Load sample data into Port for the workshop demo
# 
# Prerequisites:
# - PORT_CLIENT_ID and PORT_CLIENT_SECRET environment variables set
# - jq installed
# - curl installed

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🚀 Loading sample data into Port..."

# Check prerequisites
if [ -z "$PORT_CLIENT_ID" ] || [ -z "$PORT_CLIENT_SECRET" ]; then
    echo -e "${RED}Error: PORT_CLIENT_ID and PORT_CLIENT_SECRET must be set${NC}"
    echo "Export them before running this script:"
    echo "  export PORT_CLIENT_ID='your-client-id'"
    echo "  export PORT_CLIENT_SECRET='your-client-secret'"
    exit 1
fi

# Get Port API token
echo "🔑 Getting API token..."
TOKEN_RESPONSE=$(curl -s -X POST "https://api.getport.io/v1/auth/access_token" \
    -H "Content-Type: application/json" \
    -d "{\"clientId\": \"$PORT_CLIENT_ID\", \"clientSecret\": \"$PORT_CLIENT_SECRET\"}")

PORT_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.accessToken')

if [ "$PORT_TOKEN" == "null" ] || [ -z "$PORT_TOKEN" ]; then
    echo -e "${RED}Error: Failed to get API token${NC}"
    echo $TOKEN_RESPONSE
    exit 1
fi

echo -e "${GREEN}✓ Got API token${NC}"

# Function to create entity
create_entity() {
    local blueprint=$1
    local entity=$2
    local identifier=$(echo $entity | jq -r '.identifier')
    
    echo "  Creating $blueprint: $identifier..."
    
    RESPONSE=$(curl -s -X POST "https://api.getport.io/v1/blueprints/$blueprint/entities?upsert=true" \
        -H "Authorization: Bearer $PORT_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$entity")
    
    if echo $RESPONSE | jq -e '.ok == true' > /dev/null 2>&1; then
        echo -e "    ${GREEN}✓ Created${NC}"
    else
        echo -e "    ${YELLOW}⚠ Warning: $(echo $RESPONSE | jq -r '.message // "Unknown error"')${NC}"
    fi
}

# Load environments first (no dependencies)
echo ""
echo "📦 Loading environments..."
for entity in $(cat environments.json | jq -c '.entities[]'); do
    create_entity "environment" "$entity"
done

# Load services
echo ""
echo "📦 Loading services..."
for entity in $(cat services.json | jq -c '.entities[]'); do
    create_entity "service" "$entity"
done

# Load deployments (depends on services and environments)
echo ""
echo "📦 Loading deployments..."
for entity in $(cat deployments.json | jq -c '.entities[]'); do
    create_entity "deployment" "$entity"
done

# Load on-call schedules (depends on services)
echo ""
echo "📦 Loading on-call schedules..."
for entity in $(cat oncall-schedules.json | jq -c '.entities[]'); do
    create_entity "oncall_schedule" "$entity"
done

echo ""
echo -e "${GREEN}✅ Sample data loaded successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Open Port and verify the data appears"
echo "2. Check the On-Call Dashboard"
echo "3. You're ready for the demo!"
