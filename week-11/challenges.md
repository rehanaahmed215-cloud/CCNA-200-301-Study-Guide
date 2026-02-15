# Week 11 — Challenges: Review & Practice Exams

## Table of Contents
- [Challenge 1: Build a Complete Enterprise Network from Scratch](#challenge-1-build-a-complete-enterprise-network-from-scratch)
- [Challenge 2: Top 30 IOS Commands Cheat Sheet](#challenge-2-top-30-ios-commands-cheat-sheet)
- [Challenge 3: Subnet Design for a Real Company](#challenge-3-subnet-design-for-a-real-company)
- [Challenge 4: Troubleshoot a Broken Network (All-In-One)](#challenge-4-troubleshoot-a-broken-network-all-in-one)
- [Challenge 5: Exam Simulation — Beat the Clock](#challenge-5-exam-simulation--beat-the-clock)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Build a Complete Enterprise Network from Scratch

**Task:** Design and configure a network from scratch that incorporates **everything you've learned in Weeks 1-10**. Use Packet Tracer or Containerlab.

### Network Requirements

```
                    [ISP]
                      |
                   [R1-Edge]
                   /        \
              [R2-HQ]     [R3-Branch]
              /    \           |
         [SW1]   [SW2]     [SW3]
          |  |     |  |       |  |
        PC1 PC2  PC3 PC4   PC5 PC6
```

### Configuration Requirements

| Feature | Details |
|---------|---------|
| **VLANs** | VLAN 10 (Engineering), VLAN 20 (Sales), VLAN 30 (Management) |
| **Trunking** | 802.1Q trunks between switches and routers |
| **Inter-VLAN** | Router-on-a-stick at R2-HQ |
| **OSPF** | Single area 0 between R1, R2, R3 |
| **NAT/PAT** | PAT on R1-Edge for internet access |
| **Default route** | Static default on R1 → ISP, redistributed into OSPF |
| **DHCP** | R2-HQ as DHCP server for VLANs 10 and 20 |
| **ACLs** | Block VLAN 20 (Sales) from accessing VLAN 30 (Management) |
| **Port security** | Sticky MAC, max 2 MACs on access ports |
| **SSH** | Enabled on all routers and switches |
| **NTP** | R1-Edge as NTP server, all others sync to it |
| **Syslog** | All devices log to a syslog server (PC3) |
| **Banner** | MOTD warning banner on all devices |

### IP Addressing Scheme (Design Your Own)

Use the 10.0.0.0/8 private range. Suggested breakdown:
- WAN links: /30 subnets
- LAN VLANs: /24 subnets
- Management: /28 subnet

### Deliverables
1. Completed topology (screenshot or topology.yml)
2. Running configs from each device
3. Verification: ping from PC1 (VLAN 10) to PC5 (VLAN 10 at branch)
4. Verification: `show ip nat translations` showing PAT entries
5. Verification: `show ip ospf neighbor` showing Full adjacencies

### Time Target: 90 minutes

<details>
<summary><strong>Reference IP Plan</strong></summary>

| Subnet | Network | Purpose |
|--------|---------|---------|
| R1-R2 WAN | 10.0.0.0/30 | R1=.1, R2=.2 |
| R1-R3 WAN | 10.0.0.4/30 | R1=.5, R3=.6 |
| VLAN 10 (Eng) | 10.10.10.0/24 | GW=.1, DHCP pool .100-.200 |
| VLAN 20 (Sales) | 10.10.20.0/24 | GW=.1, DHCP pool .100-.200 |
| VLAN 30 (Mgmt) | 10.10.30.0/28 | GW=.1, Static only |
| Branch LAN | 10.20.10.0/24 | GW=.1 |
| R1 → ISP | 203.0.113.0/30 | R1=.2, ISP=.1 |

**NAT Config (R1):**
```
ip nat inside source list 10 interface Gi0/0 overload
access-list 10 permit 10.0.0.0 0.255.255.255
interface Gi0/0
 ip nat outside
interface Gi0/1
 ip nat inside
interface Gi0/2
 ip nat inside
```

**ACL (Block Sales→Mgmt):**
```
ip access-list extended BLOCK-SALES-TO-MGMT
 deny ip 10.10.20.0 0.0.0.255 10.10.30.0 0.0.0.15
 permit ip any any
interface Gi0/0.20
 ip access-group BLOCK-SALES-TO-MGMT in
```

</details>

---

## Challenge 2: Top 30 IOS Commands Cheat Sheet

**Task:** Create your own cheat sheet from memory. For each command, write:
1. The full command
2. What it does (one sentence)
3. What mode you run it from

**The 30 Commands (fill in the rest):**

| # | Command | Purpose | Mode |
|---|---------|---------|------|
| 1 | `show ip route` | ? | ? |
| 2 | `show vlan brief` | ? | ? |
| 3 | `show interfaces trunk` | ? | ? |
| 4 | `show ip ospf neighbor` | ? | ? |
| 5 | `show spanning-tree` | ? | ? |
| 6 | `show mac address-table` | ? | ? |
| 7 | `show ip interface brief` | ? | ? |
| 8 | `show access-lists` | ? | ? |
| 9 | `show ip nat translations` | ? | ? |
| 10 | `show port-security interface` | ? | ? |
| 11 | `show ip dhcp binding` | ? | ? |
| 12 | `show ntp status` | ? | ? |
| 13 | `show etherchannel summary` | ? | ? |
| 14 | `show ip protocols` | ? | ? |
| 15 | `show running-config` | ? | ? |
| 16 | `copy run start` | ? | ? |
| 17 | `configure terminal` | ? | ? |
| 18 | `interface GigabitEthernet0/0` | ? | ? |
| 19 | `switchport mode access` | ? | ? |
| 20 | `switchport access vlan 10` | ? | ? |
| 21 | `switchport mode trunk` | ? | ? |
| 22 | `router ospf 1` | ? | ? |
| 23 | `network X.X.X.X W.W.W.W area 0` | ? | ? |
| 24 | `ip route 0.0.0.0 0.0.0.0 X.X.X.X` | ? | ? |
| 25 | `ip nat inside` | ? | ? |
| 26 | `access-list 100 permit ...` | ? | ? |
| 27 | `ip access-group 100 in` | ? | ? |
| 28 | `channel-group 1 mode active` | ? | ? |
| 29 | `spanning-tree portfast` | ? | ? |
| 30 | `crypto key generate rsa` | ? | ? |

<details>
<summary><strong>Complete Answer Key</strong></summary>

| # | Command | Purpose | Mode |
|---|---------|---------|------|
| 1 | `show ip route` | Displays the routing table (C, S, O, etc.) | Privileged EXEC |
| 2 | `show vlan brief` | Shows VLANs, status, and port assignments | Privileged EXEC |
| 3 | `show interfaces trunk` | Shows trunk ports, encapsulation, allowed VLANs | Privileged EXEC |
| 4 | `show ip ospf neighbor` | Shows OSPF neighbor states, DR/BDR, interfaces | Privileged EXEC |
| 5 | `show spanning-tree` | Shows STP root, port roles/states, cost | Privileged EXEC |
| 6 | `show mac address-table` | Shows learned MAC addresses and their ports | Privileged EXEC |
| 7 | `show ip interface brief` | Shows all interfaces with IP, status, protocol | Privileged EXEC |
| 8 | `show access-lists` | Shows all ACLs with match counts | Privileged EXEC |
| 9 | `show ip nat translations` | Shows active NAT translation table | Privileged EXEC |
| 10 | `show port-security interface X` | Shows port security status, violations, MACs learned | Privileged EXEC |
| 11 | `show ip dhcp binding` | Shows DHCP leases assigned by the server | Privileged EXEC |
| 12 | `show ntp status` | Shows NTP sync status, stratum, reference clock | Privileged EXEC |
| 13 | `show etherchannel summary` | Shows port-channel status and member ports | Privileged EXEC |
| 14 | `show ip protocols` | Shows active routing protocols, AD, networks | Privileged EXEC |
| 15 | `show running-config` | Shows current active configuration in RAM | Privileged EXEC |
| 16 | `copy run start` | Saves running-config to startup-config (NVRAM) | Privileged EXEC |
| 17 | `configure terminal` | Enters global configuration mode | Privileged EXEC |
| 18 | `interface Gi0/0` | Enters interface configuration mode | Global config |
| 19 | `switchport mode access` | Sets port as an access (non-trunk) port | Interface config |
| 20 | `switchport access vlan 10` | Assigns port to VLAN 10 | Interface config |
| 21 | `switchport mode trunk` | Sets port as an 802.1Q trunk | Interface config |
| 22 | `router ospf 1` | Enters OSPF router config (process ID 1) | Global config |
| 23 | `network X.X.X.X W.W.W.W area 0` | Advertises a network in OSPF area 0 | Router config |
| 24 | `ip route 0.0.0.0 0.0.0.0 X.X.X.X` | Creates a default static route | Global config |
| 25 | `ip nat inside` | Marks interface as NAT inside | Interface config |
| 26 | `access-list 100 permit ...` | Creates a numbered extended ACL entry | Global config |
| 27 | `ip access-group 100 in` | Applies ACL 100 inbound on the interface | Interface config |
| 28 | `channel-group 1 mode active` | Adds interface to EtherChannel using LACP | Interface config |
| 29 | `spanning-tree portfast` | Enables PortFast (skip STP stages) on access port | Interface config |
| 30 | `crypto key generate rsa` | Generates RSA key pair for SSH | Global config |

</details>

---

## Challenge 3: Subnet Design for a Real Company

**Task:** You're hired as a network consultant. Design an IP addressing scheme using **VLSM** for the following company:

### Company: TechStart Inc.

| Department | Location | Hosts Needed |
|-----------|----------|-------------|
| Engineering | Floor 1 | 120 hosts |
| Sales | Floor 2 | 55 hosts |
| HR | Floor 2 | 25 hosts |
| Management | Floor 3 | 10 hosts |
| Server Room | Basement | 6 hosts |
| WAN Link 1 | R1-R2 | 2 hosts (point-to-point) |
| WAN Link 2 | R2-R3 | 2 hosts (point-to-point) |
| WAN Link 3 | R1-R3 | 2 hosts (point-to-point) |

**Starting network:** 172.20.0.0/16

### Deliverables
1. Subnet table with: network address, subnet mask, first host, last host, broadcast, usable hosts
2. Proof that no subnets overlap
3. Address wasted (total addresses allocated - total hosts needed)

<details>
<summary><strong>Solution</strong></summary>

**VLSM Approach:** Allocate largest subnet first, then progressively smaller.

| Department | Hosts | Subnet Size | Network | Mask | Range | Broadcast |
|-----------|-------|-------------|---------|------|-------|-----------|
| Engineering | 120 | /24 (254) | 172.20.0.0 | /24 | .1 – .254 | 172.20.0.255 |
| Sales | 55 | /26 (62) | 172.20.1.0 | /26 | .1 – .62 | 172.20.1.63 |
| HR | 25 | /27 (30) | 172.20.1.64 | /27 | .65 – .94 | 172.20.1.95 |
| Management | 10 | /28 (14) | 172.20.1.96 | /28 | .97 – .110 | 172.20.1.111 |
| Server Room | 6 | /28 (14) | 172.20.1.112 | /28 | .113 – .126 | 172.20.1.127 |
| WAN Link 1 | 2 | /30 (2) | 172.20.1.128 | /30 | .129 – .130 | 172.20.1.131 |
| WAN Link 2 | 2 | /30 (2) | 172.20.1.132 | /30 | .133 – .134 | 172.20.1.135 |
| WAN Link 3 | 2 | /30 (2) | 172.20.1.136 | /30 | .137 – .138 | 172.20.1.139 |

**Verification:**
- No overlaps: Each subnet starts after the previous one's broadcast address ✓
- Total hosts needed: 120 + 55 + 25 + 10 + 6 + 2 + 2 + 2 = **222**
- Total addresses allocated: 254 + 62 + 30 + 14 + 14 + 2 + 2 + 2 = **380**
- Waste: 380 - 222 = **158 addresses** (41.6% waste — acceptable for VLSM)

</details>

---

## Challenge 4: Troubleshoot a Broken Network (All-In-One)

**Task:** The following network was configured by a junior admin. It has **8 errors**. Find and fix all of them.

### Topology
```
[R1] ──── [SW1] ──── [PC1 - VLAN 10]
  |                    [PC2 - VLAN 20]
  |
 NAT to ISP (203.0.113.1)
```

### R1 Configuration (with errors)
```
hostname R1
!
interface GigabitEthernet0/0
 ip address 203.0.113.2 255.255.255.252
 ip nat outside
!
interface GigabitEthernet0/1
 no ip address
!
interface GigabitEthernet0/1.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
!
interface GigabitEthernet0/1.20
 encapsulation dot1Q 20
 ip address 192.168.10.1 255.255.255.0
!
router ospf 1
 network 192.168.10.0 0.0.0.255 area 0
 network 192.168.20.0 0.0.0.255 area 1
!
ip nat inside source list 1 interface GigabitEthernet0/0 overload
access-list 1 permit 192.168.10.0 255.255.255.0
!
ip route 0.0.0.0 0.0.0.0 203.0.113.5
!
line vty 0 4
 transport input telnet
 login local
```

### SW1 Configuration (with errors)
```
hostname SW1
!
vlan 10
 name Engineering
vlan 20
 name Sales
!
interface GigabitEthernet0/1
 switchport mode access
 switchport access vlan 10
 description "Uplink to R1"
!
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
!
interface FastEthernet0/2
 switchport mode access
 switchport access vlan 20
```

<details>
<summary><strong>All 8 Errors</strong></summary>

**Error 1:** R1 Gi0/1.20 has the same IP as Gi0/1.10 (192.168.10.1).
**Fix:** Change Gi0/1.20 IP to `192.168.20.1 255.255.255.0`

**Error 2:** R1 subinterfaces are missing `ip nat inside`.
**Fix:** Add `ip nat inside` to both Gi0/1.10 and Gi0/1.20.

**Error 3:** OSPF area mismatch — both networks should be area 0 (single-area OSPF).
**Fix:** Change `network 192.168.20.0 0.0.0.255 area 0`

**Error 4:** NAT ACL uses subnet mask (255.255.255.0) instead of wildcard mask (0.0.0.255). Also only covers 192.168.10.0, missing 192.168.20.0.
**Fix:** `access-list 1 permit 192.168.10.0 0.0.0.255` and add `access-list 1 permit 192.168.20.0 0.0.0.255`

**Error 5:** Default route next-hop (203.0.113.5) doesn't match the ISP gateway. R1's interface is .2/30, so valid hosts are .1 and .2. Gateway should be .1.
**Fix:** `ip route 0.0.0.0 0.0.0.0 203.0.113.1`

**Error 6:** VTY lines use `transport input telnet` — should use SSH for security.
**Fix:** `transport input ssh` (and configure `crypto key generate rsa`, `ip domain-name`, etc.)

**Error 7:** SW1 Gi0/1 (uplink to R1) is set as an **access port** in VLAN 10. It should be a **trunk** to carry both VLANs.
**Fix:** `switchport mode trunk` (remove the `switchport access vlan 10`)

**Error 8:** R1 Gi0/1 physical interface needs to be `no shutdown` (not shown, but the subinterfaces won't work if the parent is down).
**Fix:** Ensure `no shutdown` on Gi0/1.

</details>

---

## Challenge 5: Exam Simulation — Beat the Clock

**Task:** Complete these 10 tasks as fast as possible. Each one simulates a common exam scenario.

### Rules
- Start a timer
- Complete all 10 in order
- Write your answer/config before checking
- Target: all 10 in 25 minutes

### Task 1: Subnet Math
What is the broadcast address for 10.45.128.0/19?

### Task 2: Wildcard Mask
Write the wildcard mask to match hosts 172.16.4.0 through 172.16.7.255.

### Task 3: OSPF Config
Write the Cisco IOS commands to enable OSPF process 1, advertise 192.168.50.0/24 in area 0, and set router-id to 5.5.5.5.

### Task 4: ACL
Write a named extended ACL called "WEB-ONLY" that permits only HTTP and HTTPS from 10.0.0.0/8 to any destination, and denies everything else explicitly.

### Task 5: NAT
Write the commands to configure PAT on R1 where Gi0/0 is the outside interface, Gi0/1 is inside, and the inside network is 192.168.1.0/24.

### Task 6: STP Question
On a switch with default STP priority, another switch has priority 28672. Which one becomes root?

### Task 7: DHCP Pool
Write the IOS commands to create a DHCP pool named "LAN" for network 192.168.100.0/24, default gateway .1, DNS 8.8.8.8, and exclude .1 through .10.

### Task 8: Port Security
Write the commands to enable sticky port security on Fa0/1 with a max of 3 MACs and shutdown violation mode.

### Task 9: Interpret Output
```
O     10.0.0.0/8 [110/20] via 192.168.1.2, 00:15:30, Gi0/0
S*    0.0.0.0/0 [1/0] via 203.0.113.1
```
A packet for 10.5.5.5 arrives. Which route is used?

### Task 10: IPv6
What IPv6 address type starts with 2000::/3 and what is it called?

<details>
<summary><strong>Answers</strong></summary>

**Task 1:** /19 = block of 32 in 3rd octet. 128/32 = 4th block starts at 128. Broadcast = **10.45.159.255**

**Task 2:** 172.16.4.0 to 172.16.7.255 spans 4 subnets in 3rd octet. Wildcard = **0.0.3.255**

**Task 3:**
```
router ospf 1
 router-id 5.5.5.5
 network 192.168.50.0 0.0.0.255 area 0
```

**Task 4:**
```
ip access-list extended WEB-ONLY
 permit tcp 10.0.0.0 0.255.255.255 any eq 80
 permit tcp 10.0.0.0 0.255.255.255 any eq 443
 deny ip any any
```

**Task 5:**
```
access-list 1 permit 192.168.1.0 0.0.0.255
ip nat inside source list 1 interface GigabitEthernet0/0 overload
interface GigabitEthernet0/0
 ip nat outside
interface GigabitEthernet0/1
 ip nat inside
```

**Task 6:** Default priority = 32768. The other switch has 28672 (lower). **The 28672 switch becomes root** (lowest BID wins).

**Task 7:**
```
ip dhcp excluded-address 192.168.100.1 192.168.100.10
ip dhcp pool LAN
 network 192.168.100.0 255.255.255.0
 default-router 192.168.100.1
 dns-server 8.8.8.8
```

**Task 8:**
```
interface FastEthernet0/1
 switchport mode access
 switchport port-security
 switchport port-security maximum 3
 switchport port-security violation shutdown
 switchport port-security mac-address sticky
```

**Task 9:** The **OSPF route (10.0.0.0/8)** is used. 10.5.5.5 matches 10.0.0.0/8. The default route also matches, but /8 is a **longer prefix** than /0.

**Task 10:** **Global Unicast Address (GUA)** — routable on the internet, similar to public IPv4 addresses.

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Enterprise network build | ⭐⭐⭐ Hard | 90 minutes |
| 2. IOS commands cheat sheet | ⭐⭐ Medium | 20 minutes |
| 3. VLSM subnet design | ⭐⭐ Medium | 25 minutes |
| 4. Troubleshoot broken network | ⭐⭐⭐ Hard | 30 minutes |
| 5. Beat the clock | ⭐⭐ Medium | 25 minutes |

---

**Week 11 complete! → [Start Week 12](../week-12/concepts.md)**
