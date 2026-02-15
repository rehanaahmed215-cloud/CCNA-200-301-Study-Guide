# CCNA 200-301 — 12-Week Learning Plan

## Overview

**Exam:** Cisco Certified Network Associate (200-301)
**Timeline:** 12 weeks (Feb 15 – May 15, 2026)
**Structure:** Each week covers a domain area with three components:
1. **Concept Introduction** — theory and key terms
2. **Practical Exercises** — hands-on labs (use Cisco Packet Tracer or GNS3)
3. **Challenges** — independent problems to solidify understanding

---

## Week 1 — Network Fundamentals: OSI & TCP/IP Models

### Concept Introduction
- OSI 7-layer model: Physical, Data Link, Network, Transport, Session, Presentation, Application
- TCP/IP 4-layer model and how it maps to OSI
- Encapsulation and de-encapsulation (PDUs: data → segment → packet → frame → bits)
- Common protocols per layer (HTTP, TCP, UDP, IP, Ethernet, ARP)

### Practical Exercises
1. Open Packet Tracer → create 2 PCs connected via a switch
2. Assign IPs manually (e.g., 192.168.1.10/24 and 192.168.1.20/24)
3. Ping between hosts and use **Simulation Mode** to watch each PDU traverse layers
4. Click on a packet mid-transit and identify encapsulation at each layer
5. Use `ipconfig`, `arp -a` on the PCs to observe L2/L3 addresses

### Challenges
- [ ] Draw the OSI model from memory and label each layer's PDU, key protocols, and devices
- [ ] Capture a ping in Simulation Mode and write a short explanation of what happens at every layer
- [ ] Research: What happens when a frame arrives at a switch vs. a router? Write a comparison

---

## Week 2 — Network Fundamentals: IPv4 Addressing & Subnetting

### Concept Introduction
- Binary ↔ decimal conversion
- IPv4 address classes (A, B, C), private ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
- Subnet masks, CIDR notation
- Subnetting: calculating network address, broadcast, usable hosts, valid subnets
- VLSM (Variable Length Subnet Masking)

### Practical Exercises
1. Subnet 192.168.10.0/24 into 4 equal subnets — calculate by hand then verify with an online calculator
2. In Packet Tracer: build a topology with 4 LANs, assign each one of your subnets
3. Configure a router with sub-interfaces (router-on-a-stick is fine for now) to route between subnets
4. Verify with `show ip interface brief` and `ping` across subnets

### Challenges
- [ ] Given 10.0.0.0/8, design a VLSM scheme for: HQ (500 hosts), Branch A (120 hosts), Branch B (60 hosts), WAN link (2 hosts)
- [ ] Complete 20 random subnetting problems at [subnettingpractice.com](https://subnettingpractice.com) — aim for < 30 sec each
- [ ] Explain why 192.168.1.128/25 and 192.168.1.0/25 are different subnets in your own words

---

## Week 3 — Network Fundamentals: IPv6 & Dual Stack

### Concept Introduction
- Why IPv6: address exhaustion, simplified headers
- IPv6 address format, shortening rules (:: and leading zero suppression)
- Address types: Global Unicast (GUA), Link-Local (FE80::/10), Multicast, Anycast
- SLAAC, DHCPv6 (stateless vs. stateful)
- Dual-stack, tunneling, NAT64 (high-level)

### Practical Exercises
1. In Packet Tracer: configure IPv6 on two routers connected via serial link
2. Assign GUA addresses and verify with `show ipv6 interface brief`
3. Enable `ipv6 unicast-routing` and configure static IPv6 routes
4. Verify end-to-end connectivity with `ping` and `traceroute`
5. Enable SLAAC on a LAN and observe PCs auto-configuring addresses

### Challenges
- [ ] Convert these to full form: `2001:db8::1`, `fe80::1`. Then shorten: `2001:0db8:0000:0000:0000:0000:0000:0001`
- [ ] Build a dual-stack topology: 3 routers, each LAN has both IPv4 and IPv6. Ensure full reachability
- [ ] Research and write a one-page summary: When would you use SLAAC vs. DHCPv6?

---

## Week 4 — Network Access: Ethernet, Switching & VLANs

### Concept Introduction
- Ethernet standards (10BASE-T, 100BASE-TX, 1000BASE-T, fiber types)
- MAC addresses, frame format
- Switch operation: MAC address table, flooding, forwarding, filtering
- VLANs: purpose, 802.1Q trunking, native VLAN
- Access ports vs. trunk ports

### Practical Exercises
1. Build a Packet Tracer lab: 1 switch, 4 PCs
2. Create VLAN 10 (Sales) and VLAN 20 (Engineering) — assign ports accordingly
3. Verify with `show vlan brief` and `show interfaces trunk`
4. Add a second switch, configure a trunk link between them
5. Confirm PCs in the same VLAN across switches can ping; different VLANs cannot

### Challenges
- [ ] Add a third switch in a triangle topology — what happens? (hint: broadcast storm → next week's topic)
- [ ] Configure the native VLAN to something other than VLAN 1 on all trunk links. Verify it works
- [ ] Design a VLAN scheme for a small company: HR (15 users), IT (10 users), Guest WiFi (50 users), Management. Document your VLAN IDs, subnets, and port assignments

---

## Week 5 — Network Access: STP, EtherChannel & Inter-VLAN Routing

### Concept Introduction
- Spanning Tree Protocol (802.1D): root bridge election, port roles (root, designated, blocked)
- STP convergence, PortFast, BPDU Guard
- Rapid STP (802.1w)
- EtherChannel: LACP, PAgP, static
- Inter-VLAN routing: router-on-a-stick (802.1Q sub-interfaces), Layer 3 switch (SVI)

### Practical Exercises
1. Build a 3-switch triangle topology with redundant links
2. Identify the root bridge using `show spanning-tree`
3. Modify bridge priority to force a specific switch as root
4. Configure LACP EtherChannel (2-link bundle) between two switches — verify with `show etherchannel summary`
5. Set up router-on-a-stick: configure sub-interfaces, default gateways, ping across VLANs
6. Convert to L3 switching: create SVIs, enable `ip routing`, remove the router

### Challenges
- [ ] Intentionally misconfigure an EtherChannel (mismatched modes). Diagnose and fix using `show` commands
- [ ] Draw the STP topology for your lab — label all port roles and states
- [ ] Lab: configure PortFast and BPDU Guard on all access ports. Test by connecting a rogue switch — what happens?

---

## Week 6 — IP Connectivity: Static & Dynamic Routing (OSPF)

### Concept Introduction
- Routing concepts: routing table, administrative distance, longest prefix match
- Static routes: standard, default, floating static
- Dynamic routing overview: distance-vector vs. link-state
- OSPF single-area: Hello, LSA, SPF algorithm, DR/BDR election, cost, areas
- OSPF configuration: `router ospf`, `network` command, passive interfaces, router-id

### Practical Exercises
1. Build a 3-router topology with 3 LANs
2. Configure static routes first — verify full reachability
3. Remove static routes. Configure single-area OSPF (area 0) on all routers
4. Verify with: `show ip ospf neighbor`, `show ip route ospf`, `show ip ospf interface`
5. Modify OSPF cost on an interface and observe the routing table change
6. Configure a default route on one router and redistribute into OSPF

### Challenges
- [ ] Add a 4th router. Create a topology where there are two equal-cost paths — verify OSPF load balancing
- [ ] Configure passive interfaces on all LAN-facing interfaces. Explain why this is best practice
- [ ] Simulate a link failure (shut down an interface). Document convergence: how long does OSPF take to re-route? What do the `show` commands reveal during convergence?

---

## Week 7 — IP Services: DHCP, DNS, NAT/PAT, NTP, SNMP

### Concept Introduction
- DHCP: DORA process, pools, excluded addresses, relay agent (`ip helper-address`)
- DNS: A records, hierarchy, how devices resolve names
- NAT: Static NAT, Dynamic NAT, PAT (overload) — inside local/global, outside local/global
- NTP: time synchronization, stratum levels
- SNMP: versions (v2c, v3), agents, managers, MIBs, traps vs. polling
- Syslog: severity levels (0-7), logging configuration

### Practical Exercises
1. Configure a router as DHCP server: pool, default gateway, DNS, excluded range
2. Verify clients receive addresses; check with `show ip dhcp binding`
3. Configure PAT on an edge router: define inside/outside interfaces, ACL for NAT
4. Verify with `show ip nat translations`
5. Configure NTP: set one router as NTP master, others as clients — verify with `show ntp status`
6. Configure syslog: send logs to a syslog server in Packet Tracer

### Challenges
- [ ] Set up DHCP relay: DHCP server on one subnet, clients on another, relay in between
- [ ] Configure static NAT to expose an internal web server (port 80) to the outside
- [ ] Build a complete "small office" topology: DHCP, DNS, PAT, NTP, Syslog all working together. Document your configuration

---

## Week 8 — Security Fundamentals

### Concept Introduction
- CIA triad (Confidentiality, Integrity, Availability)
- Common threats: phishing, DDoS, man-in-the-middle, spoofing
- AAA framework (Authentication, Authorization, Accounting)
- Port security: sticky MAC, violation modes (shutdown, restrict, protect)
- DHCP snooping, Dynamic ARP Inspection (DAI)
- ACLs: standard (1-99), extended (100-199), named — permit/deny, wildcard masks, implicit deny
- SSH vs. Telnet, password encryption, `login local`, `enable secret`

### Practical Exercises
1. Secure a switch: disable unused ports, enable port security (max 2 MACs, sticky, violation shutdown)
2. Verify with `show port-security interface`
3. Configure standard ACL to deny a specific host from reaching a server
4. Configure extended ACL to allow HTTP but deny Telnet from a subnet
5. Apply ACLs inbound/outbound — test and verify
6. Secure device access: set hostname, banner, enable secret, console/VTY passwords, SSH (RSA keys, `transport input ssh`)

### Challenges
- [ ] Given a scenario: "Allow Sales VLAN to access the file server on port 445, deny everything else from Sales to the Server VLAN, permit all other traffic" — write and apply the ACL
- [ ] Enable DHCP snooping and DAI on your switch topology. Attempt a rogue DHCP server attack — does the switch block it?
- [ ] Perform a security audit of your lab: check for plaintext passwords, open ports, missing ACLs. Create a remediation checklist

---

## Week 9 — Wireless Networking (WLAN)

### Concept Introduction
- Wireless standards: 802.11a/b/g/n/ac/ax (Wi-Fi 6), frequency bands (2.4 GHz, 5 GHz, 6 GHz)
- Wireless architecture: autonomous APs, controller-based (WLC), cloud-managed
- SSID, BSS, ESS, roaming
- Wireless security: WPA2-Personal (PSK), WPA2-Enterprise (802.1X/RADIUS), WPA3
- RF concepts: channels, interference, CSMA/CA

### Practical Exercises
1. In Packet Tracer: place a Wireless LAN Controller (WLC) and one Lightweight AP
2. Connect to WLC GUI: configure a WLAN (SSID, WPA2-PSK)
3. Connect wireless clients and verify connectivity
4. Change the channel on the AP and observe client reassociation
5. Configure a Guest WLAN on a separate VLAN with its own DHCP scope

### Challenges
- [ ] Design a wireless plan for a 2-floor office (8 rooms per floor). Decide: how many APs, which channels, and draw a coverage map
- [ ] Research WPA2-Enterprise: draw a diagram showing the authentication flow between client, AP, WLC, and RADIUS server
- [ ] Compare autonomous vs. WLC-based architecture — when would you use each? Write a decision matrix

---

## Week 10 — Network Automation & Programmability

### Concept Introduction
- Why automation: consistency, speed, scalability
- REST APIs: HTTP methods (GET, POST, PUT, DELETE), JSON format, status codes
- Configuration management tools (Ansible, Puppet, Chef — concepts only)
- Cisco DNA Center and SD-WAN (concepts only)
- Data formats: JSON, XML, YAML — reading and interpreting
- Basic Python for network automation (not deeply tested but good to understand)

### Practical Exercises
1. Use Postman or `curl` to make REST API calls to a mock API (e.g., Cisco DevNet Sandbox)
2. Practice reading JSON output: parse interface status, VLAN data
3. Write a simple Python script that uses the `requests` library to GET device info from an API
4. Explore Cisco DevNet: sign up and try the "Networking Basics" learning lab
5. Read a sample Ansible playbook that configures a VLAN — understand the YAML structure

### Challenges
- [ ] Given a JSON blob of a routing table, manually extract: all routes to 10.0.0.0/8, the next-hop for the default route
- [ ] Write a Python script that reads a CSV of hostnames/IPs and pings each one, reporting up/down status
- [ ] Compare traditional CLI-based management vs. controller-based (DNA Center) for a 200-switch network. Write pros/cons

---

## Week 11 — Review, Weak-Area Drills & Practice Exams

### Concept Introduction (Review Focus)
- Revisit the official exam topics: [Cisco 200-301 Exam Topics](https://learningnetwork.cisco.com/s/ccna-exam-topics)
- Identify your 3 weakest domains from practice tests
- Re-read notes on: subnetting, OSPF, ACLs, wireless (commonly weak areas)

### Practical Exercises
1. Take a full-length practice exam (Boson ExSim, Pearson, or free resources)
2. For every wrong answer, build a Packet Tracer lab that demonstrates the concept
3. Speed subnetting drill: 50 problems in 25 minutes
4. Redo your most complex lab from weeks 4-8 entirely from memory
5. Practice `show` command identification: given output, identify the issue

### Challenges
- [ ] Without notes, configure from scratch: a multi-VLAN, OSPF-routed, NAT-enabled, DHCP-serving, ACL-secured network. Time yourself
- [ ] Write a one-page "cheat sheet" of the top 30 IOS commands you must know
- [ ] Take another practice exam. Target score: 85%+

---

## Week 12 — Final Review & Exam Readiness

### Concept Introduction (Exam Strategy)
- Exam format: 100-120 questions, 120 minutes, ~825/1000 to pass
- Question types: multiple choice, drag-and-drop, simlet (mini-lab)
- Time management: ~1 min/question, flag and move on
- Read questions carefully — look for keywords: "most likely", "best", "which two"

### Practical Exercises
1. Take 2 more full-length practice exams under timed conditions
2. Review all flagged/wrong questions — make flashcards for missed concepts
3. Do one final comprehensive lab: full enterprise topology with all technologies
4. Practice drag-and-drop style questions (layer ordering, protocol matching)

### Challenges
- [ ] Teach a concept to someone else (or explain it out loud). Pick: OSPF, STP, or NAT
- [ ] Without any reference, whiteboard the entire VLSM design for a 6-site network
- [ ] Night before: review your cheat sheet, get good sleep, trust your preparation

---

## Recommended Resources

| Resource | Type | Cost |
|---|---|---|
| **Cisco Packet Tracer** | Lab simulator | Free |
| **Neil Anderson — CCNA Course** (Udemy) | Video course | ~$15 on sale |
| **Wendell Odom — OCG Vol 1 & 2** | Official textbook | ~$50-60 |
| **David Bombal — YouTube / Udemy** | Videos + labs | Free / $15 |
| **Boson ExSim-Max** | Practice exams | ~$99 |
| **Cisco DevNet Sandbox** | API / automation labs | Free |
| **Subnetting Practice** | Drill site | Free |
| **Anki / Quizlet** | Flashcards | Free |

## Weekly Time Commitment

| Activity | Hours/Week |
|---|---|
| Video / Reading | 4-5 hrs |
| Hands-on Labs | 4-5 hrs |
| Challenges & Review | 2-3 hrs |
| **Total** | **~10-13 hrs** |

---

> This plan covers all six CCNA 200-301 exam domains: Network Fundamentals (20%), Network Access (20%), IP Connectivity (25%), IP Services (10%), Security Fundamentals (15%), and Automation/Programmability (10%). Adjust pacing if a topic needs more time — the Week 11 buffer gives you flexibility. Good luck!
