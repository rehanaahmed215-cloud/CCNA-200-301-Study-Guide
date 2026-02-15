# Week 11 — Exercises: Review & Practice Exams

## Table of Contents
- [Overview](#overview)
- [Exercise 1: Timed Subnetting Speed Drill (20 Problems)](#exercise-1-timed-subnetting-speed-drill-20-problems)
- [Exercise 2: show Command Identification Lab](#exercise-2-show-command-identification-lab)
- [Exercise 3: Rebuild the Week 5 Inter-VLAN Network from Memory](#exercise-3-rebuild-the-week-5-inter-vlan-network-from-memory)
- [Exercise 4: Rebuild the Week 6 OSPF Network from Memory](#exercise-4-rebuild-the-week-6-ospf-network-from-memory)
- [Exercise 5: Troubleshooting Gauntlet — 10 Broken Scenarios](#exercise-5-troubleshooting-gauntlet--10-broken-scenarios)
- [Exercise 6: Full Practice Exam — 50 Questions (60 Minutes)](#exercise-6-full-practice-exam--50-questions-60-minutes)

---

## Overview

This week's exercises are designed to be **timed and realistic**. Treat them like exam practice.

| Exercise | Format | Time Limit |
|----------|--------|-----------|
| 1. Subnetting drill | Written/mental math | 15 min |
| 2. show command ID | Output interpretation | 20 min |
| 3. Inter-VLAN rebuild | Packet Tracer / Containerlab | 30 min |
| 4. OSPF rebuild | Packet Tracer / Containerlab | 30 min |
| 5. Troubleshooting | Scenario-based | 40 min |
| 6. Practice exam | Multiple choice | 60 min |

---

## Exercise 1: Timed Subnetting Speed Drill (20 Problems)

**Instructions:** Start a timer. For each problem, find: **Network Address, Broadcast Address, Usable Host Range, Total Usable Hosts.** Target: complete all 20 in 15 minutes.

| # | Given IP/Prefix |
|---|----------------|
| 1 | 10.0.50.100/16 |
| 2 | 192.168.1.200/28 |
| 3 | 172.16.33.10/21 |
| 4 | 10.1.1.1/30 |
| 5 | 192.168.100.65/26 |
| 6 | 172.16.0.130/25 |
| 7 | 10.10.10.10/12 |
| 8 | 192.168.50.200/27 |
| 9 | 172.16.128.1/17 |
| 10 | 10.0.0.1/8 |
| 11 | 192.168.200.100/23 |
| 12 | 172.16.95.250/20 |
| 13 | 10.100.200.50/14 |
| 14 | 192.168.10.33/29 |
| 15 | 172.16.10.200/22 |
| 16 | 10.0.0.200/24 |
| 17 | 192.168.1.1/32 |
| 18 | 172.16.255.1/18 |
| 19 | 10.50.100.150/15 |
| 20 | 192.168.170.80/25 |

<details>
<summary><strong>Complete Answer Key</strong></summary>

| # | Network | Broadcast | First Host | Last Host | Usable |
|---|---------|-----------|------------|-----------|--------|
| 1 | 10.0.0.0 | 10.0.255.255 | 10.0.0.1 | 10.0.255.254 | 65,534 |
| 2 | 192.168.1.192 | 192.168.1.207 | 192.168.1.193 | 192.168.1.206 | 14 |
| 3 | 172.16.32.0 | 172.16.39.255 | 172.16.32.1 | 172.16.39.254 | 2,046 |
| 4 | 10.1.1.0 | 10.1.1.3 | 10.1.1.1 | 10.1.1.2 | 2 |
| 5 | 192.168.100.64 | 192.168.100.127 | 192.168.100.65 | 192.168.100.126 | 62 |
| 6 | 172.16.0.128 | 172.16.0.255 | 172.16.0.129 | 172.16.0.254 | 126 |
| 7 | 10.0.0.0 | 10.15.255.255 | 10.0.0.1 | 10.15.255.254 | 1,048,574 |
| 8 | 192.168.50.192 | 192.168.50.223 | 192.168.50.193 | 192.168.50.222 | 30 |
| 9 | 172.16.128.0 | 172.16.255.255 | 172.16.128.1 | 172.16.255.254 | 32,766 |
| 10 | 10.0.0.0 | 10.255.255.255 | 10.0.0.1 | 10.255.255.254 | 16,777,214 |
| 11 | 192.168.200.0 | 192.168.201.255 | 192.168.200.1 | 192.168.201.254 | 510 |
| 12 | 172.16.80.0 | 172.16.95.255 | 172.16.80.1 | 172.16.95.254 | 4,094 |
| 13 | 10.100.0.0 | 10.103.255.255 | 10.100.0.1 | 10.103.255.254 | 262,142 |
| 14 | 192.168.10.32 | 192.168.10.39 | 192.168.10.33 | 192.168.10.38 | 6 |
| 15 | 172.16.8.0 | 172.16.11.255 | 172.16.8.1 | 172.16.11.254 | 1,022 |
| 16 | 10.0.0.0 | 10.0.0.255 | 10.0.0.1 | 10.0.0.254 | 254 |
| 17 | 192.168.1.1 | 192.168.1.1 | N/A | N/A | 0 (host route) |
| 18 | 172.16.192.0 | 172.16.255.255 | 172.16.192.1 | 172.16.255.254 | 16,382 |
| 19 | 10.50.0.0 | 10.51.255.255 | 10.50.0.1 | 10.51.255.254 | 131,070 |
| 20 | 192.168.170.0 | 192.168.170.127 | 192.168.170.1 | 192.168.170.126 | 126 |

</details>

---

## Exercise 2: show Command Identification Lab

**Instructions:** For each output snippet, identify: (A) the command used, (B) one key fact from the output.

### Output 1
```
Codes: C - connected, S - static, O - OSPF
       
Gateway of last resort is 203.0.113.1 to network 0.0.0.0

S*    0.0.0.0/0 [1/0] via 203.0.113.1
C     192.168.1.0/24 is directly connected, GigabitEthernet0/0
O     10.0.0.0/8 [110/20] via 192.168.1.2, 00:05:12, GigabitEthernet0/0
O     172.16.0.0/16 [110/30] via 192.168.1.3, 00:04:55, GigabitEthernet0/0
```

<details>
<summary>Answer</summary>

- **Command:** `show ip route`
- **Key fact:** Default route is a static route pointing to 203.0.113.1; OSPF is learning two routes with costs 20 and 30.
</details>

### Output 2
```
Neighbor ID     Pri   State           Dead Time   Address         Interface
10.0.0.2          1   FULL/DR         00:00:35    192.168.1.2     Gi0/0
10.0.0.3          1   FULL/BDR        00:00:31    192.168.1.3     Gi0/0
```

<details>
<summary>Answer</summary>

- **Command:** `show ip ospf neighbor`
- **Key fact:** Two OSPF neighbors, both FULL adjacency. 10.0.0.2 is the DR, 10.0.0.3 is the BDR.
</details>

### Output 3
```
VLAN Name                             Status    Ports
---- -------------------------------- --------- ---------------------
1    default                          active    Gi0/3
10   Engineering                      active    Gi0/1, Gi0/2
20   Sales                            active    Gi0/4, Gi0/5
30   Management                       active    
99   Native                           active    
```

<details>
<summary>Answer</summary>

- **Command:** `show vlan brief`
- **Key fact:** VLANs 10, 20, 30, 99 exist. VLAN 30 (Management) has no ports assigned. VLAN 99 is named "Native" (likely the trunk native VLAN).
</details>

### Output 4
```
Port        Mode         Encapsulation  Status        Native vlan
Gi0/1       on           802.1q         trunking      99
Gi0/2       on           802.1q         trunking      99
```

<details>
<summary>Answer</summary>

- **Command:** `show interfaces trunk`
- **Key fact:** Gi0/1 and Gi0/2 are both 802.1Q trunks with native VLAN 99.
</details>

### Output 5
```
Interface              IP-Address      OK? Method Status                Protocol
GigabitEthernet0/0     192.168.1.1     YES manual up                    up
GigabitEthernet0/1     203.0.113.5     YES DHCP   up                    up
Serial0/0/0            unassigned      YES unset  administratively down down
```

<details>
<summary>Answer</summary>

- **Command:** `show ip interface brief`
- **Key fact:** Gi0/0 is manually configured, Gi0/1 got its IP via DHCP, and Serial0/0/0 is administratively shut down (needs `no shutdown`).
</details>

### Output 6
```
Extended IP access list 101
    10 permit tcp 192.168.1.0 0.0.0.255 any eq 80 (1250 matches)
    20 permit tcp 192.168.1.0 0.0.0.255 any eq 443 (3400 matches)
    30 deny ip 192.168.1.0 0.0.0.255 10.0.0.0 0.255.255.255 (15 matches)
    40 permit ip any any (8900 matches)
```

<details>
<summary>Answer</summary>

- **Command:** `show access-lists` (or `show ip access-lists`)
- **Key fact:** Extended ACL 101 allows HTTP (80) and HTTPS (443) from 192.168.1.0/24 to anywhere, blocks that subnet from reaching 10.0.0.0/8, and permits all other traffic. 15 packets have been denied by rule 30.
</details>

### Output 7
```
Pro Inside global      Inside local       Outside local      Outside global
tcp 203.0.113.5:1024   192.168.1.10:5001  93.184.216.34:80   93.184.216.34:80
tcp 203.0.113.5:1025   192.168.1.11:5002  93.184.216.34:443  93.184.216.34:443
tcp 203.0.113.5:1026   192.168.1.10:5003  8.8.8.8:53         8.8.8.8:53
```

<details>
<summary>Answer</summary>

- **Command:** `show ip nat translations`
- **Key fact:** PAT (overload) is in use — multiple inside local IPs (192.168.1.10, .11) share one inside global IP (203.0.113.5) differentiated by port numbers.
</details>

---

## Exercise 3: Rebuild the Week 5 Inter-VLAN Network from Memory

**Goal:** Without looking at Week 5, recreate the full Inter-VLAN routing topology.

### Requirements (from memory)
- 2 VLANs (at minimum)
- 2 Layer-2 switches
- 1 router performing router-on-a-stick
- PCs in different VLANs that can ping each other

### Steps
1. Open **Packet Tracer** (or deploy a new Containerlab topology)
2. Place and cable all devices from memory
3. Configure:
   - VLANs on both switches
   - Trunk links between switches and to the router
   - Router subinterfaces with 802.1Q encapsulation
   - PC IP addresses and default gateways
4. Verify:
   - `show vlan brief` — correct VLAN assignments
   - `show interfaces trunk` — trunks active
   - PCs in different VLANs can ping each other through the router

### Time Target: 30 minutes

<details>
<summary><strong>Key Configuration Hints (if stuck)</strong></summary>

**Router subinterface (router-on-a-stick):**
```
interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0

interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
```

**Switch trunk:**
```
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk native vlan 99
```

**Switch access port:**
```
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
```

</details>

---

## Exercise 4: Rebuild the Week 6 OSPF Network from Memory

**Goal:** Without looking at Week 6, recreate a multi-router OSPF network.

### Requirements (from memory)
- 3 routers in a chain (R1 — R2 — R3)
- OSPF single area (area 0)
- Each router has a LAN (with at least 1 host)
- Hosts on R1's LAN can ping hosts on R3's LAN

### Steps
1. Open **Packet Tracer** or Containerlab
2. Build the topology from memory
3. Configure:
   - IP addressing on all interfaces
   - OSPF on all routers (advertise correct networks)
   - Passive interfaces on LAN-facing interfaces
4. Verify:
   - `show ip ospf neighbor` — all routers see neighbors
   - `show ip route` — OSPF routes appear (O code)
   - End-to-end ping works

### Time Target: 30 minutes

<details>
<summary><strong>Key Configuration Hints (if stuck)</strong></summary>

**OSPF configuration (Cisco IOS):**
```
router ospf 1
 router-id 1.1.1.1
 network 192.168.1.0 0.0.0.255 area 0
 network 10.0.0.0 0.0.0.3 area 0
 passive-interface GigabitEthernet0/0
```

**FRRouting equivalent:**
```
router ospf
 ospf router-id 1.1.1.1
 network 192.168.1.0/24 area 0
 network 10.0.0.0/30 area 0
 passive-interface eth0
```

</details>

---

## Exercise 5: Troubleshooting Gauntlet — 10 Broken Scenarios

**Instructions:** For each scenario, identify the problem and the fix. These mirror real exam troubleshooting questions.

### Scenario 1: No OSPF Adjacency
```
R1# show ip ospf neighbor
(empty output)

R1# show ip ospf interface Gi0/0
  Internet Address 192.168.1.1/24, Area 0
  Hello 10, Dead 40, Retransmit 5

R2# show ip ospf interface Gi0/0
  Internet Address 192.168.1.2/24, Area 1
  Hello 10, Dead 40, Retransmit 5
```

<details>
<summary>Answer</summary>

**Problem:** Area mismatch — R1 is in area 0, R2 is in area 1.
**Fix:** Change R2's network statement to area 0 (or vice versa). Both must be in the same OSPF area on the shared link.
</details>

### Scenario 2: VLAN Ping Fails
```
SW1# show vlan brief
VLAN 10 - Ports: Fa0/1
VLAN 20 - Ports: Fa0/2

SW1# show interfaces trunk
(no output)
```

<details>
<summary>Answer</summary>

**Problem:** No trunk link exists. The uplink to the router (or other switch) is not configured as a trunk.
**Fix:** Configure the uplink port as a trunk: `switchport mode trunk`
</details>

### Scenario 3: NAT Not Working
```
R1# show ip nat translations
(empty)

R1# show run | section nat
ip nat inside source list 1 interface Gi0/1 overload
access-list 1 permit 192.168.1.0 0.0.0.255

R1# show ip interface Gi0/0
  ip nat outside

R1# show ip interface Gi0/1
  ip nat outside
```

<details>
<summary>Answer</summary>

**Problem:** Both interfaces are marked as `ip nat outside`. The LAN interface (Gi0/0) should be `ip nat inside`.
**Fix:** `interface Gi0/0` → `ip nat inside`
</details>

### Scenario 4: SSH Connection Refused
```
R1# show ip ssh
SSH Disabled - version 1.99
%Please create RSA keys to enable SSH
```

<details>
<summary>Answer</summary>

**Problem:** RSA keys haven't been generated. SSH requires a crypto key pair.
**Fix:** `crypto key generate rsa modulus 2048` (also ensure `ip domain-name` is set)
</details>

### Scenario 5: DHCP Clients Get No IP
```
PC1> ipconfig
IP: 169.254.x.x (APIPA)

R1# show ip dhcp binding
(entries exist for other PCs)

R1# show ip dhcp pool
Pool: LAN_POOL
 Network: 192.168.1.0/24
 Default Router: 192.168.1.1
```

<details>
<summary>Answer</summary>

**Problem:** PC1 is likely on a different subnet/VLAN from the DHCP server. The DHCP Discover broadcast isn't reaching R1.
**Fix:** Configure `ip helper-address 192.168.1.1` on the interface facing PC1's subnet (DHCP relay).
</details>

### Scenario 6: ACL Blocking Everything
```
R1# show access-lists
Extended IP access list 100
    10 permit tcp 192.168.1.0 0.0.0.255 any eq 80 (0 matches)
    20 deny ip any any (5000 matches)
```

<details>
<summary>Answer</summary>

**Problem:** The ACL permits HTTP (80) only — all other traffic (HTTPS, DNS, ICMP ping, etc.) is denied by explicit deny statement. Rule 10 has 0 matches, suggesting no HTTP traffic yet.
**Fix:** Add rules for other needed traffic (443, DNS, ICMP) before the deny, or change line 20 to `permit ip any any` if unrestricted access is desired.
</details>

### Scenario 7: STP Blocking Wrong Port
```
SW2# show spanning-tree vlan 10
Root ID    Priority 32778
           Address  aabb.cc00.1000

Bridge ID  Priority 32778
           Address  aabb.cc00.2000

Interface  Role Sts  Cost
Gi0/1      Root FWD  4
Gi0/2      Altn BLK  4
```

A user on Gi0/2 needs the direct path to the root. Currently it's blocked by STP.

<details>
<summary>Answer</summary>

**Problem:** Both paths have equal cost (4), so STP blocks one. This is expected behavior.
**Fix:** To influence which port is blocked, adjust the port cost: `interface Gi0/2` → `spanning-tree vlan 10 cost 2` (lower cost makes it preferred). Or adjust the priority on the upstream switch ports.
</details>

### Scenario 8: Port Security Violation
```
SW1# show port-security interface Fa0/1
Port Security              : Enabled
Port Status                : Secure-shutdown
Violation Mode             : Shutdown
Maximum MAC Addresses      : 1
Total MAC Addresses        : 1
Sticky MAC Addresses       : 1
Last Source Address         : aabb.cc00.9999
Security Violation Count   : 1
```

<details>
<summary>Answer</summary>

**Problem:** A second MAC address was seen on Fa0/1, triggering a violation. The port is now in err-disabled state (secure-shutdown).
**Fix:** Remove the rogue device, then: `shutdown` then `no shutdown` on the interface (or configure `errdisable recovery cause psecure-violation` for auto-recovery).
</details>

### Scenario 9: Default Route Not Propagating via OSPF
```
R1# show ip route
S*   0.0.0.0/0 [1/0] via 203.0.113.1

R2# show ip route
(no default route visible)

R1# show run | section ospf
router ospf 1
 network 192.168.1.0 0.0.0.255 area 0
```

<details>
<summary>Answer</summary>

**Problem:** R1 has a static default route but isn't redistributing it into OSPF.
**Fix:** Under `router ospf 1`, add: `default-information originate`
</details>

### Scenario 10: EtherChannel Not Forming
```
SW1# show etherchannel summary
Group  Port-channel  Protocol    Ports
1      Po1(SD)       LACP        Fa0/1(I) Fa0/2(I)

SW2# show etherchannel summary
Group  Port-channel  Protocol    Ports
1      Po1(SD)       PAgP        Fa0/1(I) Fa0/2(I)
```

<details>
<summary>Answer</summary>

**Problem:** Protocol mismatch — SW1 is using LACP, SW2 is using PAgP. These are incompatible.
**Fix:** Change both to the same protocol. LACP is preferred: on both switches, use `channel-group 1 mode active`
</details>

---

## Exercise 6: Full Practice Exam — 50 Questions (60 Minutes)

**Instructions:** This simulates half the real CCNA exam. Set a timer for 60 minutes. Answer all 50 questions. No looking anything up.

**Format:** Circle/write your answer. Check answers only after completing ALL questions.

---

**1.** Which layer of the OSI model is responsible for logical addressing?
- A) Data Link
- B) Network
- C) Transport
- D) Session

**2.** What is the default OSPF hello interval on a broadcast network?
- A) 5 seconds
- B) 10 seconds
- C) 30 seconds
- D) 40 seconds

**3.** How many usable hosts exist in a /25 subnet?
- A) 64
- B) 126
- C) 128
- D) 254

**4.** Which protocol uses TCP port 22?
- A) Telnet
- B) SSH
- C) HTTPS
- D) SNMP

**5.** What does 802.1Q add to an Ethernet frame?
- A) Source IP address
- B) 4-byte VLAN tag
- C) IPsec header
- D) TTL field

**6.** In STP, which bridge becomes the root?
- A) Highest MAC address
- B) Lowest MAC address
- C) Lowest Bridge ID (priority + MAC)
- D) Highest Bridge ID

**7.** What wildcard mask matches the network 10.0.0.0/8?
- A) 0.255.255.255
- B) 255.0.0.0
- C) 0.0.0.255
- D) 255.255.255.0

**8.** Which NAT type maps one inside local to one inside global permanently?
- A) Dynamic NAT
- B) Static NAT
- C) PAT
- D) Reverse NAT

**9.** What OSPF state indicates a full adjacency?
- A) Init
- B) 2-Way
- C) Exchange
- D) Full

**10.** What command creates VLAN 30 on a Cisco switch?
- A) `vlan add 30`
- B) `create vlan 30`
- C) `vlan 30` (from global config)
- D) `switchport vlan 30`

**11.** What is the purpose of the `ip helper-address` command?
- A) Assigns a static IP to an interface
- B) Relays DHCP broadcasts as unicast to a server
- C) Defines the default gateway
- D) Configures DNS resolution

**12.** Which ACL type filters based on source AND destination?
- A) Standard
- B) Extended
- C) Named only
- D) Reflexive

**13.** What does BPDU Guard do?
- A) Blocks all BPDUs on the network
- B) Disables STP globally
- C) Err-disables a PortFast port if a BPDU is received
- D) Increases STP convergence time

**14.** What is the administrative distance of a static route?
- A) 0
- B) 1
- C) 90
- D) 110

**15.** Which IPv6 address type starts with FE80?
- A) Global Unicast
- B) Unique Local
- C) Link-Local
- D) Multicast

**16.** What DHCP message does a client send first?
- A) Offer
- B) Request
- C) Discover
- D) Acknowledge

**17.** In PAT, what differentiates traffic from multiple hosts using the same public IP?
- A) MAC address
- B) Port numbers
- C) VLAN tags
- D) TTL values

**18.** What Syslog level is "Emergency"?
- A) 0
- B) 1
- C) 6
- D) 7

**19.** Which EtherChannel protocol is IEEE standard?
- A) PAgP
- B) LACP
- C) DTP
- D) VTP

**20.** What's the subnet mask for /20?
- A) 255.255.240.0
- B) 255.255.248.0
- C) 255.255.224.0
- D) 255.255.252.0

**21.** Which command shows OSPF neighbor relationships?
- A) `show ip route`
- B) `show ip ospf neighbor`
- C) `show ospf database`
- D) `show ip protocols`

**22.** What happens when a frame arrives on a trunk port without a VLAN tag?
- A) It's dropped
- B) It's assigned to the native VLAN
- C) It's broadcast to all VLANs
- D) It's sent back to the source

**23.** Which DNS record maps a hostname to an IPv4 address?
- A) AAAA
- B) A
- C) MX
- D) CNAME

**24.** What port does HTTPS use?
- A) 80
- B) 8080
- C) 443
- D) 8443

**25.** In SDN, what plane makes forwarding decisions?
- A) Management plane
- B) Control plane
- C) Data plane
- D) Application plane

**26.** What does the `passive-interface` command do in OSPF?
- A) Disables OSPF entirely on the interface
- B) Stops sending Hello packets but still advertises the network
- C) Increases the Hello interval to 60 seconds
- D) Makes the interface a stub

**27.** What type of route has AD 0?
- A) Static
- B) OSPF
- C) Connected
- D) EIGRP

**28.** What is the broadcast address for 172.16.64.0/18?
- A) 172.16.127.255
- B) 172.16.95.255
- C) 172.16.128.255
- D) 172.16.255.255

**29.** Which AAA protocol uses TCP and encrypts the entire payload?
- A) RADIUS
- B) TACACS+
- C) LDAP
- D) Kerberos

**30.** What data format uses indentation (no brackets) for structure?
- A) JSON
- B) XML
- C) YAML
- D) CSV

**31.** What happens at the end of every ACL (implicit rule)?
- A) permit any
- B) deny any
- C) log all
- D) redirect

**32.** What is the OSPF cost for a 1 Gbps link (reference BW 100 Mbps)?
- A) 1
- B) 10
- C) 100
- D) 0.1

**33.** Which HTTP method creates a new resource?
- A) GET
- B) POST
- C) PUT
- D) DELETE

**34.** What port-security violation mode drops offending frames silently?
- A) Shutdown
- B) Restrict
- C) Protect
- D) Block

**35.** What NTP stratum level indicates a direct connection to a reference clock?
- A) 0
- B) 1
- C) 2
- D) 16

**36.** Which command saves the running configuration to NVRAM?
- A) `write memory`
- B) `copy startup-config running-config`
- C) `save config`
- D) Both A and `copy running-config startup-config`

**37.** What does ARP do?
- A) Maps IP to MAC addresses
- B) Maps MAC to IP addresses
- C) Resolves hostnames to IPs
- D) Encrypts Layer 2 frames

**38.** In a router-on-a-stick configuration, what goes on the subinterface?
- A) Physical cable connection
- B) 802.1Q encapsulation and IP address for the VLAN
- C) STP root bridge priority
- D) OSPF area assignment

**39.** What SNMP version provides encryption and authentication?
- A) v1
- B) v2c
- C) v3
- D) All versions

**40.** What is the binary equivalent of the decimal number 192?
- A) 11000000
- B) 10110000
- C) 10100000
- D) 11100000

**41.** Which routing protocol is CCNA 200-301's primary focus?
- A) RIP
- B) EIGRP
- C) OSPF
- D) BGP

**42.** What does DAI protect against?
- A) DHCP starvation
- B) ARP spoofing/poisoning
- C) MAC flooding
- D) DNS hijacking

**43.** What command shows the MAC address table on a switch?
- A) `show arp`
- B) `show mac address-table`
- C) `show mac-table`
- D) `show interface mac`

**44.** What is the maximum number of hosts in a /24?
- A) 256
- B) 255
- C) 254
- D) 252

**45.** In Ansible, what is a playbook?
- A) A Python script that logs into devices
- B) A YAML file defining tasks to run on managed hosts
- C) A JSON database of device inventory
- D) A REST API endpoint

**46.** What two things does a switch use to make forwarding decisions?
- A) Source IP and destination IP
- B) Destination MAC and MAC address table
- C) Source MAC and routing table
- D) TTL and destination IP

**47.** What is the purpose of DHCP snooping's binding table?
- A) To store DNS records
- B) To map MAC ↔ IP ↔ VLAN ↔ Port for trusted DHCP assignments
- C) To cache ARP entries
- D) To track STP port states

**48.** Which 802.11 standard operates on both 2.4 GHz and 5 GHz?
- A) 802.11a
- B) 802.11b
- C) 802.11n (Wi-Fi 4)
- D) 802.11g

**49.** What is the purpose of a floating static route?
- A) Load balancing between two paths
- B) Backup route with higher AD, used only when primary fails
- C) Route that changes cost dynamically
- D) Default route for all traffic

**50.** What is the network address for host 10.130.72.44/14?
- A) 10.128.0.0
- B) 10.130.0.0
- C) 10.130.72.0
- D) 10.132.0.0

---

<details>
<summary><strong>Answer Key — Practice Exam</strong></summary>

| # | Answer | Explanation |
|---|--------|-------------|
| 1 | **B** | Network layer handles IP (logical) addressing |
| 2 | **B** | 10 seconds (dead time = 40 seconds = 4× hello) |
| 3 | **B** | 2^7 - 2 = 126 usable hosts |
| 4 | **B** | SSH uses TCP port 22 |
| 5 | **B** | 802.1Q inserts a 4-byte tag (TPID + TCI) |
| 6 | **C** | Lowest Bridge ID (priority 32768 by default + MAC) |
| 7 | **A** | /8 mask = 255.0.0.0, wildcard = 0.255.255.255 |
| 8 | **B** | Static NAT = permanent 1:1 mapping |
| 9 | **D** | Full = complete adjacency, LSAs exchanged |
| 10 | **C** | `vlan 30` in global config mode |
| 11 | **B** | Relays DHCP broadcasts to a unicast server |
| 12 | **B** | Extended ACLs filter on source + destination + ports |
| 13 | **C** | Err-disables a PortFast-enabled port if BPDU arrives |
| 14 | **B** | Static route AD = 1 |
| 15 | **C** | FE80::/10 = Link-Local |
| 16 | **C** | DORA: **D**iscover is first |
| 17 | **B** | PAT uses unique port numbers to differentiate flows |
| 18 | **A** | Emergency = severity 0 (most critical) |
| 19 | **B** | LACP is IEEE 802.3ad; PAgP is Cisco proprietary |
| 20 | **A** | /20 = 255.255.240.0 |
| 21 | **B** | `show ip ospf neighbor` shows adjacencies |
| 22 | **B** | Untagged frames go to native VLAN |
| 23 | **B** | A record = hostname → IPv4 |
| 24 | **C** | HTTPS = TCP 443 |
| 25 | **B** | Control plane makes forwarding decisions; data plane moves packets |
| 26 | **B** | Stops sending hellos (no neighbors), still advertises subnet |
| 27 | **C** | Connected routes have AD = 0 |
| 28 | **A** | /18 block size = 64 in 2nd octet. 64→127.255 = 172.16.127.255 |
| 29 | **B** | TACACS+ uses TCP 49, encrypts full payload |
| 30 | **C** | YAML uses indentation for hierarchy |
| 31 | **B** | Implicit `deny any` at the end |
| 32 | **A** | 100 Mbps / 1000 Mbps = 0.1 → rounds to **1** (minimum cost) |
| 33 | **B** | POST = Create |
| 34 | **C** | Protect = silently drops, no log, no shutdown |
| 35 | **B** | Stratum 1 is directly attached to a reference clock (stratum 0 = the clock itself) |
| 36 | **D** | `write memory` and `copy run start` both save to NVRAM |
| 37 | **A** | ARP resolves IP → MAC |
| 38 | **B** | Subinterface gets `encapsulation dot1Q <vlan>` + IP address |
| 39 | **C** | SNMPv3 adds encryption + authentication |
| 40 | **A** | 192 = 128+64 = 11000000 |
| 41 | **C** | OSPF is the primary routing protocol for CCNA 200-301 |
| 42 | **B** | DAI (Dynamic ARP Inspection) prevents ARP spoofing |
| 43 | **B** | `show mac address-table` |
| 44 | **C** | 2^8 - 2 = 254 usable hosts |
| 45 | **B** | Ansible playbook = YAML file with tasks |
| 46 | **B** | Switches use destination MAC + MAC address table |
| 47 | **B** | Binding table maps MAC/IP/VLAN/Port from trusted DHCP |
| 48 | **C** | 802.11n (Wi-Fi 4) operates dual-band |
| 49 | **B** | Floating static = backup with higher AD |
| 50 | **A** | /14 mask = 255.252.0.0. 130 AND 252 = 128. Network = 10.128.0.0 |

### Scoring
| Score | Assessment |
|-------|-----------|
| 45-50 | **Exam ready!** Fine-tune speed and timing |
| 38-44 | Strong — review incorrect topics |
| 30-37 | Good base — dedicate extra study to weak domains |
| Below 30 | Need more review — revisit Weeks 1-10 concepts |

</details>

---

**→ Continue to [Challenges](challenges.md) for from-scratch network builds.**
