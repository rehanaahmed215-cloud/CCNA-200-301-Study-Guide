# Week 12 — Exercises: Final Review & Exam Readiness

## Table of Contents
- [Overview](#overview)
- [Exercise 1: Timed Practice Exam — 60 Questions (75 Minutes)](#exercise-1-timed-practice-exam--60-questions-75-minutes)
- [Exercise 2: Rapid-Fire Flashcard Drill](#exercise-2-rapid-fire-flashcard-drill)
- [Exercise 3: Comprehensive Enterprise Lab — Build & Verify](#exercise-3-comprehensive-enterprise-lab--build--verify)
- [Exercise 4: Drag-and-Drop Practice Sets](#exercise-4-drag-and-drop-practice-sets)
- [Exercise 5: Command Completion from Memory](#exercise-5-command-completion-from-memory)

---

## Overview

Final week exercises are **exam-speed**, **exam-format**, and **exam-difficulty**.

| Exercise | Format | Time Limit |
|----------|--------|-----------|
| 1. Practice exam | 60 multiple-choice questions | 75 min |
| 2. Flashcard drill | Quick recall (write answer → flip) | 20 min |
| 3. Enterprise lab | Full build + verification | 60 min |
| 4. Drag-and-drop | Matching exercises | 15 min |
| 5. Command completion | Fill-in-the-blank configs | 20 min |

---

## Exercise 1: Timed Practice Exam — 60 Questions (75 Minutes)

**Instructions:** This simulates exam pacing. 75 seconds per question average. NO references. Set a timer and go.

---

**1.** What is the purpose of ARP?
- A) Resolve hostnames to IPs
- B) Resolve IPs to MAC addresses
- C) Assign IP addresses dynamically
- D) Encrypt Layer 2 frames

**2.** Which STP port state learns MAC addresses but does not forward frames?
- A) Blocking
- B) Listening
- C) Learning
- D) Forwarding

**3.** 192.168.5.130/25 — What is the network address?
- A) 192.168.5.0
- B) 192.168.5.64
- C) 192.168.5.128
- D) 192.168.5.192

**4.** Which command displays trunk interfaces on a switch?
- A) `show vlan brief`
- B) `show interfaces trunk`
- C) `show trunk status`
- D) `show spanning-tree`

**5.** What does the `passive-interface` command do in OSPF?
- A) Prevents OSPF from running on the interface
- B) Stops OSPF hellos but still advertises the network
- C) Puts the interface in standby mode
- D) Reduces OSPF cost on the interface

**6.** What is the IPv6 link-local prefix?
- A) 2001::/16
- B) FC00::/7
- C) FE80::/10
- D) FF00::/8

**7.** In NAT, what is the "inside global" address?
- A) Private IP of the host
- B) Public IP assigned to the inside host
- C) IP of the remote server
- D) Default gateway of the LAN

**8.** What protocol does DAI protect against?
- A) DHCP starvation
- B) ARP spoofing
- C) IP spoofing
- D) DNS hijacking

**9.** What LACP mode actively initiates negotiation?
- A) On
- B) Desirable
- C) Active
- D) Auto

**10.** Which layer of the OSI model segments data into segments?
- A) Layer 2
- B) Layer 3
- C) Layer 4
- D) Layer 5

**11.** What is the broadcast address of 172.16.32.0/20?
- A) 172.16.47.255
- B) 172.16.39.255
- C) 172.16.63.255
- D) 172.16.48.255

**12.** Which SNMP version provides encryption?
- A) v1
- B) v2c
- C) v3
- D) All of the above

**13.** What does `switchport port-security violation protect` do?
- A) Shuts down the port
- B) Drops offending frames and logs
- C) Drops offending frames silently
- D) Allows the frame but logs it

**14.** In OSPF, what value is used to elect the DR on a broadcast network?
- A) Lowest cost
- B) Highest priority, then highest Router ID
- C) Lowest Router ID
- D) Highest MAC address

**15.** What type of ACL should be placed closest to the destination?
- A) Extended
- B) Standard
- C) Named only
- D) Reflexive

**16.** What command generates RSA keys for SSH?
- A) `ssh key generate`
- B) `ip ssh keygen rsa`
- C) `crypto key generate rsa`
- D) `generate rsa keys`

**17.** Which HTTP method retrieves data without modifying it?
- A) POST
- B) GET
- C) PUT
- D) DELETE

**18.** What happens to untagged frames on an 802.1Q trunk?
- A) Dropped
- B) Assigned to native VLAN
- C) Forwarded to all VLANs
- D) Sent to the root bridge

**19.** 10.0.0.0/30 — How many usable host addresses?
- A) 4
- B) 2
- C) 6
- D) 0

**20.** What Syslog severity is level 4?
- A) Error
- B) Warning
- C) Notification
- D) Informational

**21.** Which config management tool is agentless and uses SSH?
- A) Puppet
- B) Chef
- C) Ansible
- D) SaltStack

**22.** What is the default OSPF hello interval on a point-to-point link?
- A) 5 seconds
- B) 10 seconds
- C) 30 seconds
- D) 40 seconds

**23.** What command shows the MAC address table on a switch?
- A) `show arp`
- B) `show mac address-table`
- C) `show interface mac`
- D) `show l2 table`

**24.** What is the purpose of 802.1Q?
- A) Wireless encryption
- B) VLAN trunking (frame tagging)
- C) Spanning tree
- D) Link aggregation

**25.** A static route with AD 200 is configured alongside an OSPF route (AD 110) for the same prefix. Which is used?
- A) Static (lower AD number)
- B) OSPF (lower AD number)
- C) Both (load balancing)
- D) Neither (conflict error)

**26.** What is the subnet mask for /27?
- A) 255.255.255.192
- B) 255.255.255.224
- C) 255.255.255.240
- D) 255.255.255.128

**27.** What does DHCP "DORA" stand for?
- A) Discover, Offer, Reply, Accept
- B) Discover, Offer, Request, Acknowledge
- C) Detect, Offer, Request, Assign
- D) Discover, Open, Request, Authenticate

**28.** In SDN, what interface connects the controller to applications?
- A) Southbound Interface (SBI)
- B) Northbound Interface (NBI)
- C) East-West Interface
- D) Management Interface

**29.** What does `ip helper-address 10.0.0.5` do?
- A) Assigns 10.0.0.5 as the interface IP
- B) Forwards DHCP broadcasts to 10.0.0.5
- C) Sets the default gateway to 10.0.0.5
- D) Configures NTP server 10.0.0.5

**30.** Which port does TACACS+ use?
- A) UDP 1812
- B) TCP 49
- C) UDP 161
- D) TCP 389

**31.** How does a switch learn MAC addresses?
- A) From destination MAC of incoming frames
- B) From source MAC of incoming frames
- C) From ARP requests only
- D) From DHCP messages

**32.** What is the usable host range for 192.168.10.64/26?
- A) .64 to .127
- B) .65 to .126
- C) .64 to .126
- D) .65 to .127

**33.** What does BPDU Guard do when it detects a BPDU?
- A) Logs a warning
- B) Err-disables the port
- C) Forwards the BPDU normally
- D) Increases STP priority

**34.** What routing protocol does CCNA 200-301 focus on?
- A) RIP
- B) EIGRP
- C) OSPF
- D) BGP

**35.** What is the difference between cut-through and store-and-forward switching?
- A) Cut-through checks FCS; store-and-forward does not
- B) Store-and-forward checks the full frame for errors; cut-through starts forwarding after reading the destination MAC
- C) They are identical
- D) Cut-through is Layer 3; store-and-forward is Layer 2

**36.** What NTP stratum indicates an unreachable/invalid clock?
- A) 0
- B) 1
- C) 15
- D) 16

**37.** Which IPv6 address type is equivalent to a private IPv4 address?
- A) Global Unicast (GUA)
- B) Unique Local (ULA)
- C) Link-Local
- D) Multicast

**38.** What command applies an ACL to a VTY line?
- A) `ip access-group 10 in`
- B) `access-class 10 in`
- C) `ip access-list 10 in`
- D) `vty access 10`

**39.** In OSPF, what is the reference bandwidth by default?
- A) 10 Mbps
- B) 100 Mbps
- C) 1000 Mbps
- D) 10000 Mbps

**40.** What does a `/31` subnet provide?
- A) 2 usable hosts
- B) 0 usable hosts
- C) Used for point-to-point links (2 addresses, no broadcast)
- D) 1 usable host

**41.** What is the function of the data plane in a network device?
- A) Making routing decisions
- B) Forwarding packets based on the forwarding table
- C) Managing the device via CLI/GUI
- D) Running routing protocols

**42.** A packet destined for 192.168.5.100 arrives at a router with these routes:
- 192.168.5.0/24 via OSPF
- 192.168.0.0/16 via static
- 0.0.0.0/0 via static

Which route is selected?
- A) 192.168.0.0/16 (static, AD 1)
- B) 192.168.5.0/24 (OSPF, longest match)
- C) 0.0.0.0/0 (default route)
- D) Packet is dropped

**43.** What are the three port-security violation modes?
- A) Protect, Restrict, Shutdown
- B) Allow, Deny, Reset
- C) Permit, Block, Shutdown
- D) Open, Close, Error

**44.** What is the wildcard mask for 172.16.0.0/12?
- A) 0.0.255.255
- B) 0.15.255.255
- C) 0.31.255.255
- D) 0.255.255.255

**45.** What command saves the running configuration?
- A) `save running-config`
- B) `write memory`
- C) `backup config`
- D) `store config nvram`

**46.** What does `default-information originate` do in OSPF?
- A) Creates a default static route
- B) Advertises a default route to OSPF neighbors
- C) Sets the default OSPF cost
- D) Configures the default timer

**47.** Which WLAN standard introduced MIMO and operated on both 2.4 and 5 GHz?
- A) 802.11a
- B) 802.11g
- C) 802.11n (Wi-Fi 4)
- D) 802.11ac (Wi-Fi 5)

**48.** What does a "floating static route" achieve?
- A) Load balancing
- B) Backup route with higher AD than the primary
- C) Route that adapts to bandwidth changes
- D) Default gateway redundancy

**49.** In JSON, how do you represent an array?
- A) `{}`
- B) `[]`
- C) `()`
- D) `<>`

**50.** What is the maximum MTU of a standard Ethernet frame (without jumbo frames)?
- A) 1000 bytes
- B) 1500 bytes
- C) 9000 bytes
- D) 1518 bytes

**51.** What does NDP replace in IPv6 (compared to IPv4)?
- A) DNS
- B) DHCP
- C) ARP
- D) NAT

**52.** Which two fields make up the OSPF Bridge ID used to elect the root bridge? (Wait — this is STP!) What is the STP Bridge ID composed of?
- A) IP address + MAC address
- B) Priority + MAC address
- C) Cost + MAC address
- D) Timer + Priority

**53.** What's the result of `show ip interface brief` showing `administratively down / down`?
- A) Cable unplugged
- B) The `shutdown` command was applied
- C) Speed/duplex mismatch
- D) IP address conflict

**54.** What type of DNS record maps a hostname to an IPv6 address?
- A) A
- B) AAAA
- C) CNAME
- D) MX

**55.** In EtherChannel, if one member link fails, what happens?
- A) The entire channel goes down
- B) Traffic redistributes across remaining links
- C) STP reconverges
- D) The channel enters blocking state

**56.** What protocol number does OSPF use (in the IP header)?
- A) 6 (TCP)
- B) 17 (UDP)
- C) 89
- D) 47 (GRE)

**57.** What is the default STP priority value?
- A) 4096
- B) 8192
- C) 32768
- D) 65535

**58.** A router has `ip nat inside source list 1 interface Gi0/0 overload`. What does "overload" mean?
- A) The interface is overloaded with traffic
- B) PAT — multiple inside IPs share one outside IP using port numbers
- C) The NAT table is full
- D) Dynamic NAT with a pool

**59.** Which command displays OSPF-enabled interfaces and their areas?
- A) `show ip ospf`
- B) `show ip ospf interface brief`
- C) `show ip route ospf`
- D) `show ip protocols`

**60.** What is the purpose of QoS marking (e.g., DSCP)?
- A) Encrypting traffic
- B) Classifying packets for priority treatment in queues
- C) Changing the destination of packets
- D) Compressing packet headers

---

<details>
<summary><strong>Complete Answer Key</strong></summary>

| # | Answer | Brief Explanation |
|---|--------|-------------------|
| 1 | **B** | ARP maps IP → MAC |
| 2 | **C** | Learning state: learns MACs, doesn't forward |
| 3 | **C** | /25 splits at .128; 130 ≥ 128, so network = .128 |
| 4 | **B** | `show interfaces trunk` |
| 5 | **B** | Stops hellos, still advertises network in OSPF |
| 6 | **C** | FE80::/10 = link-local |
| 7 | **B** | Public IP representing the inside host |
| 8 | **B** | DAI prevents ARP spoofing using DHCP snooping table |
| 9 | **C** | LACP active mode initiates negotiation |
| 10 | **C** | Transport Layer (Layer 4) creates segments |
| 11 | **A** | /20 block size = 16 in 3rd octet. 32 + 16 - 1 = 47.255 |
| 12 | **C** | SNMPv3 provides authentication + encryption |
| 13 | **C** | Protect = silently drops, no log, no shutdown |
| 14 | **B** | Highest priority (default 1), then highest Router ID |
| 15 | **B** | Standard ACLs near destination |
| 16 | **C** | `crypto key generate rsa` |
| 17 | **B** | GET = read only |
| 18 | **B** | Untagged → native VLAN |
| 19 | **B** | /30 = 2^2 - 2 = 2 usable hosts |
| 20 | **B** | Level 4 = Warning |
| 21 | **C** | Ansible is agentless, uses SSH |
| 22 | **B** | 10 seconds on all network types except NBMA (30s) |
| 23 | **B** | `show mac address-table` |
| 24 | **B** | 802.1Q = VLAN trunking standard |
| 25 | **B** | OSPF AD 110 < Static AD 200, so OSPF wins |
| 26 | **B** | /27 = 255.255.255.224 |
| 27 | **B** | Discover, Offer, Request, Acknowledge |
| 28 | **B** | NBI connects controller to applications |
| 29 | **B** | Relays DHCP broadcasts as unicast to server |
| 30 | **B** | TACACS+ = TCP 49 |
| 31 | **B** | Source MAC of incoming frames |
| 32 | **B** | .65 (first usable) to .126 (last usable) |
| 33 | **B** | BPDU Guard err-disables the port |
| 34 | **C** | OSPF is the focus of CCNA 200-301 |
| 35 | **B** | Store-and-forward waits for full frame + FCS check |
| 36 | **D** | Stratum 16 = unsynchronized/invalid |
| 37 | **B** | ULA (FC00::/7) ≈ private IPv4 |
| 38 | **B** | `access-class` for VTY lines |
| 39 | **B** | Default reference BW = 100 Mbps |
| 40 | **C** | /31 used for point-to-point (RFC 3021) |
| 41 | **B** | Data plane forwards packets |
| 42 | **B** | Longest prefix match: /24 beats /16 and /0 |
| 43 | **A** | Protect, Restrict, Shutdown |
| 44 | **B** | /12 mask = 255.240.0.0 → wildcard = 0.15.255.255 |
| 45 | **B** | `write memory` (or `copy run start`) |
| 46 | **B** | Redistributes default route into OSPF |
| 47 | **C** | 802.11n introduced MIMO, dual-band |
| 48 | **B** | Higher AD backup route |
| 49 | **B** | JSON arrays use `[]` |
| 50 | **B** | 1500 bytes payload (1518 with header) |
| 51 | **C** | NDP replaces ARP in IPv6 |
| 52 | **B** | Priority (default 32768) + MAC address |
| 53 | **B** | `administratively down` = `shutdown` command |
| 54 | **B** | AAAA record = IPv6 |
| 55 | **B** | Remaining links carry the traffic |
| 56 | **C** | OSPF = IP protocol 89 |
| 57 | **C** | Default STP priority = 32768 |
| 58 | **B** | Overload = PAT (many-to-one with ports) |
| 59 | **B** | `show ip ospf interface brief` shows interfaces + areas |
| 60 | **B** | DSCP marks packets for priority queuing |

### Scoring
| Score | Assessment |
|-------|-----------|
| 54-60 | **Ready! Schedule the exam.** |
| 45-53 | Almost there — review missed topics one more time |
| 36-44 | Needs more practice — delay exam by a few days |
| Below 36 | Revisit weak domains — consider 1-2 more weeks |

</details>

---

## Exercise 2: Rapid-Fire Flashcard Drill

**Instructions:** Cover the right column. Read the left column. Say your answer aloud, then uncover to check. Target: <5 seconds per card.

| Question | Answer |
|----------|--------|
| SSH port | TCP 22 |
| OSPF AD | 110 |
| Static AD | 1 |
| Connected AD | 0 |
| DHCP server port | UDP 67 |
| DHCP client port | UDP 68 |
| HTTP port | TCP 80 |
| HTTPS port | TCP 443 |
| DNS port | UDP/TCP 53 |
| TACACS+ port | TCP 49 |
| RADIUS auth port | UDP 1812 |
| NTP port | UDP 123 |
| Syslog port | UDP 514 |
| SNMP port | UDP 161 |
| FTP control port | TCP 21 |
| FTP data port | TCP 20 |
| TFTP port | UDP 69 |
| OSPF protocol # | 89 |
| Default STP priority | 32768 |
| STP increment | 4096 |
| Syslog Emergency level | 0 |
| Syslog Debug level | 7 |
| NTP stratum (unhealthy) | 16 |
| OSPF default hello (broadcast) | 10 sec |
| OSPF dead timer (4× hello) | 40 sec |
| /24 usable hosts | 254 |
| /25 usable hosts | 126 |
| /26 usable hosts | 62 |
| /27 usable hosts | 30 |
| /28 usable hosts | 14 |
| /29 usable hosts | 6 |
| /30 usable hosts | 2 |
| Wildcard for /24 | 0.0.0.255 |
| Wildcard for /16 | 0.0.255.255 |
| OSPF cost formula | Ref BW / Int BW |
| Default reference BW | 100 Mbps |
| IPv6 link-local prefix | FE80::/10 |
| IPv6 GUA prefix | 2000::/3 |
| IPv6 ULA prefix | FC00::/7 |
| PAT keyword | overload |

---

## Exercise 3: Comprehensive Enterprise Lab — Build & Verify

**Goal:** Build this network from scratch in 60 minutes. Use Packet Tracer or Containerlab.

### Network Diagram
```
                    [ISP Cloud]
                        |
                   [R1-EDGE]
                   /         \
             [R2-HQ]       [R3-BRANCH]
            /       \           |
       [SW1]       [SW2]     [SW3]
      VLAN 10     VLAN 20   VLAN 10
      PC1, PC2    PC3, PC4  PC5, PC6
```

### Configuration Checklist

- [ ] **IP addressing:** All interfaces configured with correct IPs
- [ ] **VLANs:** VLAN 10 (Engineering), VLAN 20 (Sales) on HQ switches
- [ ] **Trunks:** SW1-R2, SW2-R2 configured as 802.1Q trunks
- [ ] **Inter-VLAN:** Router-on-a-stick on R2 (subinterfaces)
- [ ] **OSPF:** Area 0 on R1, R2, R3 (all WAN + LAN networks)
- [ ] **Passive interfaces:** LAN-facing interfaces on all routers
- [ ] **Default route:** R1 → ISP, redistributed into OSPF
- [ ] **NAT/PAT:** On R1 for all internal 10.x.x.x traffic
- [ ] **DHCP:** R2 serves VLAN 10 and VLAN 20 pools
- [ ] **ACL:** Block VLAN 20 from reaching VLAN 10 management subnet
- [ ] **SSH:** Enabled on all routers
- [ ] **NTP:** R1 as server, R2 and R3 as clients
- [ ] **Port security:** Sticky, max 2, shutdown on SW1 access ports

### Verification Commands (Run All)

```
! On every router:
show ip route
show ip ospf neighbor
show ip interface brief

! On R1:
show ip nat translations

! On R2:
show ip dhcp binding

! On switches:
show vlan brief
show interfaces trunk
show port-security

! End-to-end:
ping from PC1 (VLAN 10) → PC5 (Branch)
ping from PC3 (VLAN 20) → PC1 (VLAN 10)
```

---

## Exercise 4: Drag-and-Drop Practice Sets

### Set 1: OSI Layers ↔ Protocols/Devices

Match each item to its OSI layer:

| Item | Layer (1-7) |
|------|-------------|
| Router | ? |
| TCP | ? |
| HTTP | ? |
| Switch (L2) | ? |
| Ethernet cable | ? |
| IP | ? |
| 802.1Q | ? |

<details>
<summary>Answers</summary>

| Item | Layer |
|------|-------|
| Router | 3 (Network) |
| TCP | 4 (Transport) |
| HTTP | 7 (Application) |
| Switch (L2) | 2 (Data Link) |
| Ethernet cable | 1 (Physical) |
| IP | 3 (Network) |
| 802.1Q | 2 (Data Link) |

</details>

### Set 2: Port Numbers ↔ Services

| Service | Port |
|---------|------|
| SSH | ? |
| DNS | ? |
| HTTPS | ? |
| SNMP | ? |
| NTP | ? |
| TACACS+ | ? |
| Syslog | ? |
| TFTP | ? |

<details>
<summary>Answers</summary>

| Service | Port |
|---------|------|
| SSH | TCP 22 |
| DNS | UDP/TCP 53 |
| HTTPS | TCP 443 |
| SNMP | UDP 161 |
| NTP | UDP 123 |
| TACACS+ | TCP 49 |
| Syslog | UDP 514 |
| TFTP | UDP 69 |

</details>

### Set 3: NAT Terms ↔ Definitions

| Term | Definition |
|------|-----------|
| Inside Local | ? |
| Inside Global | ? |
| Outside Local | ? |
| Outside Global | ? |

<details>
<summary>Answers</summary>

| Term | Definition |
|------|-----------|
| Inside Local | Private IP configured on the internal host |
| Inside Global | Public IP representing the internal host to outside |
| Outside Local | How the inside network sees the remote host (usually = outside global) |
| Outside Global | Real public IP of the remote host |

</details>

### Set 4: OSPF States Order

Arrange in correct order: **Down → ?**

| State | Order |
|-------|-------|
| Full | ? |
| Init | ? |
| Exchange | ? |
| 2-Way | ? |
| Loading | ? |
| ExStart | ? |
| Down | ? |

<details>
<summary>Answers</summary>

1. **Down** — No hellos sent/received
2. **Init** — Hello received, but 2-way not confirmed
3. **2-Way** — Both routers see each other's Router ID in hellos. DR/BDR elected here.
4. **ExStart** — Master/slave negotiation begins
5. **Exchange** — DBD (Database Description) packets exchanged
6. **Loading** — LSR/LSU/LSAck exchanged for missing routes
7. **Full** — Complete adjacency, identical LSDBs

</details>

---

## Exercise 5: Command Completion from Memory

**Instructions:** Fill in the missing parts of each configuration. Write your answer BEFORE checking.

### Config 1: Router-on-a-Stick

```
interface GigabitEthernet0/0.10
 encapsulation ______ ______
 ip address 192.168.10.1 255.255.255.0
!
interface GigabitEthernet0/0.20
 encapsulation ______ ______
 ip address __________ 255.255.255.0
```

<details>
<summary>Answer</summary>

```
encapsulation dot1Q 10
encapsulation dot1Q 20
ip address 192.168.20.1
```

</details>

### Config 2: OSPF

```
router ospf 1
 router-id ________
 network 192.168.1.0 __________ area __
 network 10.0.0.0 __________ area __
 _____________ GigabitEthernet0/0
 __________________________
```

<details>
<summary>Answer</summary>

```
router-id 1.1.1.1
network 192.168.1.0 0.0.0.255 area 0
network 10.0.0.0 0.0.0.3 area 0
passive-interface GigabitEthernet0/0
default-information originate
```

</details>

### Config 3: NAT/PAT

```
access-list 1 permit 192.168.0.0 __________
ip nat inside source list __ interface GigabitEthernet0/0 ________
!
interface GigabitEthernet0/0
 ip nat ________
interface GigabitEthernet0/1
 ip nat ________
```

<details>
<summary>Answer</summary>

```
access-list 1 permit 192.168.0.0 0.0.255.255
ip nat inside source list 1 interface GigabitEthernet0/0 overload
ip nat outside
ip nat inside
```

</details>

### Config 4: Port Security

```
interface FastEthernet0/1
 switchport mode ________
 switchport ____________
 switchport port-security __________ 3
 switchport port-security __________ shutdown
 switchport port-security mac-address ________
```

<details>
<summary>Answer</summary>

```
switchport mode access
switchport port-security
switchport port-security maximum 3
switchport port-security violation shutdown
switchport port-security mac-address sticky
```

</details>

### Config 5: SSH Setup

```
hostname R1
ip _________ company.local
username admin _________ 15 secret Cisco123
crypto key generate ___ modulus ____
ip ssh version __
!
line vty 0 15
 transport input ___
 login _____
```

<details>
<summary>Answer</summary>

```
ip domain-name company.local
username admin privilege 15 secret Cisco123
crypto key generate rsa modulus 2048
ip ssh version 2
transport input ssh
login local
```

</details>

### Config 6: DHCP Server

```
ip dhcp ________________ 192.168.1.1 192.168.1.10
ip dhcp pool LAN
 ________ 192.168.1.0 255.255.255.0
 ______________ 192.168.1.1
 __________ 8.8.8.8
```

<details>
<summary>Answer</summary>

```
ip dhcp excluded-address 192.168.1.1 192.168.1.10
network 192.168.1.0 255.255.255.0
default-router 192.168.1.1
dns-server 8.8.8.8
```

</details>

---

**→ Continue to [Challenges](challenges.md) for the final capstone exercises.**
