# Environment Setup Guide

This guide walks you through setting up two simulation environments for CCNA practice on macOS.

---

## Environment 1: Containerlab (Docker-Based Labs)

Containerlab lets you run network topologies using Docker containers. We use **FRRouting (FRR)** for router simulation and **Alpine Linux** containers for hosts.

### Prerequisites

- macOS 12+ (Monterey or later)
- 8 GB RAM minimum (16 GB recommended)
- 20 GB free disk space

### Step 1: Install Docker Desktop

1. Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/)
2. Install and launch it
3. In Docker Desktop → Settings → Resources:
   - Set Memory to **4 GB+**
   - Set CPUs to **2+**
4. Verify:
   ```bash
   docker --version
   # Expected: Docker version 24.x or later
   ```

### Step 2: Install Containerlab

```bash
# Install via Homebrew
brew install containerlab

# Verify installation
containerlab version
```

If Homebrew doesn't have it, use the official installer:
```bash
bash -c "$(curl -sL https://get.containerlab.dev)"
```

### Step 3: Pull Required Docker Images

```bash
# FRRouting — our router simulation (supports OSPF, BGP, static routes, etc.)
docker pull frrouting/frr:latest

# Alpine Linux — lightweight hosts for ping/traffic generation
docker pull alpine:latest

# Network multitool — hosts with networking tools pre-installed
docker pull wbitt/network-multitool:latest

# ISC DHCP Server
docker pull networkboot/dhcpd:latest

# Syslog server
docker pull balabit/syslog-ng:latest
```

### Step 4: Verify Everything Works

```bash
# Deploy a test topology
cat <<'EOF' > /tmp/test-topo.yml
name: test
topology:
  nodes:
    router1:
      kind: linux
      image: frrouting/frr:latest
    host1:
      kind: linux
      image: alpine:latest
  links:
    - endpoints: ["router1:eth1", "host1:eth1"]
EOF

sudo containerlab deploy -t /tmp/test-topo.yml
sudo containerlab destroy -t /tmp/test-topo.yml
echo "✅ Containerlab is working!"
```

---

## Environment 2: Cisco Packet Tracer

Packet Tracer is Cisco's official free simulation tool. It's required for Cisco-specific features like VLANs, STP, port security, and wireless.

### Why You Need Packet Tracer Too

Containerlab uses Linux/FRR networking which is functionally equivalent to Cisco IOS for many topics, but Cisco's exam tests **Cisco IOS CLI syntax** specifically. Packet Tracer gives you:
- Exact Cisco IOS command syntax practice
- Switch-specific features (VLANs, STP, port security, EtherChannel)
- Wireless LAN Controller simulation
- The same environment used in Cisco Networking Academy courses

### Installation

1. Create a free account at [Cisco Networking Academy](https://www.netacad.com/)
2. Navigate to **Resources → Download Packet Tracer**
3. Download the macOS version and install
4. Launch and sign in with your NetAcad account

### Cisco Modeling Labs (CML) — Optional, Paid

If you want the **exact** environment Cisco uses for exam simlets:
- **Cisco CML Personal** — $199/year
- Runs actual Cisco IOS/IOS-XE images in VMs
- Download from [Cisco Learning Network](https://learningnetworkstore.cisco.com/cisco-modeling-labs-personal/cisco-cml-personal)
- Requires a bare-metal Linux host or ESXi (not Docker-compatible)

> **Recommendation:** Start with Containerlab + Packet Tracer. Only purchase CML if you want 100% Cisco IOS fidelity and have the budget.

---

## Key Containerlab Commands

```bash
# Deploy a topology
sudo containerlab deploy -t topology.yml

# Destroy a topology (clean up)
sudo containerlab destroy -t topology.yml

# List running labs
sudo containerlab inspect --all

# Connect to a container
docker exec -it <container-name> bash    # for hosts
docker exec -it <container-name> vtysh   # for FRR routers

# View container logs
docker logs <container-name>
```

## Key FRRouting (vtysh) Commands

FRR's `vtysh` shell uses Cisco IOS-style commands:

```
vtysh              # Enter the CLI (like Cisco IOS)
show ip route      # Display routing table
show ip ospf neighbor  # OSPF neighbors
show running-config    # Running configuration
configure terminal     # Enter config mode
```

### FRR ↔ Cisco IOS Command Comparison

| Task | Cisco IOS | FRR (vtysh) |
|------|-----------|-------------|
| Enter config mode | `configure terminal` | `configure terminal` |
| Set interface IP | `ip address 10.0.0.1 255.255.255.0` | `ip address 10.0.0.1/24` |
| Enable OSPF | `router ospf 1` | `router ospf` |
| OSPF network | `network 10.0.0.0 0.0.0.255 area 0` | `network 10.0.0.0/24 area 0` |
| Show routes | `show ip route` | `show ip route` |
| Show interfaces | `show ip interface brief` | `show interface brief` |
| Save config | `copy running-config startup-config` | `write memory` |

> Most commands are identical or very similar. The main differences are subnet mask format (dotted-decimal vs. CIDR) and minor syntax variations.

---

## Troubleshooting

### "Permission denied" when running containerlab
```bash
# Containerlab needs root privileges for network namespace management
sudo containerlab deploy -t topology.yml
```

### Docker containers can't reach each other
```bash
# Check that links are up
docker exec -it <container> ip link show
docker exec -it <container> ip addr show

# Verify routes
docker exec -it <container> ip route
```

### FRR daemons not starting
```bash
# Check which daemons are enabled
docker exec -it <container> cat /etc/frr/daemons

# Restart FRR
docker exec -it <container> service frr restart
```

### Packet Tracer won't install on newer macOS
- Ensure you download the latest version (8.2+)
- If blocked by Gatekeeper: System Preferences → Security & Privacy → "Open Anyway"

---

## Next Step

Once your environment is set up, start with **[Week 1 — OSI & TCP/IP Models](../week-01/concepts.md)**.
