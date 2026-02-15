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

# --- Install Containerlab (via Docker) ---
CLAB_IMAGE="ghcr.io/srl-labs/clab:latest"
CLAB_WRAPPER="/usr/local/bin/containerlab"

echo -n "Pulling Containerlab Docker image... "
if docker pull "$CLAB_IMAGE" > /dev/null 2>&1; then
    echo -e "${GREEN}Done${NC}"
else
    echo -e "${RED}Failed to pull $CLAB_IMAGE${NC}"
    exit 1
fi

echo -n "Installing containerlab wrapper script... "
sudo tee "$CLAB_WRAPPER" > /dev/null << 'WRAPPER'
#!/bin/bash
# Wrapper to run containerlab inside Docker on macOS
docker run --rm -it --privileged \
    --network host \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --pid="host" \
    -w "$(pwd)" \
    -v "$(pwd)":"$(pwd)" \
    ghcr.io/srl-labs/clab:latest containerlab "$@"
WRAPPER
sudo chmod +x "$CLAB_WRAPPER"
echo -e "${GREEN}Done (/usr/local/bin/containerlab)${NC}"

# --- Install lab helper script ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LAB_HELPER="/usr/local/bin/lab"

echo -n "Installing lab helper script... "
if [[ -f "$SCRIPT_DIR/lab" ]]; then
    sudo cp "$SCRIPT_DIR/lab" "$LAB_HELPER"
    sudo chmod +x "$LAB_HELPER"
    echo -e "${GREEN}Done (/usr/local/bin/lab)${NC}"
else
    echo -e "${YELLOW}Skipped (setup/lab not found)${NC}"
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
echo "  3. Deploy:        containerlab deploy -t topology.yml"
echo "  4. Connect:       lab ls          (list nodes)"
echo "                    lab pc1         (shell into pc1)"
echo "                    lab --all       (open all nodes in tabs)"
echo ""
