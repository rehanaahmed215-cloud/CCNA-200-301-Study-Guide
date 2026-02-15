# Week 3 — Challenges: IPv6 & Dual Stack

## Table of Contents
- [Challenge 1: IPv6 Address Conversion Drill](#challenge-1-ipv6-address-conversion-drill)
- [Challenge 2: Build a Dual-Stack Topology](#challenge-2-build-a-dual-stack-topology)
- [Challenge 3: SLAAC vs. DHCPv6 Research](#challenge-3-slaac-vs-dhcpv6-research)
- [Challenge 4: EUI-64 Calculation Drill](#challenge-4-eui-64-calculation-drill)
- [Challenge 5: IPv6 Troubleshooting Scenario](#challenge-5-ipv6-troubleshooting-scenario)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: IPv6 Address Conversion Drill

**Part A — Shorten these addresses:**

| # | Full Address | Your Answer |
|---|-------------|-------------|
| 1 | `2001:0db8:0000:0000:0000:0000:0000:0001` | |
| 2 | `fe80:0000:0000:0000:0000:0000:0000:0001` | |
| 3 | `2001:0db8:abcd:0000:0000:0000:0000:0000` | |
| 4 | `ff02:0000:0000:0000:0000:0000:0000:0001` | |
| 5 | `2001:0db8:0000:0001:0000:0000:0000:0001` | |

**Part B — Expand these addresses to full form:**

| # | Shortened | Your Answer |
|---|-----------|-------------|
| 6 | `2001:db8::1` | |
| 7 | `fe80::1` | |
| 8 | `::1` | |
| 9 | `2001:db8:cafe::dead:beef` | |
| 10 | `::` | |

<details>
<summary><strong>Check your answers</strong></summary>

**Part A:**
1. `2001:db8::1`
2. `fe80::1`
3. `2001:db8:abcd::`
4. `ff02::1`
5. `2001:db8:0:1::1`

**Part B:**
6. `2001:0db8:0000:0000:0000:0000:0000:0001`
7. `fe80:0000:0000:0000:0000:0000:0000:0001`
8. `0000:0000:0000:0000:0000:0000:0000:0001`
9. `2001:0db8:cafe:0000:0000:0000:dead:beef`
10. `0000:0000:0000:0000:0000:0000:0000:0000`

</details>

---

## Challenge 2: Build a Dual-Stack Topology

**Task:** Build a 3-router, 3-LAN topology where every device has both IPv4 AND IPv6 addresses. Ensure full reachability over both protocols.

**Requirements:**
- 3 routers in a triangle (R1↔R2, R2↔R3, R1↔R3)
- 3 LANs, one per router, each with at least 1 host
- IPv4 scheme: use 192.168.x.0/24 for LANs, 10.0.0.x/30 for WAN links
- IPv6 scheme: use 2001:db8:x::/64 for LANs, 2001:db8:ff:x::/64 for WAN links
- Static routes for both IPv4 and IPv6

**Deliverables:**
1. Complete IP addressing table (both protocols)
2. Working topology in Containerlab or Packet Tracer
3. Proof: ping from Host1 to Host3 over both IPv4 and IPv6

<details>
<summary><strong>Sample addressing table</strong></summary>

**IPv4:**
| Device | Interface | IPv4 Address | Subnet |
|--------|-----------|-------------|--------|
| R1 | eth1 (LAN) | 192.168.1.1 | /24 |
| R1 | eth2 (→R2) | 10.0.0.1 | /30 |
| R1 | eth3 (→R3) | 10.0.0.5 | /30 |
| R2 | eth1 (LAN) | 192.168.2.1 | /24 |
| R2 | eth2 (→R1) | 10.0.0.2 | /30 |
| R2 | eth3 (→R3) | 10.0.0.9 | /30 |
| R3 | eth1 (LAN) | 192.168.3.1 | /24 |
| R3 | eth2 (→R1) | 10.0.0.6 | /30 |
| R3 | eth3 (→R2) | 10.0.0.10 | /30 |

**IPv6:**
| Device | Interface | IPv6 Address |
|--------|-----------|-------------|
| R1 | eth1 (LAN) | 2001:db8:1::1/64 |
| R1 | eth2 (→R2) | 2001:db8:ff:1::1/64 |
| R1 | eth3 (→R3) | 2001:db8:ff:2::1/64 |
| R2 | eth1 (LAN) | 2001:db8:2::1/64 |
| R2 | eth2 (→R1) | 2001:db8:ff:1::2/64 |
| R2 | eth3 (→R3) | 2001:db8:ff:3::1/64 |
| R3 | eth1 (LAN) | 2001:db8:3::1/64 |
| R3 | eth2 (→R1) | 2001:db8:ff:2::2/64 |
| R3 | eth3 (→R2) | 2001:db8:ff:3::2/64 |

</details>

---

## Challenge 3: SLAAC vs. DHCPv6 Research

**Task:** Write a one-page summary (300-500 words) answering:

1. How does SLAAC work step by step? (RS → RA → address generation)
2. When would you choose SLAAC over DHCPv6?
3. When would you choose Stateful DHCPv6 over SLAAC?
4. What about Stateless DHCPv6 — when is it the best choice?
5. What are the RA flags (M, O, A) and what does each control?

<details>
<summary><strong>Key points to cover</strong></summary>

**SLAAC process:**
1. Host sends Router Solicitation (RS) to ff02::2 (all routers)
2. Router replies with Router Advertisement (RA) containing: prefix, prefix length, default gateway (router's link-local)
3. Host generates Interface ID using EUI-64 or random (privacy extensions)
4. Host combines prefix + interface ID = full IPv6 address
5. Host performs Duplicate Address Detection (DAD) before using the address

**When to use SLAAC:**
- Simple networks, no need for address tracking
- IoT devices, small offices
- When you don't want to manage a DHCP server

**When to use Stateful DHCPv6:**
- Enterprise environments requiring address logging/tracking
- Compliance requirements (know which device has which address)
- When you need to assign specific addresses to specific hosts

**When to use Stateless DHCPv6:**
- You want SLAAC for addresses BUT need to push DNS server info
- Common compromise in many networks

**RA Flags:**
- **M (Managed):** M=1 tells hosts to use DHCPv6 for address
- **O (Other):** O=1 tells hosts to use DHCPv6 for other info (DNS)
- **A (Autonomous):** A=1 on the prefix option means hosts can use this prefix for SLAAC

</details>

---

## Challenge 4: EUI-64 Calculation Drill

**Task:** Calculate the EUI-64 Interface ID for each MAC address, then combine with the given prefix.

| # | MAC Address | Prefix | Full IPv6 Address |
|---|------------|--------|-------------------|
| 1 | `00:1A:2B:3C:4D:5E` | `2001:db8:1::/64` | ? |
| 2 | `AA:BB:CC:DD:EE:FF` | `2001:db8:2::/64` | ? |
| 3 | `00:50:56:12:34:56` | `2001:db8:cafe::/64` | ? |
| 4 | `F0:DE:F1:AB:CD:EF` | `fe80::/64` | ? |

<details>
<summary><strong>Check your answers</strong></summary>

**Process for each:** Split MAC → insert FFFE → flip 7th bit → format as IPv6

**1.** `00:1A:2B:3C:4D:5E`
- Split: `00:1A:2B` | `3C:4D:5E`
- Insert: `00:1A:2B:FF:FE:3C:4D:5E`
- Flip 7th bit: `00` → `02`
- Result: `021a:2bff:fe3c:4d5e`
- **Full: `2001:db8:1::21a:2bff:fe3c:4d5e`**

**2.** `AA:BB:CC:DD:EE:FF`
- Split: `AA:BB:CC` | `DD:EE:FF`
- Insert: `AA:BB:CC:FF:FE:DD:EE:FF`
- Flip 7th bit: `AA` (10101010) → `A8` (10101000)
- Result: `a8bb:ccff:fedd:eeff`
- **Full: `2001:db8:2::a8bb:ccff:fedd:eeff`**

**3.** `00:50:56:12:34:56`
- Split: `00:50:56` | `12:34:56`
- Insert: `00:50:56:FF:FE:12:34:56`
- Flip 7th bit: `00` → `02`
- Result: `0250:56ff:fe12:3456`
- **Full: `2001:db8:cafe::250:56ff:fe12:3456`**

**4.** `F0:DE:F1:AB:CD:EF`
- Split: `F0:DE:F1` | `AB:CD:EF`
- Insert: `F0:DE:F1:FF:FE:AB:CD:EF`
- Flip 7th bit: `F0` (11110000) → `F2` (11110010)
- Result: `f2de:f1ff:feab:cdef`
- **Full: `fe80::f2de:f1ff:feab:cdef`**

</details>

---

## Challenge 5: IPv6 Troubleshooting Scenario

**Scenario:** A network admin configured IPv6 on two routers but hosts can't communicate across subnets. Here's the config:

**Router 1:**
```
interface GigabitEthernet0/0
 ipv6 address 2001:db8:a::1/64
 no shutdown
interface Serial0/0/0
 ipv6 address 2001:db8:link::1/64
 no shutdown
ipv6 route 2001:db8:b::/64 2001:db8:link::2
```

**Router 2:**
```
interface Serial0/0/0
 ipv6 address 2001:db8:link::2/64
 no shutdown
interface GigabitEthernet0/0
 ipv6 address 2001:db8:b::1/64
 no shutdown
ipv6 route 2001:db8:a::/64 2001:db8:link::1
```

**Host A:** `2001:db8:a::10/64`, gateway: `2001:db8:a::1`
**Host B:** `2001:db8:b::10/64`, gateway: `2001:db8:b::1`

**Task:**
1. Read the config carefully. Can you spot the issue?
2. What command would you run first to diagnose?
3. What's the fix?

<details>
<summary><strong>Check your answer</strong></summary>

**The issue:** The command `ipv6 unicast-routing` is **missing** on both routers!

Without `ipv6 unicast-routing`, Cisco routers will NOT forward IPv6 packets between interfaces, even with routes configured. This is the #1 most common IPv6 configuration mistake.

**Diagnostic commands:**
```
show ipv6 route     ← Routes may appear but forwarding won't work
show ipv6 interface brief  ← Interfaces look fine
ping from router to remote host ← May work (router itself can route)
```

The key giveaway is that the router can ping both hosts, but the hosts can't ping each other.

**Fix:**
```
Router1(config)# ipv6 unicast-routing
Router2(config)# ipv6 unicast-routing
```

**Remember:** IPv4 routing is on by default on Cisco routers. IPv6 routing must be explicitly enabled with `ipv6 unicast-routing`.

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Address conversion | ⭐ Easy | 10 minutes |
| 2. Dual-stack topology | ⭐⭐⭐ Hard | 45 minutes |
| 3. SLAAC vs DHCPv6 | ⭐⭐ Medium | 20 minutes |
| 4. EUI-64 drill | ⭐⭐ Medium | 15 minutes |
| 5. Troubleshooting | ⭐⭐ Medium | 10 minutes |

---

**Week 3 complete! → [Start Week 4](../week-04/concepts.md)**
