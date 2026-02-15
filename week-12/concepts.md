# Week 12 — Concepts: Final Review & Exam Readiness

## Table of Contents
- [Introduction](#introduction)
- [1. CCNA 200-301 Exam Format](#1-ccna-200-301-exam-format)
- [2. Question Types & Strategies](#2-question-types--strategies)
- [3. Time Management Plan](#3-time-management-plan)
- [4. Domain-by-Domain Final Checklist](#4-domain-by-domain-final-checklist)
- [5. The 20 Most-Tested Topics](#5-the-20-most-tested-topics)
- [6. Common Exam Traps & Tricks](#6-common-exam-traps--tricks)
- [7. Last-Night Review Sheet](#7-last-night-review-sheet)
- [8. Exam Day Logistics](#8-exam-day-logistics)
- [9. Post-Exam: What's Next?](#9-post-exam-whats-next)
- [Quiz — 10-Question Final Confidence Check](#quiz--10-question-final-confidence-check)

---

## Introduction

This is it — your final week of preparation. By now you've:
- ✅ Learned all six CCNA domains (Weeks 1-10)
- ✅ Practiced with labs, challenges, and troubleshooting (every week)
- ✅ Taken practice exams and drilled weak areas (Week 11)

Week 12 is about **sharpening edges, building confidence, and eliminating last-minute gaps.**

---

## 1. CCNA 200-301 Exam Format

| Detail | Value |
|--------|-------|
| Exam code | 200-301 |
| Full name | Cisco Certified Network Associate |
| Questions | **100-120** |
| Duration | **120 minutes** (2 hours) |
| Passing score | **~825 out of 1000** (~82.5%) |
| Question types | Multiple choice, multiple answer, drag-and-drop, fill-in-the-blank, simlet (simulation) |
| Cost | **$330 USD** (as of 2024) |
| Delivery | Pearson VUE (test center or online proctored) |
| Validity | **3 years** |
| Prerequisites | None (entry-level certification) |

> **Note:** Cisco does not publish the exact number of scored vs. unscored questions. Some questions may be experimental (unscored) but you won't know which ones.

---

## 2. Question Types & Strategies

### Multiple Choice (Single Answer)
- **Format:** Choose ONE correct answer from A-D
- **Strategy:** Eliminate obviously wrong answers first. Usually 2 are clearly wrong, leaving 50/50.
- **Watch for:** "BEST answer" — multiple options may be partially correct.

### Multiple Answer (Select All)
- **Format:** "Choose TWO" or "Choose THREE"
- **Strategy:** The number of correct answers is always stated. Pick exactly that many.
- **Watch for:** If you're told "choose 2," you MUST select exactly 2. No partial credit.

### Drag-and-Drop
- **Format:** Match items on the left to categories on the right
- **Strategy:** Start with items you're 100% sure about. Use process of elimination for the rest.
- **Common topics:** OSI layers ↔ protocols, port numbers ↔ services, NAT terms ↔ definitions

### Fill-in-the-Blank
- **Format:** Type a command or value
- **Strategy:** Spelling and syntax matter. Practice typing exact IOS commands.
- **Watch for:** Some accept abbreviations (e.g., `sh ip ro`), but use full commands to be safe.

### Simlet (Simulation-like)
- **Format:** View a network diagram and answer multiple questions about it
- **Strategy:** Read ALL sub-questions before starting. Gather info systematically.
- **Watch for:** These are multi-part — getting the first part wrong may cascade errors.

---

## 3. Time Management Plan

**Total: 120 minutes for ~110 questions = ~65 seconds per question**

| Phase | Time | Questions | Strategy |
|-------|------|-----------|----------|
| **First pass** | 0:00-1:30 | All ~110 | Answer what you know, flag unknowns. Don't spend >90 sec on any question. |
| **Second pass** | 1:30-1:50 | Flagged only | Return to flagged questions with fresh eyes. |
| **Final review** | 1:50-2:00 | Spot-check | Review any answers you changed. Trust your first instinct unless you find a clear error. |

### Key Rules
1. **Never leave a question blank** — there's no penalty for guessing
2. **Flag and move on** if you're stuck — don't burn 3 minutes on one question
3. **Read the ENTIRE question** before looking at answers
4. **Watch for negatives** — "Which is NOT..." or "Which does NOT..."

---

## 4. Domain-by-Domain Final Checklist

Rate your confidence 1-5 for each sub-topic. Anything below 4 needs review.

### Domain 1: Network Fundamentals (20%)
- [ ] OSI model — all 7 layers and their functions
- [ ] TCP/IP model — 4 layers mapping to OSI
- [ ] TCP vs UDP — handshake, port numbers, use cases
- [ ] IPv4 subnetting — /16 through /30, quickly
- [ ] IPv6 addresses — GUA, LLA, ULA, multicast, anycast
- [ ] Cabling types — UTP, STP, fiber (MMF vs SMF)
- [ ] Wireless standards — 802.11a/b/g/n/ac/ax, frequencies

### Domain 2: Network Access (20%)
- [ ] VLAN configuration — create, assign, verify
- [ ] Trunking — 802.1Q, native VLAN, DTP
- [ ] STP — root bridge, port states, PortFast, BPDU Guard
- [ ] EtherChannel — LACP vs PAgP, config, verification
- [ ] Inter-VLAN routing — router-on-a-stick, SVI

### Domain 3: IP Connectivity (25%)
- [ ] Routing table components — code, AD, metric, next-hop
- [ ] Static routes — default, floating, next-hop vs exit-interface
- [ ] OSPF single-area — config, neighbors, DR/BDR, cost, passive-interface
- [ ] OSPF default route redistribution
- [ ] IPv6 routing basics
- [ ] Administrative distance table (memorized)

### Domain 4: IP Services (10%)
- [ ] DHCP — DORA, relay, pool config, snooping
- [ ] DNS — A, AAAA, CNAME records
- [ ] NAT/PAT — static, dynamic, overload, inside/outside addresses
- [ ] NTP — stratum, config
- [ ] SNMP — v2c vs v3
- [ ] Syslog — severity levels 0-7
- [ ] QoS — classification, marking, queuing concepts

### Domain 5: Security Fundamentals (15%)
- [ ] Threat types — malware, social engineering, DoS
- [ ] AAA — TACACS+ vs RADIUS
- [ ] ACLs — standard, extended, named, wildcard masks, placement
- [ ] Port security — config, violation modes
- [ ] DHCP snooping and DAI
- [ ] SSH configuration
- [ ] VPN concepts — site-to-site, remote-access

### Domain 6: Automation & Programmability (10%)
- [ ] SDN concepts — planes, northbound/southbound APIs
- [ ] DNA Center — intent-based, assurance
- [ ] REST APIs — methods, status codes, CRUD
- [ ] Data formats — JSON, XML, YAML
- [ ] Config management — Ansible (agentless), Puppet/Chef (agent-based)
- [ ] Basic Python — variables, loops, json module

---

## 5. The 20 Most-Tested Topics

Based on exam feedback and Cisco's blueprint emphasis:

| Rank | Topic | Domain | Why It's Critical |
|------|-------|--------|------------------|
| 1 | **Subnetting** | 1 | Multiple questions, every exam |
| 2 | **OSPF configuration & troubleshooting** | 3 | Highest weight domain |
| 3 | **VLAN & trunk configuration** | 2 | Core switching knowledge |
| 4 | **ACLs (extended)** | 5 | Common in simlet questions |
| 5 | **NAT/PAT** | 4 | Inside/outside local/global |
| 6 | **STP root bridge election** | 2 | Frequent drag-and-drop |
| 7 | **IPv6 address types** | 1 | GUA vs LLA vs ULA |
| 8 | **Administrative distance** | 3 | Route selection questions |
| 9 | **DHCP (DORA + relay)** | 4 | Config and troubleshooting |
| 10 | **Port security** | 5 | Violation modes |
| 11 | **show command interpretation** | All | Used in every simlet |
| 12 | **Wireless standards** | 1 | Frequencies + speeds |
| 13 | **EtherChannel** | 2 | LACP vs PAgP |
| 14 | **SSH config** | 5 | Secure remote access |
| 15 | **REST APIs & JSON** | 6 | HTTP methods + data formats |
| 16 | **Inter-VLAN routing** | 2 | Router-on-a-stick |
| 17 | **NTP & Syslog** | 4 | Severity levels, stratum |
| 18 | **Static & default routes** | 3 | Config and verification |
| 19 | **SDN / DNA Center** | 6 | Conceptual understanding |
| 20 | **TCP vs UDP** | 1 | Port numbers, differences |

---

## 6. Common Exam Traps & Tricks

### Trap 1: Wildcard Mask vs. Subnet Mask
- ACLs and OSPF use **wildcard masks** (inverse of subnet mask)
- DHCP pool uses **subnet mask** (`network 192.168.1.0 255.255.255.0`)
- Quick conversion: 255.255.255.0 ↔ 0.0.0.255 (subtract each octet from 255)

### Trap 2: "Which TWO" Questions
- If you only select one, you get **zero points**
- If you select one right + one wrong, you get **zero points**
- You MUST get all selections correct

### Trap 3: Interface Status
- `up/up` = working normally
- `up/down` = Layer 1 OK, Layer 2 problem (encapsulation, keepalive)
- `down/down` = cable issue, speed/duplex mismatch, or disconnected
- `administratively down/down` = someone typed `shutdown`

### Trap 4: OSPF Neighbor Requirements
All of these MUST match for OSPF adjacency:
1. Area ID
2. Hello/Dead timers
3. Subnet mask (on the shared link)
4. Authentication (if configured)
5. MTU (mismatched MTU prevents Full state)
6. Stub area flags

### Trap 5: NAT Terminology
- **Inside Local** = private IP of the host (what YOU configured)
- **Inside Global** = public IP representing that host (what the INTERNET sees)
- **Outside Local** = how you see the remote server (usually same as outside global)
- **Outside Global** = real IP of the remote server

### Trap 6: "Permit" vs "Deny" Order in ACLs
- ACLs are processed **top-down, first match wins**
- The implicit `deny any` at the end catches everything not explicitly permitted
- Order matters: put most specific rules first

### Trap 7: PortFast Placement
- **ONLY on access ports** connected to end devices (PCs, servers, printers)
- **NEVER on trunk ports** or ports connecting to other switches
- BPDU Guard should accompany PortFast as a safety net

---

## 7. Last-Night Review Sheet

**Print this or keep it open the night before your exam.**

### Numbers to Memorize

| Item | Value |
|------|-------|
| SSH port | TCP 22 |
| Telnet port | TCP 23 |
| HTTP port | TCP 80 |
| HTTPS port | TCP 443 |
| DNS port | UDP/TCP 53 |
| DHCP server port | UDP 67 |
| DHCP client port | UDP 68 |
| FTP data | TCP 20 |
| FTP control | TCP 21 |
| TFTP port | UDP 69 |
| SNMP port | UDP 161 |
| SNMP trap port | UDP 162 |
| Syslog port | UDP 514 |
| NTP port | UDP 123 |
| RADIUS auth | UDP 1812 |
| RADIUS acct | UDP 1813 |
| TACACS+ | TCP 49 |

### Quick Reference Formulas

| Formula | Equation |
|---------|----------|
| Usable hosts | 2^n - 2 (n = host bits) |
| Subnets created | 2^n (n = borrowed bits) |
| OSPF cost | Reference BW / Interface BW |
| Wildcard from subnet | 255.255.255.255 - subnet mask |

### Administrative Distance (Top 6)

| Protocol | AD |
|----------|-----|
| Connected | 0 |
| Static | 1 |
| EIGRP | 90 |
| OSPF | 110 |
| IS-IS | 115 |
| RIP | 120 |

### Syslog Levels

| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|
| Emergency | Alert | Critical | Error | Warning | Notification | Informational | Debug |

### OSI Model

| Layer | Name | Key Protocol/Device |
|-------|------|-------------------|
| 7 | Application | HTTP, DNS, DHCP, FTP |
| 6 | Presentation | SSL/TLS, JPEG, ASCII |
| 5 | Session | NetBIOS, RPC |
| 4 | Transport | TCP, UDP |
| 3 | Network | IP, ICMP, OSPF — Router |
| 2 | Data Link | Ethernet, 802.1Q — Switch |
| 1 | Physical | Cables, hubs, signals |

---

## 8. Exam Day Logistics

### If Taking at a Test Center
1. Arrive **30 minutes early**
2. Bring **two forms of ID** (one with photo, one with signature)
3. No electronics, notes, or watches in the testing room
4. You'll get a **whiteboard/marker** or scratch paper — use it for subnetting
5. You cannot go back to previous questions (in most Cisco exams)
6. Restroom breaks count against your time

### If Taking Online (OnVUE)
1. Quiet, private room — no one else can be present
2. Clean desk — nothing except your computer
3. Working webcam and microphone required
4. Stable internet connection
5. System check available at [pearsonvue.com](https://home.pearsonvue.com/cisco)
6. No whiteboard — use the built-in online notepad

### Mental Preparation
- **Sleep 7-8 hours** the night before — fatigue kills exam performance
- **Eat a good meal** before the exam
- **Don't cram** the morning of — trust your 12 weeks of preparation
- **Stay calm** — if you hit a hard question, flag it and move on
- **Remember:** You need ~83%, not 100%. You can miss ~20 questions and still pass.

---

## 9. Post-Exam: What's Next?

### If You Pass 🎉
- **Celebrate!** You've earned the CCNA certification
- Download your digital badge from Credly
- Update your LinkedIn profile
- Consider next steps:
  - **CCNP Enterprise** — next level (ENCOR 350-401 + concentration exam)
  - **CCNP Security** — if security interests you
  - **DevNet Associate** — if automation/programming interests you
  - **CompTIA Network+** — if you want a vendor-neutral complement
  - Apply for network engineer / network administrator roles

### If You Don't Pass (Yet)
- **Don't be discouraged** — many people don't pass on the first try
- Review your score report — it shows domain-level performance
- Focus on your weakest domains
- Wait at least **5 days** before retaking (Cisco policy)
- Come back to this study guide and revisit the weak areas
- You WILL pass — it's just a matter of more practice

---

## Quiz — 10-Question Final Confidence Check

*These are tricky — exam-level difficulty.*

**1.** A router has these routes:
- `10.0.0.0/8` via OSPF (AD 110)
- `10.0.0.0/8` via static (AD 1)
- `10.1.0.0/16` via OSPF (AD 110)

A packet arrives for 10.1.5.5. Which route is used and why?

<details><summary>Answer</summary>

**10.1.0.0/16 via OSPF**. Even though the static route has a lower AD, longest prefix match happens FIRST. 10.1.5.5 matches 10.1.0.0/16 (/16) more specifically than 10.0.0.0/8 (/8). AD is only compared when multiple routes have the **same prefix**.

</details>

**2.** You configure port security with `maximum 1` and `violation restrict` on Fa0/1. A second MAC appears. What happens?

<details><summary>Answer</summary>

The port remains up but **drops frames from the new MAC**, increments the violation counter, and generates a syslog message. The port does NOT shut down (that would be `shutdown` mode). `Restrict` = drop + log. `Protect` = drop only.

</details>

**3.** SW1 has priority 32768 and MAC 0000.0000.1111. SW2 has priority 32768 and MAC 0000.0000.0001. Which becomes the STP root bridge?

<details><summary>Answer</summary>

**SW2**. Both have the same priority (32768), so the tiebreaker is the **lowest MAC address**. 0000.0000.0001 < 0000.0000.1111.

</details>

**4.** What three conditions prevent OSPF from forming a neighbor adjacency? (Name three)

<details><summary>Answer</summary>

Any three of: (1) Area ID mismatch, (2) Hello/Dead timer mismatch, (3) Subnet mask mismatch on shared link, (4) Authentication mismatch, (5) MTU mismatch, (6) Stub area flag mismatch, (7) Duplicate Router IDs.

</details>

**5.** You type `access-list 10 permit 192.168.1.0 0.0.0.255` and apply it inbound on Gi0/0. Can hosts on 192.168.2.0/24 pass through?

<details><summary>Answer</summary>

**No.** Standard ACL 10 permits only 192.168.1.0/24. The implicit `deny any` at the end blocks everything else, including 192.168.2.0/24.

</details>

**6.** An OSPF router shows `State: EXSTART` with its neighbor. What does this mean?

<details><summary>Answer</summary>

The routers are **negotiating the master/slave relationship** for database exchange. This is the state where they agree on initial sequence numbers. If it's stuck in EXSTART, it's usually an **MTU mismatch**.

</details>

**7.** You see `169.254.x.x` on a PC. What happened?

<details><summary>Answer</summary>

**APIPA (Automatic Private IP Addressing)**. The PC failed to get an IP from a DHCP server and assigned itself a link-local address from 169.254.0.0/16. Check: DHCP server status, IP helper-address, DHCP snooping trusted ports, network connectivity.

</details>

**8.** In `show ip nat translations`, what does "Inside Global" represent?

<details><summary>Answer</summary>

The **public IP address** that represents the internal host to the outside world. It's the address that appears in packets leaving the router's outside interface.

</details>

**9.** You need to allow ONLY SSH access to a router's VTY lines from the 10.0.0.0/8 network. Write the configuration.

<details><summary>Answer</summary>

```
access-list 5 permit 10.0.0.0 0.255.255.255
line vty 0 15
 access-class 5 in
 transport input ssh
 login local
```

The `access-class` command applies an ACL to VTY lines (not `ip access-group`, which is for interfaces).

</details>

**10.** A network engineer sees this OSPF output:
```
O*E2 0.0.0.0/0 [110/1] via 10.0.0.1, Gi0/0
```
What does `E2` mean?

<details><summary>Answer</summary>

**External Type 2** — this is a route redistributed INTO OSPF from an external source (likely a static default route via `default-information originate`). E2 means the **metric does not increase** as the route is propagated through OSPF (unlike E1 where metric accumulates). The [110/1] shows AD 110 (OSPF) and metric 1.

</details>

---

**You've completed the entire 12-week CCNA 200-301 study plan. Go pass that exam! 🎯**

**→ Continue to [Exercises](exercises.md) for final timed practice.**
