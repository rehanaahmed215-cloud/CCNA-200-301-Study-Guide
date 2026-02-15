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
containerlab deploy -t topology.yml
```

Verify:
```bash
lab ls
```

> **Tip — Connecting to nodes:**
> Use `lab <node>` to open a shell inside a container. Open each node in its own Terminal tab, or run `lab --all` to open every node at once.
>
> All commands below assume you are **inside** the container's shell unless marked as **Host (Mac terminal)**.

---

### Exercise 2: Verify IPv6 Addresses

**On R1** (`lab r1`):
```bash
ip -6 addr show
```

**What to observe:**
- Each interface has a **link-local** address (fe80::...) — auto-generated
- Interfaces also have the manually configured **GUA** (2001:db8:...)
- The loopback has `::1` (IPv6 loopback)

**On R2** (`lab r2`):
```bash
ip -6 addr show
```

**On Host A** (`lab hosta`):
```bash
ip -6 addr show eth1
```

**On Host B** (`lab hostb`):
```bash
ip -6 addr show eth1
```

---

### Exercise 3: Test IPv6 Connectivity

**On Host A** (`lab hosta`):

**Step 1:** Ping R1 (same subnet)
```bash
ping6 -c 3 2001:db8:a::1
```

**Step 2:** Ping Host B (across routers)
```bash
ping6 -c 3 2001:db8:b::10
```

**Step 3:** Ping using link-local (must specify the interface)
```bash
ping6 -c 3 fe80::1%eth1
```

> **Note:** Link-local addresses require the `%interface` suffix because they're not unique across interfaces.

**Step 4:** Traceroute
```bash
traceroute6 2001:db8:b::10
```

---

### Exercise 4: Observe Neighbor Discovery Protocol (NDP)

NDP is IPv6's replacement for ARP. Let's watch it in action.

**On Host A:**

**Step 1:** Clear the neighbor cache
```bash
ip -6 neigh flush all
```

**Step 2:** Start a capture (this will wait for packets):
```bash
tcpdump -i eth1 -n -c 10 icmp6 &
```

**Step 3:** Ping R1
```bash
ping6 -c 1 2001:db8:a::1
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
ip -6 neigh show
```

---

### Exercise 5: View IPv6 Routing Tables

**On R1** (`lab r1`):
```bash
ip -6 route show
```

**On R2** (`lab r2`):
```bash
ip -6 route show
```

**What to observe:**
- Connected routes for directly attached subnets
- Static routes for remote subnets pointing to next-hop addresses

---

### Exercise 6: Dual-Stack Configuration

Now let's add IPv4 alongside IPv6 on the same interfaces.

**On R1** (`lab r1`):
```bash
ip addr add 192.168.1.1/24 dev eth1
ip addr add 10.0.0.1/30 dev eth2
```

**On R2** (`lab r2`):
```bash
ip addr add 10.0.0.2/30 dev eth1
ip addr add 192.168.2.1/24 dev eth2
```

**On Host A** (`lab hosta`):
```bash
ip addr add 192.168.1.10/24 dev eth1
ip route add 192.168.2.0/24 via 192.168.1.1
```

**On Host B** (`lab hostb`):
```bash
ip addr add 192.168.2.10/24 dev eth1
ip route add 192.168.1.0/24 via 192.168.2.1
```

**On R1** — add IPv4 static route:
```bash
ip route add 192.168.2.0/24 via 10.0.0.2
```

**On R2** — add IPv4 static route:
```bash
ip route add 192.168.1.0/24 via 10.0.0.1
```

**On Host A** — test both protocols:
```bash
# IPv4 ping
ping -c 2 192.168.2.10

# IPv6 ping
ping6 -c 2 2001:db8:b::10
```

**Both should work!** This is dual-stack — the same interfaces carry both IPv4 and IPv6 traffic simultaneously.

**On Host A** — verify dual-stack addresses:
```bash
ip addr show eth1
```
You should see both an `inet` (IPv4) and `inet6` (IPv6) address on the same interface.

---

### Exercise 7: Clean Up

Exit all container shells (type `exit`), then from your Mac terminal:
```bash
cd ~/Desktop/CCNA/week-03/lab/
lab destroy
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
