# Week 2 — Exercises: IPv4 Addressing & Subnetting

## Table of Contents
- [Lab Overview](#lab-overview)
- [Part A: Subnetting by Hand](#part-a-subnetting-by-hand)
- [Part B: Containerlab Lab — Multi-Subnet Routing](#part-b-containerlab-lab--multi-subnet-routing)
  - [Exercise 2: Deploy the Topology](#exercise-2-deploy-the-topology)
  - [Exercise 3: Verify IP Configuration](#exercise-3-verify-ip-configuration)
  - [Exercise 4: Verify Routing Tables](#exercise-4-verify-routing-tables)
  - [Exercise 5: Test Connectivity Across Subnets](#exercise-5-test-connectivity-across-subnets)
  - [Exercise 6: Observe Subnetting in Action](#exercise-6-observe-subnetting-in-action)
  - [Exercise 7: Explore the Router Configuration](#exercise-7-explore-the-router-configuration)
- [Part C: Cisco Packet Tracer Lab](#part-c-cisco-packet-tracer-lab)
- [Verification Checklist](#verification-checklist)

---

## Lab Overview

In this lab, you will:
1. Subnet a /24 into 4 equal subnets by hand
2. Build a 4-LAN routed topology in Containerlab
3. Configure IP addresses and routing between subnets
4. Verify connectivity across subnets
5. Practice the same in Cisco Packet Tracer

---

## Part A: Subnetting by Hand

Before touching any lab, do this on paper.

### Exercise 1: Subnet 192.168.10.0/24 into 4 Equal Subnets

**Step 1:** Calculate the new subnet mask.
- 4 subnets → borrow 2 bits ($2^2 = 4$)
- New mask: /24 + 2 = /26 → `255.255.255.192`
- Magic number: 256 - 192 = 64

**Step 2:** Fill in the table:

| Subnet | Network Address | First Usable | Last Usable | Broadcast | CIDR |
|--------|----------------|-------------|------------|-----------|------|
| LAN-A | 192.168.10.0 | 192.168.10.1 | 192.168.10.62 | 192.168.10.63 | /26 |
| LAN-B | 192.168.10.64 | 192.168.10.65 | 192.168.10.126 | 192.168.10.127 | /26 |
| LAN-C | 192.168.10.128 | 192.168.10.129 | 192.168.10.190 | 192.168.10.191 | /26 |
| LAN-D | 192.168.10.192 | 192.168.10.193 | 192.168.10.254 | 192.168.10.255 | /26 |

**Step 3:** Verify with an [online calculator](https://www.subnet-calculator.com/). Do they match?

---

## Part B: Containerlab Lab — Multi-Subnet Routing

### Topology

```
  LAN-A (.0/26)         LAN-B (.64/26)         LAN-C (.128/26)       LAN-D (.192/26)
  ┌──────┐              ┌──────┐               ┌──────┐              ┌──────┐
  │HostA │              │HostB │               │HostC │              │HostD │
  │.10   │              │.70   │               │.130  │              │.200  │
  └──┬───┘              └──┬───┘               └──┬───┘              └──┬───┘
     │                     │                      │                     │
  ┌──┴───┐   10.0.0.0/30  ┌──┴───┐  10.0.0.4/30  ┌──┴───┐  10.0.0.8/30 ┌──┴───┐
  │  R1  │────────────────│  R2  │───────────────│  R3  │──────────────│  R4  │
  │ .1   │  .1        .2  │.65   │ .5        .6  │.129  │ .9       .10 │.193  │
  └──────┘                └──────┘               └──────┘              └──────┘
```

### Exercise 2: Deploy the Topology

**Step 1:** Navigate to the lab directory
```bash
cd ~/Desktop/CCNA/week-02/lab/
```

**Step 2:** Deploy the topology
```bash
sudo containerlab deploy -t topology.yml
```

**Step 3:** Verify all containers are running
```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep week02
```

---

### Exercise 3: Verify IP Configuration

**Step 1:** Check IP addresses on each router
```bash
# Router 1
docker exec -it clab-week02-r1 vtysh -c "show interface brief"

# Router 2
docker exec -it clab-week02-r2 vtysh -c "show interface brief"

# Router 3
docker exec -it clab-week02-r3 vtysh -c "show interface brief"

# Router 4
docker exec -it clab-week02-r4 vtysh -c "show interface brief"
```

**Step 2:** Check IP addresses on hosts
```bash
docker exec clab-week02-hosta ip addr show eth1
docker exec clab-week02-hostb ip addr show eth1
docker exec clab-week02-hostc ip addr show eth1
docker exec clab-week02-hostd ip addr show eth1
```

**What to observe:**
- Each router has two interfaces: one facing its LAN, one (or two) facing other routers
- Each host has one interface with an IP in its subnet

---

### Exercise 4: Verify Routing Tables

**Step 1:** Check the routing table on R1
```bash
docker exec -it clab-week02-r1 vtysh -c "show ip route"
```

**Expected:** You should see:
- **C** (Connected) routes for directly connected subnets
- **S** (Static) routes for remote subnets

**Step 2:** Check all routers
```bash
for r in r1 r2 r3 r4; do
  echo "=== $r routing table ==="
  docker exec -it clab-week02-$r vtysh -c "show ip route"
  echo ""
done
```

---

### Exercise 5: Test Connectivity Across Subnets

**Step 1:** Ping between adjacent subnets
```bash
# Host A → Host B (through R1 and R2)
docker exec clab-week02-hosta ping -c 3 192.168.10.70
```

**Step 2:** Ping across multiple routers
```bash
# Host A → Host D (through R1, R2, R3, R4)
docker exec clab-week02-hosta ping -c 3 192.168.10.200
```

**Step 3:** Traceroute to see the path
```bash
docker exec clab-week02-hosta traceroute 192.168.10.200
```

**What to observe:**
- Each router hop decrements the TTL
- You can see the intermediate router IPs in the traceroute output

---

### Exercise 6: Observe Subnetting in Action

**Step 1:** Try pinging a host in a different subnet directly (from a host, not through the router):
```bash
# From Host A, ping Host B's IP — this will work because the router forwards it
docker exec clab-week02-hosta ping -c 2 192.168.10.70
```

**Step 2:** Now remove the default gateway from Host A and try again:
```bash
docker exec clab-week02-hosta ip route del default
docker exec clab-week02-hosta ping -c 2 192.168.10.70
```

**Expected:** "Network is unreachable" — without a gateway, the host can't reach other subnets.

**Step 3:** Restore the gateway:
```bash
docker exec clab-week02-hosta ip route add default via 192.168.10.1
```

---

### Exercise 7: Explore the Router Configuration

**Step 1:** View the full running config of R1
```bash
docker exec -it clab-week02-r1 vtysh -c "show running-config"
```

**Step 2:** Examine static routes — identify:
- Which destination networks are configured?
- What is the next-hop IP for each?
- Why does R1 need routes to all three remote subnets?

---

### Exercise 8: Clean Up

```bash
cd ~/Desktop/CCNA/week-02/lab/
sudo containerlab destroy -t topology.yml
```

---

## Part C: Cisco Packet Tracer Lab

### Exercise PT-1: Build a 4-LAN Router-on-a-Stick Topology

1. Place **1 Router** (2911), **4 Switches** (2960), **4 PCs** (one per switch)
2. Connect each switch to the router on separate interfaces:
   - Switch1 → Router Gig0/0
   - Switch2 → Router Gig0/1
   - Switch3 → Router Gig0/2 (use a module if needed)
   - Switch4 → depends on available interfaces
3. Assign IPs using the subnets from Exercise 1:
   - PC0: 192.168.10.10/26, Gateway: 192.168.10.1
   - PC1: 192.168.10.70/26, Gateway: 192.168.10.65
   - PC2: 192.168.10.130/26, Gateway: 192.168.10.129
   - PC3: 192.168.10.200/26, Gateway: 192.168.10.193

### Exercise PT-2: Configure the Router

```
enable
configure terminal

interface GigabitEthernet0/0
 ip address 192.168.10.1 255.255.255.192
 no shutdown

interface GigabitEthernet0/1
 ip address 192.168.10.65 255.255.255.192
 no shutdown

interface GigabitEthernet0/2
 ip address 192.168.10.129 255.255.255.192
 no shutdown
```

### Exercise PT-3: Verify

```
show ip interface brief
show ip route
```

Then ping from each PC to every other PC. All should succeed.

### Exercise PT-4: Test Subnet Boundaries

1. Change PC3's IP to `192.168.10.150/26` (which is in subnet C, not D)
2. Try pinging PC2 (192.168.10.130) from PC3 — **does it work?**
3. Try pinging the default gateway `192.168.10.193` from PC3 — **does it work?**
4. **Why?** (PC3 is now in subnet C but its gateway is in subnet D)

---

## Verification Checklist

- [ ] I can subnet a /24 into equal subnets by hand in under 2 minutes
- [ ] I understand how routers connect different subnets
- [ ] I can read a routing table and identify connected vs. static routes
- [ ] I can traceroute and identify each hop
- [ ] I understand why hosts need a default gateway for inter-subnet communication

---

**Next:** [Challenges →](challenges.md)
