# Week 6 — Concepts: Static & Dynamic Routing (OSPF)

## Table of Contents
- [1. How Routers Make Forwarding Decisions](#1-how-routers-make-forwarding-decisions)
- [2. The Routing Table](#2-the-routing-table)
- [3. Administrative Distance](#3-administrative-distance)
- [4. Longest Prefix Match](#4-longest-prefix-match)
- [5. Static Routes](#5-static-routes)
- [6. Default Routes](#6-default-routes)
- [7. Floating Static Routes](#7-floating-static-routes)
- [8. Dynamic Routing Overview](#8-dynamic-routing-overview)
- [9. OSPF Fundamentals](#9-ospf-fundamentals)
- [10. OSPF Neighbor Relationships](#10-ospf-neighbor-relationships)
- [11. OSPF DR/BDR Election](#11-ospf-drbdr-election)
- [12. OSPF Cost and Path Selection](#12-ospf-cost-and-path-selection)
- [13. OSPF Configuration](#13-ospf-configuration)
- [14. OSPF Passive Interfaces](#14-ospf-passive-interfaces)
- [15. Default Route Redistribution into OSPF](#15-default-route-redistribution-into-ospf)
- [Quiz — 10 Questions](#quiz--10-questions)

---

## 1. How Routers Make Forwarding Decisions

When a router receives a packet, it:
1. Strips the Layer 2 frame header
2. Reads the **destination IP** in the Layer 3 header
3. Looks up the destination in the **routing table**
4. Forwards the packet out the matched exit interface (re-encapsulating with a new L2 header)
5. If no match is found and there's no default route → **drops the packet**

---

## 2. The Routing Table

The routing table contains entries from various sources:

| Code | Source | Example |
|------|--------|---------|
| `C` | Connected | Interfaces with IP assigned and `up/up` |
| `L` | Local | /32 host route for the router's own IPs |
| `S` | Static | Manually configured by admin |
| `O` | OSPF | Learned via OSPF |
| `D` | EIGRP | Learned via EIGRP |
| `R` | RIP | Learned via RIP |
| `S*` | Static default | Default route (0.0.0.0/0) |

**Viewing the table:**
```
show ip route
show ip route ospf          ← only OSPF routes
show ip route static        ← only static routes
show ip route connected     ← only connected routes
```

---

## 3. Administrative Distance

When multiple routing sources provide a route to the same destination, the router uses **Administrative Distance (AD)** to choose the most trusted source.

| Route Source | Default AD |
|-------------|-----------|
| Connected | 0 |
| Static | 1 |
| eBGP | 20 |
| EIGRP | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |
| External EIGRP | 170 |
| iBGP | 200 |

> **Lower AD = more trusted.** Connected (0) always wins. Static (1) beats all dynamic protocols.

---

## 4. Longest Prefix Match

When multiple routes match a destination IP, the router picks the **most specific** (longest prefix):

```
Route A: 10.0.0.0/8          ← matches 10.anything
Route B: 10.1.0.0/16         ← matches 10.1.anything
Route C: 10.1.1.0/24         ← matches 10.1.1.anything
```

Packet to **10.1.1.50** → All three match, but the router uses **Route C** (/24) because it's the longest (most specific) prefix match.

> AD is used to choose between routes to the **same prefix**. Longest prefix match is used to choose between routes to **different prefixes** that overlap.

---

## 5. Static Routes

Manually configured paths. They don't adapt to network changes.

**Next-hop syntax:**
```
ip route 192.168.20.0 255.255.255.0 10.0.0.2
```
→ "To reach 192.168.20.0/24, send packets to 10.0.0.2"

**Exit-interface syntax:**
```
ip route 192.168.20.0 255.255.255.0 GigabitEthernet0/1
```
→ "To reach 192.168.20.0/24, send packets out Gig0/1"

**Fully specified:**
```
ip route 192.168.20.0 255.255.255.0 GigabitEthernet0/1 10.0.0.2
```

**FRR equivalent (Containerlab):**
```
ip route 192.168.20.0/24 10.0.0.2
```

---

## 6. Default Routes

A route of last resort — matches any destination not in the table:

```
ip route 0.0.0.0 0.0.0.0 203.0.113.1
```
→ "If nothing else matches, send to 203.0.113.1" (typically the ISP gateway)

Shows as `S* 0.0.0.0/0` in the routing table.

---

## 7. Floating Static Routes

A backup static route with a **higher AD** than the primary route. It only enters the routing table if the primary fails.

```
! Primary via OSPF (AD 110, learned automatically)
! Backup static (AD 200 — higher than OSPF's 110)
ip route 192.168.20.0 255.255.255.0 10.0.99.2 200
```

If OSPF withdraws the route, the static route (AD 200) activates as backup.

---

## 8. Dynamic Routing Overview

| Category | Protocol | Algorithm | Metric |
|----------|----------|-----------|--------|
| Distance-Vector | RIP | Bellman-Ford | Hop count |
| Distance-Vector | EIGRP | DUAL | Bandwidth + Delay (composite) |
| Link-State | OSPF | Dijkstra (SPF) | Cost (based on bandwidth) |
| Link-State | IS-IS | Dijkstra | Variable metric |
| Path-Vector | BGP | Best Path | AS-Path, attributes |

**Key differences:**
- **Distance-Vector:** Each router shares its routing table with neighbors. Slower convergence.
- **Link-State:** Each router builds a complete topology map of the network. Faster convergence, more CPU/memory.

> CCNA focuses primarily on **OSPF single-area**.

---

## 9. OSPF Fundamentals

**Open Shortest Path First (OSPF)**
- Link-state IGP (Interior Gateway Protocol)
- Uses **Dijkstra's SPF algorithm** to compute the shortest path tree
- Multicast addresses: **224.0.0.5** (all OSPF routers), **224.0.0.6** (DR/BDR)
- Protocol number: **89** (not TCP or UDP)
- Supports VLSM and CIDR
- Classless — carries subnet mask information

**OSPF process:**
1. **Discover neighbors** via Hello packets (multicast 224.0.0.5)
2. **Exchange LSAs** (Link State Advertisements) — each router describes its links
3. Build the **LSDB** (Link State Database) — identical on all routers in an area
4. Run **SPF algorithm** to compute the shortest path tree
5. Install the best routes in the **routing table**

---

## 10. OSPF Neighbor Relationships

**Hello packets** establish and maintain neighbor relationships. Sent every **10 seconds** on broadcast networks (30 seconds on NBMA).

**Requirements for OSPF neighbors to form:**
1. Same **area ID**
2. Same **subnet** and **mask**
3. Same **Hello/Dead timers** (default: 10/40 sec)
4. Same **authentication** (if configured)
5. Same **stub area flag** (if applicable)
6. Unique **Router IDs**

**Neighbor states (simplified):**
```
Down → Init → 2-Way → ExStart → Exchange → Loading → Full
```

| State | Description |
|-------|-------------|
| Down | No Hellos received |
| Init | Hello received, but not bidirectional |
| 2-Way | Bidirectional communication confirmed (DR/BDR elected here) |
| ExStart | Master/Slave negotiation for DBD exchange |
| Exchange | Database Description packets exchanged |
| Loading | LSAs requested and received |
| **Full** | Databases synchronized — normal operational state |

---

## 11. OSPF DR/BDR Election

On **broadcast/multi-access** segments (Ethernet), OSPF elects:
- **DR (Designated Router):** Central point for LSA exchange — reduces flooding
- **BDR (Backup DR):** Takes over if DR fails
- **DROther:** All other routers on the segment

**Election criteria (highest wins):**
1. Highest **OSPF priority** (0-255, default 1; priority 0 = cannot be DR/BDR)
2. Highest **Router ID** (tiebreaker)

**Router ID selection order:**
1. Manually configured (`router-id` command)
2. Highest loopback address
3. Highest active physical interface IP

> **DR/BDR election is NOT preemptive.** If a router with a higher priority joins later, the current DR stays until it fails.

---

## 12. OSPF Cost and Path Selection

**OSPF cost** = Reference Bandwidth / Interface Bandwidth

Default reference bandwidth: **100 Mbps** (10^8)

| Interface | Bandwidth | Cost |
|-----------|-----------|------|
| FastEthernet (100 Mbps) | 100,000,000 | 1 |
| GigabitEthernet (1 Gbps) | 1,000,000,000 | 1 (!) |
| 10 GigE (10 Gbps) | 10,000,000,000 | 1 (!) |
| Serial (1.544 Mbps) | 1,544,000 | 64 |

> **Problem:** With the default, FastEthernet and GigabitEthernet have the **same cost** (1). Fix this by adjusting the reference bandwidth:

```
router ospf 1
 auto-cost reference-bandwidth 10000    ← 10 Gbps reference
```

Now: GigE = cost 10, FastEthernet = cost 100, 10GigE = cost 1

**Total path cost** = sum of all interface costs from source to destination.

**Manually set cost on an interface:**
```
interface GigabitEthernet0/0
 ip ospf cost 50
```

---

## 13. OSPF Configuration

**Cisco IOS:**
```
router ospf 1                               ← process ID (local, doesn't need to match)
 router-id 1.1.1.1                          ← manually set router ID
 network 192.168.1.0 0.0.0.255 area 0       ← advertise 192.168.1.0/24 into area 0
 network 10.0.0.0 0.0.0.3 area 0            ← advertise 10.0.0.0/30 WAN link
```

**Alternative (interface-level):**
```
interface GigabitEthernet0/0
 ip ospf 1 area 0                           ← assign this interface directly to OSPF
```

**FRR (Containerlab) equivalent:**
```
router ospf
 ospf router-id 1.1.1.1
 network 192.168.1.0/24 area 0
 network 10.0.0.0/30 area 0
```

---

## 14. OSPF Passive Interfaces

Passive interfaces **do not send OSPF Hello packets** but the network is still advertised.

**Why?**
- LAN-facing interfaces don't need to form OSPF neighbors with PCs
- Reduces unnecessary OSPF traffic
- Security: prevents rogue OSPF neighbors

```
router ospf 1
 passive-interface GigabitEthernet0/0         ← specific interface
! or
 passive-interface default                     ← all interfaces passive
 no passive-interface Serial0/0                ← then un-passive WAN links
```

---

## 15. Default Route Redistribution into OSPF

If one router has the default route (to the ISP), you can distribute it to all OSPF neighbors:

```
! On the edge router:
ip route 0.0.0.0 0.0.0.0 203.0.113.1         ← static default to ISP
router ospf 1
 default-information originate                 ← tells OSPF to advertise the default
```

Other routers will see: `O*E2 0.0.0.0/0` in their routing table.

---

## Quiz — 10 Questions

**1.** What is the default administrative distance of OSPF?

<details><summary>Answer</summary>110</details>

**2.** A router has these routing table entries:
- 10.0.0.0/8 via 192.168.1.1
- 10.1.0.0/16 via 192.168.1.2
- 10.1.1.0/24 via 192.168.1.3

Where does a packet destined for 10.1.1.50 go?

<details><summary>Answer</summary>To 192.168.1.3 — longest prefix match (/24 is the most specific)</details>

**3.** What two multicast addresses does OSPF use?

<details><summary>Answer</summary>224.0.0.5 (AllSPFRouters) and 224.0.0.6 (DR/BDR)</details>

**4.** What is a floating static route?

<details><summary>Answer</summary>A static route with a manually increased AD (higher than the primary route's AD), acting as a backup that only enters the routing table when the primary route is unavailable</details>

**5.** What is the OSPF cost of a FastEthernet link with the default reference bandwidth?

<details><summary>Answer</summary>1 (100 Mbps reference / 100 Mbps interface = 1)</details>

**6.** Why should you change the OSPF reference bandwidth?

<details><summary>Answer</summary>Because the default (100 Mbps) makes FastEthernet, GigabitEthernet, and 10GigE all cost 1, so OSPF can't differentiate between them. Increasing to 10000 (10 Gbps) gives each a unique cost.</details>

**7.** What happens if two OSPF neighbors have different Hello timers?

<details><summary>Answer</summary>They will NOT form a neighbor relationship — Hello/Dead timer mismatch prevents adjacency</details>

**8.** Is the DR/BDR election preemptive?

<details><summary>Answer</summary>No. Once elected, the DR remains even if a higher-priority router joins later. The new router only becomes DR if the current DR fails.</details>

**9.** What does `passive-interface default` do in OSPF?

<details><summary>Answer</summary>Makes ALL interfaces passive (no Hellos sent), so no OSPF neighbors form on any interface. You then selectively enable OSPF on WAN-facing interfaces with `no passive-interface`.</details>

**10.** What command redistributes a default route into OSPF?

<details><summary>Answer</summary>`default-information originate` under the OSPF process. Other routers see it as O*E2.</details>

---

## Sources & Further Reading

- [RFC 2328 — OSPFv2](https://datatracker.ietf.org/doc/html/rfc2328) — OSPF Version 2 specification
- [Cisco — OSPF Design Guide](https://www.cisco.com/c/en/us/support/docs/ip/open-shortest-path-first-ospf/7039-1.html) — Cisco's OSPF design best practices
- [Cisco — IP Routing: Static Routes](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_pi/configuration/xe-16/iri-xe-16-book/iri-static-route.html) — Static route configuration
- [Cisco — OSPF Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16/iro-xe-16-book.html) — IOS OSPF config reference
- [Practical Networking — OSPF](https://www.practicalnetworking.net/stand-alone/ospf-terminology/) — OSPF concepts and terminology
- [Jeremy's IT Lab — OSPF (YouTube)](https://www.youtube.com/watch?v=mxjclSMoJMo&list=PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ) — Video walkthrough
- [FRRouting Documentation](https://docs.frrouting.org/en/latest/ospfd.html) — FRR OSPF reference (used in labs)

---

**Next → [Week 6 Exercises](exercises.md)**
