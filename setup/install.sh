#!/bin/bash
# CCNA Lab Environment — macOS Install Script
# Run: chmod +x install.sh && ./install.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "=========================================="
echo "  CCNA Lab Environment Setup — macOS"
echo "=========================================="
echo ""

# --- Check Docker ---
echo -n "Checking Docker... "
if command -v docker &> /dev/null; then
    echo -e "${GREEN}Found$(docker --version)${NC}"
else
    echo -e "${RED}Not found${NC}"
    echo "Please install Docker Desktop from https://www.docker.com/products/docker-desktop/"
    echo "Then re-run this script."
    exit 1
fi

# --- Check Docker is running ---
echo -n "Checking Docker daemon... "
if docker info &> /dev/null; then
    echo -e "${GREEN}Running${NC}"
else
    echo -e "${RED}Docker is installed but not running. Please start Docker Desktop.${NC}"
    exit 1
fi

# --- Install Containerlab ---
echo -n "Checking Containerlab... "
if command -v containerlab &> /dev/null; then
    echo -e "${GREEN}Found ($(containerlab version 2>&1 | head -1))${NC}"
else
    echo -e "${YELLOW}Not found — installing...${NC}"
    if command -v brew &> /dev/null; then
        brew install containerlab
    else
        echo "Installing via official script..."
        bash -c "$(curl -sL https://get.containerlab.dev)"
    fi
    echo -e "${GREEN}Containerlab installed${NC}"
fi

# --- Pull Docker Images ---
echo ""
echo "Pulling required Docker images..."
echo ""

IMAGES=(
    "frrouting/frr:latest"
    "alpine:latest"
    "wbitt/network-multitool:latest"
)

for img in "${IMAGES[@]}"; do
    echo -n "  Pulling $img... "
    if docker pull "$img" > /dev/null 2>&1; then
        echo -e "${GREEN}Done${NC}"
    else
        echo -e "${RED}Failed (you can try manually: docker pull $img)${NC}"
    fi
done

# --- Verify ---
echo ""
echo "=========================================="
echo "  Verification"
echo "=========================================="
echo ""
echo "Docker:       $(docker --version)"
echo "Containerlab: $(containerlab version 2>&1 | head -1)"
echo ""
echo "Docker Images:"
docker images --format "  {{.Repository}}:{{.Tag}}" | grep -E "frr|alpine|multitool" || true

echo ""
echo -e "${GREEN}=========================================="
echo "  Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Also install Cisco Packet Tracer (see ENVIRONMENT-SETUP.md)"
echo "  2. Start Week 1: cd ../week-01/lab/"
echo "  3. Deploy:        sudo containerlab deploy -t topology.yml"
echo ""
