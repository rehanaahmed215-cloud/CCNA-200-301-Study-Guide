# Week 12 — Challenges: Final Review & Exam Readiness

## Table of Contents
- [Challenge 1: Teach a Concept (The Feynman Technique)](#challenge-1-teach-a-concept-the-feynman-technique)
- [Challenge 2: Whiteboard VLSM Design](#challenge-2-whiteboard-vlsm-design)
- [Challenge 3: Ultimate Comprehensive Lab](#challenge-3-ultimate-comprehensive-lab)
- [Challenge 4: Rapid Troubleshooting — 15 Scenarios](#challenge-4-rapid-troubleshooting--15-scenarios)
- [Challenge 5: The Final Night Review](#challenge-5-the-final-night-review)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Teach a Concept (The Feynman Technique)

**Task:** Explain **three** of the following topics to a non-technical person (or write your explanation as if teaching a 12-year-old). If you can explain it simply, you truly understand it.

**Pick three:**
1. How does OSPF find the best path to a destination?
2. What is NAT and why does every home network use it?
3. How does a VLAN work and why would a company use them?
4. What is the difference between TCP and UDP?
5. How does STP prevent network loops?
6. What is SDN and why are networks moving toward it?

### Rules
- No jargon (or define every term you use)
- Use analogies (mail system, highways, apartment buildings, etc.)
- Keep each explanation under 200 words
- Write it down — don't just think it

<details>
<summary><strong>Example Explanations</strong></summary>

**OSPF (The Neighborhood Mail System):**
Imagine a neighborhood where every house (router) needs to know how to send letters to every other house. OSPF is like a system where every house says "hello" to its neighbors, shares its address list, and then everyone builds a complete map of the neighborhood. When a letter needs to go somewhere, each house picks the shortest route on the map. If a road closes (link goes down), the houses quickly share updates and find a new path. OSPF doesn't just count steps — it measures how "fast" each road is (bandwidth = cost), so it prefers highways over dirt roads.

**NAT (The Apartment Front Desk):**
Your home network is like an apartment building. Everyone inside has a room number (private IP), but the building has only one street address (public IP). When you send a letter (packet) to the outside world, the front desk (router doing NAT) replaces your room number with the street address and remembers who sent what. When a reply comes back addressed to the building, the front desk checks its notes and delivers it to the right room. PAT is like adding your room number to the apartment address so multiple people can send mail at the same time.

**VLANs (Virtual Walls in an Office):**
Imagine a big open office with 100 people. Without walls, everyone's conversations mix together. VLANs are like magical invisible walls — you can group the Engineering team, Sales team, and HR team into separate "rooms" even though they're all plugged into the same physical switch. People in the same VLAN can talk freely, but to talk to another VLAN, their messages must go through a door (router/gateway). This improves security (HR data stays in HR) and reduces noise (broadcast traffic stays within the VLAN).

</details>

---

## Challenge 2: Whiteboard VLSM Design

**Task:** Design a complete VLSM addressing scheme for a medium business on a whiteboard (or paper). No calculator allowed — do all math by hand.

### Company: MedTech Solutions

**Starting network:** 10.50.0.0/16

| Site | Department | Hosts Needed |
|------|-----------|-------------|
| HQ | Engineering | 500 |
| HQ | Medical Staff | 200 |
| HQ | Administration | 100 |
| HQ | IT Management | 12 |
| HQ | Server Farm | 30 |
| Branch 1 | All Staff | 60 |
| Branch 2 | All Staff | 25 |
| WAN Link 1 | HQ ↔ Branch 1 | 2 |
| WAN Link 2 | HQ ↔ Branch 2 | 2 |
| WAN Link 3 | Branch 1 ↔ Branch 2 | 2 |
| Management VLAN | Network devices | 10 |

### Deliverables
1. Complete subnet allocation table
2. No wasted space between allocations
3. Show your work for each calculation
4. Calculate total waste percentage

<details>
<summary><strong>Solution</strong></summary>

**Step 1: Sort by size (largest first)**

| Dept | Hosts | Next 2^n | Prefix | Block Size |
|------|-------|----------|--------|-----------|
| Engineering | 500 | 512 (2^9) | /22 = 1024 | 1024 |
| Medical Staff | 200 | 256 (2^8) | /24 = 256 | 256 |
| Administration | 100 | 128 (2^7) | /25 = 128 | 128 |
| Branch 1 | 60 | 64 (2^6) | /26 = 64 | 64 |
| Server Farm | 30 | 32 (2^5) | /27 = 32 | 32 |
| Branch 2 | 25 | 32 (2^5) | /27 = 32 | 32 |
| IT Management | 12 | 16 (2^4) | /28 = 16 | 16 |
| Mgmt VLAN | 10 | 16 (2^4) | /28 = 16 | 16 |
| WAN 1 | 2 | 4 (2^2) | /30 = 4 | 4 |
| WAN 2 | 2 | 4 (2^2) | /30 = 4 | 4 |
| WAN 3 | 2 | 4 (2^2) | /30 = 4 | 4 |

**Step 2: Allocate sequentially**

Note: Engineering needs /22 (1024 addresses), so it must start on a /22 boundary.

| Dept | Network | Mask | First Usable | Last Usable | Broadcast |
|------|---------|------|-------------|-------------|-----------|
| Engineering | 10.50.0.0 | /22 | 10.50.0.1 | 10.50.3.254 | 10.50.3.255 |
| Medical Staff | 10.50.4.0 | /24 | 10.50.4.1 | 10.50.4.254 | 10.50.4.255 |
| Administration | 10.50.5.0 | /25 | 10.50.5.1 | 10.50.5.126 | 10.50.5.127 |
| Branch 1 | 10.50.5.128 | /26 | 10.50.5.129 | 10.50.5.190 | 10.50.5.191 |
| Server Farm | 10.50.5.192 | /27 | 10.50.5.193 | 10.50.5.222 | 10.50.5.223 |
| Branch 2 | 10.50.5.224 | /27 | 10.50.5.225 | 10.50.5.254 | 10.50.5.255 |
| IT Management | 10.50.6.0 | /28 | 10.50.6.1 | 10.50.6.14 | 10.50.6.15 |
| Mgmt VLAN | 10.50.6.16 | /28 | 10.50.6.17 | 10.50.6.30 | 10.50.6.31 |
| WAN 1 | 10.50.6.32 | /30 | 10.50.6.33 | 10.50.6.34 | 10.50.6.35 |
| WAN 2 | 10.50.6.36 | /30 | 10.50.6.37 | 10.50.6.38 | 10.50.6.39 |
| WAN 3 | 10.50.6.40 | /30 | 10.50.6.41 | 10.50.6.42 | 10.50.6.43 |

**Step 3: Calculate waste**

| Item | Usable Allocated | Hosts Needed | Wasted |
|------|-----------------|-------------|--------|
| Engineering | 1022 | 500 | 522 |
| Medical Staff | 254 | 200 | 54 |
| Administration | 126 | 100 | 26 |
| Branch 1 | 62 | 60 | 2 |
| Server Farm | 30 | 30 | 0 |
| Branch 2 | 30 | 25 | 5 |
| IT Mgmt | 14 | 12 | 2 |
| Mgmt VLAN | 14 | 10 | 4 |
| WANs (×3) | 6 | 6 | 0 |
| **Total** | **1558** | **943** | **615** |

Waste: 615/1558 = **39.5%** — good for VLSM (without VLSM, a flat /16 would waste 64,593 addresses!)

</details>

---

## Challenge 3: Ultimate Comprehensive Lab

**Task:** This is the capstone lab. Build the most complex network you've created, incorporating **every major topic** from Weeks 1-10.

### Topology

```
                        ┌─────────┐
                        │  ISP    │
                        │203.0.113│
                        └────┬────┘
                             │ .1/.2
                        ┌────┴────┐
                        │ R1-EDGE │
                        │ OSPF +  │
                        │ NAT/PAT │
                        └──┬───┬──┘
                  .1/.2 /     \ .5/.6
              ┌────────┘       └────────┐
         ┌────┴────┐              ┌─────┴────┐
         │ R2-HQ   │              │ R3-BRANCH│
         │ OSPF +  │              │ OSPF     │
         │ DHCP    │              │          │
         └──┬───┬──┘              └────┬─────┘
            │   │                      │
      ┌─────┘   └─────┐          ┌────┘
 ┌────┴──┐      ┌─────┴─┐   ┌───┴───┐
 │  SW1  │      │  SW2   │   │  SW3  │
 │VL10+20│      │VL20+30 │   │ VL10  │
 └┬────┬─┘      └┬────┬──┘   └┬────┬─┘
  │    │          │    │       │    │
 PC1  PC2       PC3  SRV1    PC5  PC6
VL10  VL20     VL20  VL30   VL10  VL10
```

### Complete Requirements Checklist

| # | Category | Requirement | Verification Command |
|---|----------|------------|---------------------|
| 1 | **L1** | All cables connected, interfaces `no shutdown` | `show ip int brief` |
| 2 | **VLANs** | VLAN 10 (Eng), 20 (Sales), 30 (Servers) on all switches | `show vlan brief` |
| 3 | **Trunks** | 802.1Q trunks between switches and routers | `show interfaces trunk` |
| 4 | **Native VLAN** | Native VLAN 99 on all trunks | `show interfaces trunk` |
| 5 | **Inter-VLAN** | Router-on-a-stick on R2 (Gi0/1.10, .20, .30) | `ping cross-VLAN` |
| 6 | **STP** | SW1 as root for VLAN 10, SW2 as root for VLAN 20 | `show spanning-tree` |
| 7 | **PortFast** | PortFast + BPDU Guard on all access ports | `show spanning-tree interface` |
| 8 | **Port Security** | Sticky, max 2, violation shutdown on access ports | `show port-security` |
| 9 | **OSPF** | Area 0 on all routers, correct network statements | `show ip ospf neighbor` |
| 10 | **Passive** | Passive-interface on all LAN interfaces | `show ip protocols` |
| 11 | **Router ID** | Explicit router-IDs (1.1.1.1, 2.2.2.2, 3.3.3.3) | `show ip ospf` |
| 12 | **Default route** | Static default on R1 → ISP | `show ip route` |
| 13 | **Default redistribution** | `default-information originate` on R1 | `show ip route` on R2/R3 |
| 14 | **NAT/PAT** | PAT on R1 for all 10.x.x.x → outside interface | `show ip nat translations` |
| 15 | **DHCP** | R2 serves pools for VLAN 10 and VLAN 20 | `show ip dhcp binding` |
| 16 | **DHCP relay** | `ip helper-address` on R3 for branch DHCP | `show ip dhcp binding` |
| 17 | **ACL** | Extended ACL: Block VLAN 20 → VLAN 30 | `show access-lists` |
| 18 | **SSH** | Enabled on all routers (RSA 2048, SSH v2) | `show ip ssh` |
| 19 | **NTP** | R1 as server, all others sync to R1 | `show ntp status` |
| 20 | **Syslog** | All devices log to SRV1 (VLAN 30) | `show logging` |
| 21 | **Banner** | MOTD on all devices | `show banner motd` |
| 22 | **Save** | All configs saved to NVRAM | `show startup-config` |

### Verification Tests (Must ALL Pass)

```
✓ PC1 (VLAN 10) → ping PC5 (VLAN 10, branch)    = SUCCESS
✓ PC1 (VLAN 10) → ping PC3 (VLAN 20)             = SUCCESS (inter-VLAN)
✓ PC3 (VLAN 20) → ping SRV1 (VLAN 30)            = FAIL (ACL blocks)
✓ PC1 (VLAN 10) → ping SRV1 (VLAN 30)            = SUCCESS
✓ PC1 → ping 203.0.113.1 (ISP)                    = SUCCESS (NAT)
✓ R2 → show ip ospf neighbor                      = FULL with R1
✓ R3 → show ip route                              = O*E2 default route visible
✓ SW1 → show port-security                        = Sticky MACs learned
```

### Time Target: 90-120 minutes

<details>
<summary><strong>Hint: Key Configs</strong></summary>

**R1 NAT/PAT:**
```
access-list 10 permit 10.0.0.0 0.255.255.255
ip nat inside source list 10 interface Gi0/0 overload
```

**R2 DHCP:**
```
ip dhcp excluded-address 10.10.10.1 10.10.10.10
ip dhcp pool VLAN10
 network 10.10.10.0 255.255.255.0
 default-router 10.10.10.1
 dns-server 8.8.8.8
```

**R2 Inter-VLAN:**
```
interface Gi0/1.10
 encapsulation dot1Q 10
 ip address 10.10.10.1 255.255.255.0
 ip nat inside
```

**ACL on R2:**
```
ip access-list extended BLOCK-SALES-SERVERS
 deny ip 10.10.20.0 0.0.0.255 10.10.30.0 0.0.0.255
 permit ip any any
!
interface Gi0/1.20
 ip access-group BLOCK-SALES-SERVERS in
```

**STP Root:**
```
! On SW1:
spanning-tree vlan 10 priority 24576

! On SW2:
spanning-tree vlan 20 priority 24576
```

</details>

---

## Challenge 4: Rapid Troubleshooting — 15 Scenarios

**Instructions:** Diagnose each problem in under 2 minutes. Write the problem AND the fix.

### Scenario 1
```
R1# show ip ospf neighbor
(empty)
R1# show ip ospf interface Gi0/0
  Network Type BROADCAST, Cost: 1
  Timer intervals: Hello 10, Dead 40
R2# show ip ospf interface Gi0/0
  Network Type BROADCAST, Cost: 1
  Timer intervals: Hello 30, Dead 120
```

<details><summary>Answer</summary>**Problem:** Hello/Dead timer mismatch (10/40 vs 30/120). **Fix:** Set matching timers on both routers.</details>

### Scenario 2
```
PC1> ping 192.168.20.1
Request timed out.
R1# show ip route
C 192.168.10.0/24 directly connected Gi0/0.10
(no route to 192.168.20.0/24)
```

<details><summary>Answer</summary>**Problem:** R1 has no route to 192.168.20.0/24. Subinterface Gi0/0.20 is likely not configured or is shut down. **Fix:** Configure `interface Gi0/0.20` with `encapsulation dot1Q 20` and correct IP.</details>

### Scenario 3
```
SW1# show vlan brief
VLAN 10 - Ports: Fa0/1, Fa0/2
VLAN 20 - Ports: Fa0/3

SW1# show interfaces trunk
Port    Vlans allowed
Gi0/1   10
```

<details><summary>Answer</summary>**Problem:** Trunk on Gi0/1 only allows VLAN 10. VLAN 20 traffic can't cross the trunk. **Fix:** `switchport trunk allowed vlan add 20` or `switchport trunk allowed vlan all`.</details>

### Scenario 4
```
R1# show ip nat translations
(empty)
R1# show run | include nat
ip nat inside source list 1 interface Gi0/0 overload
R1# show run | include access-list
access-list 1 permit 192.168.1.0 255.255.255.0
```

<details><summary>Answer</summary>**Problem:** ACL uses subnet mask (255.255.255.0) instead of wildcard mask (0.0.0.255). **Fix:** `no access-list 1` then `access-list 1 permit 192.168.1.0 0.0.0.255`.</details>

### Scenario 5
```
PC1> ipconfig
IP: 0.0.0.0
Gateway: 0.0.0.0
DHCP: enabled
R1# show ip dhcp pool
Pool OFFICE: 0 leases
  Network: 192.168.1.0/24
```

<details><summary>Answer</summary>**Problem:** Pool has 0 leases. Either: (1) no `default-router` configured in pool, (2) interface facing PC1 is down, or (3) `ip dhcp excluded-address` excludes the entire range. **Fix:** Verify pool config, check physical connectivity, verify exclusions.</details>

### Scenario 6
```
R1# ping 10.0.0.2
!!!!!
R1# show ip ospf neighbor
Neighbor ID  State     Interface
2.2.2.2      EXSTART   Gi0/0
```

<details><summary>Answer</summary>**Problem:** Stuck in EXSTART = **MTU mismatch**. Both sides can ping (Layer 3 OK) but OSPF DBD packets are too large for one side. **Fix:** Match MTU on both interfaces (e.g., `ip mtu 1500`).</details>

### Scenario 7
```
SW1# show port-security interface Fa0/1
Status: Secure-shutdown
Violation count: 3
```

<details><summary>Answer</summary>**Problem:** Port is err-disabled due to port-security violations. **Fix:** Remove offending device, then `shutdown` → `no shutdown` on Fa0/1. Consider `errdisable recovery cause psecure-violation`.</details>

### Scenario 8
```
R1# show ip ssh
SSH Enabled - version 2
R1# ssh -l admin 192.168.1.1
% Connection refused by remote host
```
VTY config: `transport input telnet`

<details><summary>Answer</summary>**Problem:** VTY lines only allow Telnet, not SSH. **Fix:** `line vty 0 15` → `transport input ssh` (or `transport input ssh telnet`).</details>

### Scenario 9
```
R1# show ip route
O    10.0.0.0/8 [110/20] via 192.168.1.2
S    10.0.0.0/8 [1/0] via 192.168.1.5
```
Traffic to 10.5.5.5 goes via 192.168.1.5. Is this correct?

<details><summary>Answer</summary>**Problem:** This WON'T happen. You won't see both routes in the table for the same prefix — only the one with the **lowest AD** (static, AD 1) will appear. The static route via 192.168.1.5 is used. If the intent was for OSPF to be primary, remove or add a higher AD to the static route.</details>

### Scenario 10
```
R2# show ip route
O*E2 0.0.0.0/0 [110/1] via 10.0.0.1
R3# show ip route
(no default route)
R1# show run | section ospf
router ospf 1
 network 10.0.0.0 0.0.0.3 area 0
 default-information originate
```

<details><summary>Answer</summary>**Problem:** R1 is advertising the default into OSPF (R2 has it). R3 likely isn't forming an OSPF adjacency with R1 or R2. Check `show ip ospf neighbor` on R3. The WAN link between R1↔R3 or R2↔R3 may not be in OSPF.</details>

### Scenario 11
```
SW1# show spanning-tree vlan 10
This bridge is the root
Priority: 32778

SW2# show spanning-tree vlan 10
Root ID Priority: 32778
        Address: 0000.0000.AAAA
Bridge ID Priority: 32778
          Address: 0000.0000.BBBB

SW2 Gi0/1: Altn BLK
```
You want SW2 to be root for VLAN 10.

<details><summary>Answer</summary>**Fix:** On SW2: `spanning-tree vlan 10 priority 24576` (or any value lower than 32778). Or on SW2: `spanning-tree vlan 10 root primary`.</details>

### Scenario 12
```
PC1> ping 8.8.8.8
Reply from 192.168.1.1: Destination host unreachable
```

<details><summary>Answer</summary>**Problem:** The router (192.168.1.1) doesn't know how to reach 8.8.8.8. Missing **default route**. **Fix:** On the router: `ip route 0.0.0.0 0.0.0.0 <ISP-gateway>`.</details>

### Scenario 13
```
R1# show ip dhcp binding
IP           MAC              Lease
192.168.1.50 0011.2233.4455   7 days

PC1> ipconfig
IP: 192.168.1.50
Gateway: (blank)
```

<details><summary>Answer</summary>**Problem:** DHCP gave an IP but no default gateway. The DHCP pool is missing `default-router`. **Fix:** Enter the DHCP pool config and add `default-router 192.168.1.1`.</details>

### Scenario 14
```
R1# show access-lists
Extended IP access list 100
 10 deny tcp any any eq 80
 20 permit ip any any
Applied: Gi0/0 in
```
Users report they can browse HTTPS sites but not HTTP. Is the ACL working correctly?

<details><summary>Answer</summary>**Answer:** **Yes, working as configured.** Line 10 blocks HTTP (port 80), line 20 allows everything else (including HTTPS/443). If users SHOULD have HTTP access, remove line 10 or change it to permit.</details>

### Scenario 15
```
R1# show ntp status
Clock is unsynchronized
stratum 16
```

<details><summary>Answer</summary>**Problem:** Stratum 16 = NOT synced to any NTP server. Either the NTP server is unreachable, the `ntp server` command is misconfigured, or an ACL is blocking UDP 123. **Fix:** Verify `ntp server <IP>`, check reachability with ping, check for blocking ACLs.</details>

---

## Challenge 5: The Final Night Review

**Task:** The night before your exam, complete this 30-minute review routine.

### Part A: Write These from Memory (10 min)

On paper, write:
1. All 7 OSI layers and 1 protocol/device per layer
2. TCP vs UDP — 3 differences
3. Administrative distance: Connected, Static, OSPF, RIP, EIGRP
4. Syslog levels 0-7 with names
5. DHCP DORA process
6. NAT: Inside Local, Inside Global, Outside Local, Outside Global
7. Port numbers: SSH, HTTP, HTTPS, DNS, DHCP (both), NTP, Syslog, SNMP
8. OSPF cost formula
9. STP root bridge election criteria
10. Three OSPF neighbor requirements

### Part B: Subnet These in Your Head (10 min)

| # | Problem | Answer |
|---|---------|--------|
| 1 | /26 usable hosts | ? |
| 2 | 192.168.1.130/25 network | ? |
| 3 | 10.0.0.0/22 broadcast | ? |
| 4 | 172.16.100.0/21 first usable | ? |
| 5 | /28 subnet mask | ? |

<details>
<summary>Answers</summary>

1. 62
2. 192.168.1.128
3. 10.0.3.255
4. 172.16.97.1 (network = 172.16.96.0)
5. 255.255.255.240

</details>

### Part C: Visualize (10 min)

Close your eyes and mentally walk through:
1. Creating a VLAN, assigning to a port, creating a trunk
2. Configuring OSPF with router-id, network statements, passive-interface
3. Setting up NAT/PAT with ACL, nat inside/outside, overload
4. Configuring port security with sticky MACs
5. Setting up SSH with domain name, RSA keys, VTY lines

If you can "see" the commands in your mind, you're ready.

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Teach a concept | ⭐ Easy | 20 minutes |
| 2. VLSM design | ⭐⭐⭐ Hard | 30 minutes |
| 3. Ultimate comprehensive lab | ⭐⭐⭐ Hard | 90-120 minutes |
| 4. Rapid troubleshooting | ⭐⭐ Medium | 30 minutes |
| 5. Final night review | ⭐⭐ Medium | 30 minutes |

---

## Congratulations!

You've completed the entire **12-week CCNA 200-301 study plan**. Here's what you've accomplished:

- **Week 1-3:** Network fundamentals, IPv4 subnetting, IPv6
- **Week 4-5:** Switching, VLANs, STP, EtherChannel
- **Week 6:** Routing — static routes and OSPF
- **Week 7:** IP services — DHCP, DNS, NAT, NTP, SNMP, Syslog
- **Week 8:** Security — ACLs, port security, DHCP snooping, DAI
- **Week 9:** Wireless networking
- **Week 10:** Network automation and programmability
- **Week 11-12:** Review, practice exams, and final preparation

**You have the knowledge. Trust your preparation. Go pass that exam!**

---

**← Back to [README](../README.md)**
