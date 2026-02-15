# Week 3 — Exercises: IPv6 & Dual Stack

## Table of Contents
- [Lab Overview](#lab-overview)
- [Part A: Containerlab Lab — IPv6 Routing](#part-a-containerlab-lab--ipv6-routing)
  - [Exercise 1: Deploy the Topology](#exercise-1-deploy-the-topology)
  - [Exercise 2: Verify IPv6 Addresses](#exercise-2-verify-ipv6-addresses)
  - [Exercise 3: Test IPv6 Connectivity](#exercise-3-test-ipv6-connectivity)
  - [Exercise 4: Observe NDP](#exercise-4-observe-neighbor-discovery-protocol-ndp)
  - [Exercise 5: View IPv6 Routing Tables](#exercise-5-view-ipv6-routing-tables)
  - [Exercise 6: Dual-Stack Configuration](#exercise-6-dual-stack-configuration)
  - [Exercise 7: Clean Up](#exercise-7-clean-up)
- [Part B: Cisco Packet Tracer Lab](#part-b-cisco-packet-tracer-lab)
- [Verification Checklist](#verification-checklist)

---

## Lab Overview

In this lab, you will:
1. Configure IPv6 addresses on routers and hosts
2. Verify link-local and global unicast addresses
3. Configure static IPv6 routes
4. Observe NDP (Neighbor Discovery) in action
5. Build a dual-stack topology with both IPv4 and IPv6

---

## Part A: Containerlab Lab — IPv6 Routing

### Topology

```
   2001:db8:a::/64          2001:db8:ab::/64         2001:db8:b::/64
  ┌──────┐              ┌──────┐    ┌──────┐              ┌──────┐
  │HostA │              │  R1  │────│  R2  │              │HostB │
  │ ::10 │──────────────│ ::1  │    │ ::1  │──────────────│ ::10 │
  └──────┘              └──────┘    └──────┘              └──────┘
                        fe80::1      fe80::2
```

### Exercise 1: Deploy the Topology

```bash
cd ~/Desktop/CCNA/week-03/lab/
sudo containerlab deploy -t topology.yml
```

Verify:
```bash
docker ps --format "table {{.Names}}\t{{.Status}}" | grep week03
```

---

### Exercise 2: Verify IPv6 Addresses

**Step 1:** Check all addresses on R1
```bash
docker exec -it clab-week03-r1 ip -6 addr show
```

**What to observe:**
- Each interface has a **link-local** address (fe80::...) — auto-generated
- Interfaces also have the manually configured **GUA** (2001:db8:...)
- The loopback has `::1` (IPv6 loopback)

**Step 2:** Check R2
```bash
docker exec -it clab-week03-r2 ip -6 addr show
```

**Step 3:** Check hosts
```bash
docker exec clab-week03-hosta ip -6 addr show eth1
docker exec clab-week03-hostb ip -6 addr show eth1
```

---

### Exercise 3: Test IPv6 Connectivity

**Step 1:** Ping from Host A to R1 (same subnet)
```bash
docker exec clab-week03-hosta ping6 -c 3 2001:db8:a::1
```

**Step 2:** Ping from Host A to Host B (across routers)
```bash
docker exec clab-week03-hosta ping6 -c 3 2001:db8:b::10
```

**Step 3:** Ping using link-local (must specify the interface)
```bash
docker exec clab-week03-hosta ping6 -c 3 fe80::1%eth1
```

> **Note:** Link-local addresses require the `%interface` suffix because they're not unique across interfaces.

**Step 4:** Traceroute
```bash
docker exec clab-week03-hosta traceroute6 2001:db8:b::10
```

---

### Exercise 4: Observe Neighbor Discovery Protocol (NDP)

NDP is IPv6's replacement for ARP. Let's watch it in action.

**Step 1:** Clear the neighbor cache
```bash
docker exec clab-week03-hosta ip -6 neigh flush all
```

**Step 2:** Start a capture on Host A
```bash
docker exec clab-week03-hosta tcpdump -i eth1 -n -c 10 icmp6 &
```

**Step 3:** Ping R1 from Host A
```bash
docker exec clab-week03-hosta ping6 -c 1 2001:db8:a::1
```

**What to observe in tcpdump:**
```
ICMPv6, neighbor solicitation, who has 2001:db8:a::1
ICMPv6, neighbor advertisement, tgt is 2001:db8:a::1
ICMPv6, echo request
ICMPv6, echo reply
```

This is the IPv6 equivalent of ARP Request/Reply!

**Step 4:** View the neighbor table (equivalent of ARP table)
```bash
docker exec clab-week03-hosta ip -6 neigh show
```

---

### Exercise 5: View IPv6 Routing Tables

**Step 1:** Check R1's IPv6 routes
```bash
docker exec -it clab-week03-r1 ip -6 route show
```

**Step 2:** Check R2's IPv6 routes
```bash
docker exec -it clab-week03-r2 ip -6 route show
```

**What to observe:**
- Connected routes for directly attached subnets
- Static routes for remote subnets pointing to next-hop addresses

---

### Exercise 6: Dual-Stack Configuration

Now let's add IPv4 alongside IPv6 on the same interfaces.

**Step 1:** Add IPv4 addresses to all devices
```bash
# R1 — LAN interface
docker exec clab-week03-r1 ip addr add 192.168.1.1/24 dev eth1
# R1 — WAN interface
docker exec clab-week03-r1 ip addr add 10.0.0.1/30 dev eth2

# R2 — WAN interface
docker exec clab-week03-r2 ip addr add 10.0.0.2/30 dev eth1
# R2 — LAN interface
docker exec clab-week03-r2 ip addr add 192.168.2.1/24 dev eth2

# Host A
docker exec clab-week03-hosta ip addr add 192.168.1.10/24 dev eth1
docker exec clab-week03-hosta ip route add 192.168.2.0/24 via 192.168.1.1

# Host B
docker exec clab-week03-hostb ip addr add 192.168.2.10/24 dev eth1
docker exec clab-week03-hostb ip route add 192.168.1.0/24 via 192.168.2.1
```

**Step 2:** Add IPv4 static routes on routers
```bash
docker exec clab-week03-r1 ip route add 192.168.2.0/24 via 10.0.0.2
docker exec clab-week03-r2 ip route add 192.168.1.0/24 via 10.0.0.1
```

**Step 3:** Test both protocols
```bash
# IPv4 ping
docker exec clab-week03-hosta ping -c 2 192.168.2.10

# IPv6 ping
docker exec clab-week03-hosta ping6 -c 2 2001:db8:b::10
```

**Both should work!** This is dual-stack — the same interfaces carry both IPv4 and IPv6 traffic simultaneously.

**Step 4:** Verify dual-stack addresses
```bash
docker exec clab-week03-hosta ip addr show eth1
```
You should see both an `inet` (IPv4) and `inet6` (IPv6) address on the same interface.

---

### Exercise 7: Clean Up

```bash
cd ~/Desktop/CCNA/week-03/lab/
sudo containerlab destroy -t topology.yml
```

---

## Part B: Cisco Packet Tracer Lab

### Exercise PT-1: Configure IPv6 on Routers

1. Place **2 Routers** (2911) and **2 PCs**, connected: PC0 — R1 — R2 — PC1
2. On Router 1:
```
enable
configure terminal
ipv6 unicast-routing

interface GigabitEthernet0/0
 ipv6 address 2001:db8:a::1/64
 ipv6 address fe80::1 link-local
 no shutdown

interface Serial0/0/0
 ipv6 address 2001:db8:ab::1/64
 ipv6 address fe80::1 link-local
 no shutdown

ipv6 route 2001:db8:b::/64 2001:db8:ab::2
```

3. On Router 2:
```
enable
configure terminal
ipv6 unicast-routing

interface Serial0/0/0
 ipv6 address 2001:db8:ab::2/64
 ipv6 address fe80::2 link-local
 no shutdown

interface GigabitEthernet0/0
 ipv6 address 2001:db8:b::1/64
 ipv6 address fe80::2 link-local
 no shutdown

ipv6 route 2001:db8:a::/64 2001:db8:ab::1
```

### Exercise PT-2: Configure Hosts

1. PC0: IPv6 address `2001:db8:a::10/64`, Gateway: `fe80::1`
2. PC1: IPv6 address `2001:db8:b::10/64`, Gateway: `fe80::2`

### Exercise PT-3: Verify

```
show ipv6 interface brief
show ipv6 route
show ipv6 neighbors
```

Ping from PC0 to PC1 using IPv6. In Simulation Mode, observe the ICMPv6 packets.

### Exercise PT-4: Enable SLAAC

1. On R1, the `ipv6 address 2001:db8:a::1/64` command on the LAN interface already enables RA
2. On PC0, change IPv6 configuration to **Auto Config**
3. Wait for SLAAC — PC0 should auto-generate an address in the `2001:db8:a::/64` prefix
4. Verify with `ipconfig` on PC0

---

## Verification Checklist

- [ ] I can configure IPv6 GUA and link-local addresses
- [ ] I can verify IPv6 addresses with `show ipv6 interface brief`
- [ ] I can configure and verify static IPv6 routes
- [ ] I understand the difference between GUA and link-local addresses
- [ ] I can capture and identify NDP (Neighbor Solicitation/Advertisement)
- [ ] I can configure dual-stack (both IPv4 and IPv6 on the same interfaces)
- [ ] I understand SLAAC and how hosts auto-generate addresses

---

**Next:** [Challenges →](challenges.md)
