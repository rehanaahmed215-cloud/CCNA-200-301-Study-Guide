# Week 11 — Concepts: Review & Practice Exams

## Table of Contents
- [Introduction](#introduction)
- [1. CCNA 200-301 Exam Blueprint Breakdown](#1-ccna-200-301-exam-blueprint-breakdown)
- [2. Domain 1 — Network Fundamentals (20%)](#2-domain-1--network-fundamentals-20)
- [3. Domain 2 — Network Access (20%)](#3-domain-2--network-access-20)
- [4. Domain 3 — IP Connectivity (25%)](#4-domain-3--ip-connectivity-25)
- [5. Domain 4 — IP Services (10%)](#5-domain-4--ip-services-10)
- [6. Domain 5 — Security Fundamentals (15%)](#6-domain-5--security-fundamentals-15)
- [7. Domain 6 — Automation and Programmability (10%)](#7-domain-6--automation-and-programmability-10)
- [8. Common Weak Areas & How to Fix Them](#8-common-weak-areas--how-to-fix-them)
- [9. Subnetting Speed Drill — Method Review](#9-subnetting-speed-drill--method-review)
- [10. show Command Mastery](#10-show-command-mastery)
- [Quiz — 30-Question Mixed Review](#quiz--30-question-mixed-review)

---

## Introduction

Week 11 shifts from learning new topics to **consolidation and practice**. By now you've covered all six CCNA exam domains. This week focuses on:

- Identifying your weakness areas
- Drilling the topics with highest exam weight
- Taking practice exams under timed conditions
- Building speed on subnetting and `show` command interpretation

---

## 1. CCNA 200-301 Exam Blueprint Breakdown

| Domain | Weight | Topics Covered |
|--------|--------|---------------|
| 1. Network Fundamentals | **20%** | OSI/TCP-IP models, cabling, topology, IPv4/IPv6, wireless |
| 2. Network Access | **20%** | VLANs, trunking, EtherChannel, STP, Ethernet |
| 3. IP Connectivity | **25%** | Static routing, OSPF, first-hop redundancy (HSRP only awareness) |
| 4. IP Services | **10%** | DHCP, DNS, NAT/PAT, NTP, SNMP, Syslog, SSH, TFTP/FTP |
| 5. Security Fundamentals | **15%** | ACLs, port security, DHCP snooping, DAI, AAA, VPN types |
| 6. Automation & Programmability | **10%** | SDN, REST APIs, JSON/YAML, Ansible, DNA Center, Python basics |

> **Strategy:** Domains 1-3 represent **65%** of the exam. Master these first.

---

## 2. Domain 1 — Network Fundamentals (20%)

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| OSI model | All 7 layers, their functions, which protocols/devices operate at each |
| TCP vs UDP | Connection-oriented vs connectionless, 3-way handshake, port numbers |
| IPv4 addressing | Classes (historic), private ranges, subnetting, VLSM, CIDR |
| IPv6 addressing | Types (GUA, LLA, ULA), EUI-64, NDP, SLAAC vs DHCPv6 |
| Cabling | UTP categories (Cat 5e/6/6a), straight-through vs crossover, fiber (MMF/SMF) |
| Wireless | 802.11a/b/g/n/ac/ax, frequencies (2.4/5 GHz), SSID, BSS/ESS |

### Quick Self-Test

- What layer does a switch operate at? What about a router?
- What are the three private IPv4 ranges?
- What's the difference between SLAAC and stateful DHCPv6?
- How many usable hosts in a /26 network?

---

## 3. Domain 2 — Network Access (20%)

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| VLANs | Purpose, creation, assignment, voice VLAN, native VLAN |
| Trunking | 802.1Q, native VLAN mismatch issues, DTP (and why to disable it) |
| STP | Root bridge election (lowest BID), port states, PortFast, BPDU Guard |
| EtherChannel | LACP vs PAgP, channel-group config, load balancing |
| Inter-VLAN routing | Router-on-a-stick (subinterfaces), SVI (Layer-3 switch) |
| Port security | Sticky MACs, violation modes (protect/restrict/shutdown) |

### Quick Self-Test

- What happens if you have a native VLAN mismatch on a trunk?
- In STP, what criteria determine the root bridge?
- What's the difference between LACP active/passive?
- How does a router-on-a-stick know which VLAN a frame belongs to?

---

## 4. Domain 3 — IP Connectivity (25%)

> **This is the BIGGEST domain — make it your strongest.**

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| Routing concepts | Routing table components, administrative distance, longest prefix match |
| Static routes | Standard, default, floating static, next-hop vs exit-interface |
| OSPF | Single-area config, neighbor adjacency (states), DR/BDR election, cost formula, passive interfaces, default route redistribution |
| First-hop redundancy | HSRP concept (active/standby, virtual IP) — awareness level only |
| IPv6 routing | OSPFv3 basics, IPv6 static routes |

### Administrative Distance Table (MEMORIZE)

| Source | AD |
|--------|-----|
| Connected | 0 |
| Static | 1 |
| eBGP | 20 |
| EIGRP (internal) | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |
| EIGRP (external) | 170 |
| iBGP | 200 |

### Quick Self-Test

- If OSPF and RIP both learn the same route, which wins?
- What OSPF state must neighbors reach before sharing routes?
- What's the formula for OSPF cost?
- When would you use a floating static route?

---

## 5. Domain 4 — IP Services (10%)

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| DHCP | DORA process, relay agent (ip helper-address), snooping |
| DNS | A/AAAA/CNAME records, forward/reverse lookup |
| NAT/PAT | Static NAT, dynamic NAT, PAT (overload), inside/outside local/global |
| NTP | Stratum levels, client config, `ntp server` command |
| SNMP | v2c vs v3, community strings, traps vs polling |
| Syslog | Severity levels 0-7 (Emergency → Debug), `logging` config |
| QoS | Classification, marking (DSCP), queuing concepts |

### Syslog Severity Mnemonics — "Every Awesome Cisco Engineer Will Need Ice-cream Daily"

| Level | Name | Keyword |
|-------|------|---------|
| 0 | Emergency | Every |
| 1 | Alert | Awesome |
| 2 | Critical | Cisco |
| 3 | Error | Engineer |
| 4 | Warning | Will |
| 5 | Notification | Need |
| 6 | Informational | Ice-cream |
| 7 | Debug | Daily |

---

## 6. Domain 5 — Security Fundamentals (15%)

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| Threats | Malware types, social engineering, DoS/DDoS, spoofing |
| AAA | TACACS+ vs RADIUS differences |
| ACLs | Standard (source only), extended (src+dst+port), numbered vs named, placement rules |
| Port security | Config, violation modes, sticky learning |
| DHCP snooping | Trusted/untrusted ports, binding table |
| DAI | Uses DHCP snooping binding table, prevents ARP spoofing |
| VPN | Site-to-site vs remote access, IPsec vs SSL/TLS |

### ACL Placement Rules (CRITICAL)

- **Extended ACLs** → Place close to the **source**
- **Standard ACLs** → Place close to the **destination**
- Implicit `deny any` at the end of every ACL

### Wildcard Mask Quick Reference

| Subnet Mask | Wildcard Mask | Meaning |
|-------------|--------------|---------|
| 255.255.255.255 | 0.0.0.0 | Match exact host |
| 255.255.255.0 | 0.0.0.255 | Match /24 network |
| 255.255.0.0 | 0.0.255.255 | Match /16 network |
| 255.255.255.252 | 0.0.0.3 | Match /30 (point-to-point) |

---

## 7. Domain 6 — Automation and Programmability (10%)

### Key Topics to Nail

| Topic | What You MUST Know |
|-------|-------------------|
| SDN | Controller-based vs traditional, data/control/management planes |
| DNA Center | Intent-based networking, Assurance, image management |
| REST APIs | CRUD ↔ HTTP methods, status codes (200/201/401/403/404) |
| Data formats | JSON vs XML vs YAML syntax |
| Config management | Ansible (agentless/SSH), Puppet/Chef (agent-based) |
| Python basics | Variables, loops, conditionals, json library, requests library |

### HTTP Methods ↔ CRUD Mapping

| CRUD | HTTP Method |
|------|------------|
| Create | POST |
| Read | GET |
| Update | PUT / PATCH |
| Delete | DELETE |

---

## 8. Common Weak Areas & How to Fix Them

Based on CCNA exam feedback, these are the topics students most often fail:

| Weak Area | Fix Strategy |
|-----------|-------------|
| **Subnetting speed** | Do 20 problems daily until you can subnet a /21 in <30 seconds |
| **OSPF neighbor states** | Build the lab, break adjacencies intentionally, observe outputs |
| **ACL wildcard masks** | Practice: "What wildcard matches 10.1.4.0 – 10.1.7.255?" |
| **NAT terminology** | Draw the four NAT addresses on a diagram every day |
| **STP port roles** | Trace root path cost by hand on 3-switch topologies |
| **IPv6 address types** | Flash cards: see prefix → name the type (FE80::/10, 2000::/3, etc.) |

---

## 9. Subnetting Speed Drill — Method Review

### The Fast Method (Powers of 2)

**Given:** 172.16.50.0/22 — Find network, broadcast, first/last host, number of hosts.

1. **/22 means** → 32 - 22 = **10 host bits** → 2^10 = 1024 addresses → 1022 usable hosts
2. **Subnet mask:** 255.255.252.0 (256 - 4 = 252 in the 3rd octet)
3. **Block size in 3rd octet:** 4 (increments: 0, 4, 8, 12 ...)
4. **172.16.50.0** → 50 falls into the block starting at **48** (48 ÷ 4 = 12, next = 52)
5. **Network:** 172.16.48.0
6. **Broadcast:** 172.16.51.255 (next network - 1 = 52.0 - 1)
7. **First host:** 172.16.48.1
8. **Last host:** 172.16.51.254

### Practice These Instantly

| Given | Find Network | Find Broadcast | Usable Hosts |
|-------|-------------|---------------|-------------|
| 10.0.5.200/20 | ? | ? | ? |
| 192.168.99.130/26 | ? | ? | ? |
| 172.16.200.50/23 | ? | ? | ? |
| 10.1.1.1/30 | ? | ? | ? |

<details>
<summary><strong>Answers</strong></summary>

| Given | Network | Broadcast | Usable Hosts |
|-------|---------|-----------|-------------|
| 10.0.5.200/20 | 10.0.0.0 | 10.0.15.255 | 4094 |
| 192.168.99.130/26 | 192.168.99.128 | 192.168.99.191 | 62 |
| 172.16.200.50/23 | 172.16.200.0 | 172.16.201.255 | 510 |
| 10.1.1.1/30 | 10.1.1.0 | 10.1.1.3 | 2 |

</details>

---

## 10. show Command Mastery

You will see `show` command output on the exam and must interpret it. Know these cold:

### Routing & Layer 3

| Command | What It Shows |
|---------|--------------|
| `show ip route` | Full routing table (codes: C, S, O, etc.) |
| `show ip ospf neighbor` | OSPF neighbor states, DR/BDR, interface |
| `show ip ospf interface brief` | OSPF-enabled interfaces, area, cost |
| `show ip protocols` | Routing protocols running, networks, AD |
| `show ip interface brief` | IP addresses, interface status (up/down) |

### Switching & Layer 2

| Command | What It Shows |
|---------|--------------|
| `show vlan brief` | VLAN IDs, names, assigned ports |
| `show interfaces trunk` | Trunk ports, encapsulation, allowed VLANs |
| `show spanning-tree` | Root bridge, port roles/states, cost |
| `show etherchannel summary` | Port-channel status, member interfaces |
| `show mac address-table` | MAC → port mappings |

### Security

| Command | What It Shows |
|---------|--------------|
| `show access-lists` | All ACLs with match counts |
| `show port-security interface` | Violation mode, status, learned MACs |
| `show ip dhcp snooping binding` | Trusted bindings (MAC ↔ IP ↔ Port) |

### Services

| Command | What It Shows |
|---------|--------------|
| `show ip nat translations` | Active NAT table entries |
| `show ip dhcp binding` | DHCP leases (server side) |
| `show ntp status` | NTP sync status, stratum, reference |
| `show logging` | Syslog messages and severity filters |

---

## Quiz — 30-Question Mixed Review

*Time yourself. Target: 30 questions in 30 minutes.*

**1.** At which OSI layer does a router primarily operate?

<details><summary>Answer</summary>Layer 3 (Network)</details>

**2.** What is the default administrative distance of OSPF?

<details><summary>Answer</summary>110</details>

**3.** How many usable host addresses are in a /28 network?

<details><summary>Answer</summary>14 (2^4 - 2 = 14)</details>

**4.** What STP port state forwards frames and learns MACs?

<details><summary>Answer</summary>Forwarding</details>

**5.** Which NAT type maps multiple private IPs to one public IP using port numbers?

<details><summary>Answer</summary>PAT (Port Address Translation) / NAT Overload</details>

**6.** What command places an interface into VLAN 10?

<details><summary>Answer</summary>`switchport access vlan 10` (after `switchport mode access`)</details>

**7.** In OSPF, what determines the DR in a multi-access network?

<details><summary>Answer</summary>Highest OSPF priority (default 1), then highest Router ID as tiebreaker</details>

**8.** What is the wildcard mask for a /26 subnet?

<details><summary>Answer</summary>0.0.0.63</details>

**9.** What protocol does DHCP snooping protect against?

<details><summary>Answer</summary>Rogue DHCP servers (DHCP spoofing/starvation)</details>

**10.** What does the `D` code mean in `show ip route` output?

<details><summary>Answer</summary>EIGRP-learned route</details>

**11.** What port does SSH use?

<details><summary>Answer</summary>TCP 22</details>

**12.** What is the purpose of a VLAN trunk?

<details><summary>Answer</summary>Carry traffic for multiple VLANs between switches (using 802.1Q tagging)</details>

**13.** In HSRP, what is the virtual IP used for?

<details><summary>Answer</summary>Default gateway address shared between two or more routers for redundancy</details>

**14.** What Syslog severity level is "Warning"?

<details><summary>Answer</summary>Level 4</details>

**15.** What is the subnet mask for a /20?

<details><summary>Answer</summary>255.255.240.0</details>

**16.** What does PortFast do?

<details><summary>Answer</summary>Immediately transitions an access port to forwarding state, bypassing STP listening/learning (used for end-host ports only)</details>

**17.** What HTTP status code means "Unauthorized"?

<details><summary>Answer</summary>401</details>

**18.** What OSPF packet type establishes neighbor adjacency?

<details><summary>Answer</summary>Hello packet</details>

**19.** What is the broadcast address for 192.168.10.0/27?

<details><summary>Answer</summary>192.168.10.31</details>

**20.** What's the difference between TACACS+ and RADIUS authentication?

<details><summary>Answer</summary>TACACS+ uses TCP (port 49), encrypts entire payload, separates AAA functions. RADIUS uses UDP (1812/1813), only encrypts password, combines authentication and authorization.</details>

**21.** What data format uses curly braces `{}` and square brackets `[]`?

<details><summary>Answer</summary>JSON</details>

**22.** Name three differences between TCP and UDP.

<details><summary>Answer</summary>TCP: connection-oriented, reliable (ACKs), ordered delivery, windowing. UDP: connectionless, unreliable, no ordering, lower overhead.</details>

**23.** What does `ip helper-address` do?

<details><summary>Answer</summary>Forwards UDP broadcast packets (like DHCP Discover) as unicast to a specified server IP — acts as a DHCP relay agent</details>

**24.** What is the IPv6 link-local prefix?

<details><summary>Answer</summary>FE80::/10</details>

**25.** In EtherChannel, what happens if one member link fails?

<details><summary>Answer</summary>Traffic is redistributed across remaining links — the port-channel stays up with reduced bandwidth</details>

**26.** What Ansible connection type is used for network devices?

<details><summary>Answer</summary>`network_cli` (SSH-based, agentless)</details>

**27.** What is the OSPF cost formula for Cisco devices?

<details><summary>Answer</summary>Cost = Reference Bandwidth / Interface Bandwidth (default ref BW = 100 Mbps)</details>

**28.** What ACL type should be placed closest to the source?

<details><summary>Answer</summary>Extended ACL (because it can filter on source AND destination)</details>

**29.** What does NDP (Neighbor Discovery Protocol) replace from IPv4?

<details><summary>Answer</summary>ARP (Address Resolution Protocol)</details>

**30.** A packet arrives for 10.1.5.200. The routing table has: `10.0.0.0/8`, `10.1.0.0/16`, and `10.1.5.0/24`. Which route is used?

<details><summary>Answer</summary>`10.1.5.0/24` — **longest prefix match** (/24 is the most specific match)</details>

---

### Score Yourself

| Score | Assessment |
|-------|-----------|
| 27-30 | Exam ready — focus on speed |
| 22-26 | Almost there — review missed topics |
| 17-21 | Solid foundation — need more practice |
| Below 17 | Re-study weak domains before exam |

---

## Sources & Further Reading

- [Cisco CCNA 200-301 Exam Topics](https://learningnetwork.cisco.com/s/ccna-exam-topics) — Official exam blueprint (review all domains)
- [Cisco Learning Network — CCNA Study Group](https://learningnetwork.cisco.com/s/topic/0TO3i000000yEbsGAE/ccna-certification-community) — Community Q&A and tips
- [Boson ExSim for CCNA](https://www.boson.com/practice-exam/200-301-cisco-ccna-practice-exam) — High-quality practice exams
- [Pearson CCNA Practice Tests](https://www.ciscopress.com/store/ccna-200-301-official-cert-guide-library-9781587147142) — Official cert guide practice exams
- [Subnetting Practice — subnettingpractice.com](https://subnettingpractice.com/) — Timed subnetting drills
- [Practical Networking — Full Course Index](https://www.practicalnetworking.net/) — Review any weak topic
- [Jeremy's IT Lab — Full CCNA Playlist (YouTube)](https://www.youtube.com/playlist?list=PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ) — Revisit any concept

---

**→ Continue to [Exercises](exercises.md) for timed practice exams and lab rebuilds.**
