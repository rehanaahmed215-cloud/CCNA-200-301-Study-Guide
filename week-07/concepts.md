# Week 7 — Concepts: IP Services (DHCP, DNS, NAT/PAT, NTP, SNMP, Syslog)

## Table of Contents
- [1. DHCP — Dynamic Host Configuration Protocol](#1-dhcp--dynamic-host-configuration-protocol)
- [2. DHCP DORA Process](#2-dhcp-dora-process)
- [3. DHCP Server Configuration (IOS)](#3-dhcp-server-configuration-ios)
- [4. DHCP Relay Agent](#4-dhcp-relay-agent)
- [5. DNS — Domain Name System](#5-dns--domain-name-system)
- [6. NAT — Network Address Translation](#6-nat--network-address-translation)
- [7. Static NAT](#7-static-nat)
- [8. Dynamic NAT](#8-dynamic-nat)
- [9. PAT — Port Address Translation (NAT Overload)](#9-pat--port-address-translation-nat-overload)
- [10. NTP — Network Time Protocol](#10-ntp--network-time-protocol)
- [11. SNMP — Simple Network Management Protocol](#11-snmp--simple-network-management-protocol)
- [12. Syslog](#12-syslog)
- [Quiz — 10 Questions](#quiz--10-questions)

---

## 1. DHCP — Dynamic Host Configuration Protocol

DHCP automatically assigns IP configuration to hosts:
- IP address
- Subnet mask
- Default gateway
- DNS server(s)
- Lease time

**Why DHCP?** Manually configuring hundreds of devices is impractical and error-prone.

**Key terms:**
- **DHCP Server:** Assigns addresses from a pool
- **DHCP Client:** Requests an address
- **DHCP Relay Agent:** Forwards DHCP broadcasts across subnets (because routers don't forward broadcasts)
- **Scope/Pool:** The range of addresses available for assignment
- **Lease:** How long a client keeps its address before renewing

---

## 2. DHCP DORA Process

The four-step DHCP process uses **broadcast** messages:

| Step | Message | Direction | Type |
|------|---------|-----------|------|
| **D** | Discover | Client → Broadcast | "Any DHCP servers out there?" |
| **O** | Offer | Server → Broadcast | "Here's an IP you can use" |
| **R** | Request | Client → Broadcast | "I'll take that IP, please" |
| **A** | Acknowledge | Server → Broadcast | "Confirmed — it's yours" |

**Important details:**
- Discover and Request are **broadcast** (client doesn't have an IP yet)
- Offer and Acknowledge are also broadcast (in most implementations)
- Client uses source IP `0.0.0.0`, destination `255.255.255.255`
- After DORA, the client has a valid IP configuration

**Lease renewal:** At 50% of lease time (T1), client sends unicast Request to renew. At 87.5% (T2), it broadcasts if no response.

---

## 3. DHCP Server Configuration (IOS)

```
! Create the DHCP pool
ip dhcp pool SALES_VLAN
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 8.8.8.8 8.8.4.4
 domain-name company.local
 lease 7                                    ← 7 days

! Exclude addresses you don't want assigned (servers, gateways, printers)
ip dhcp excluded-address 192.168.10.1 192.168.10.10
```

**Verification:**
```
show ip dhcp pool                           ← pool summary
show ip dhcp binding                        ← current leases
show ip dhcp server statistics              ← DORA counters
```

---

## 4. DHCP Relay Agent

When the DHCP server is on a **different subnet** from the clients, the router must relay the broadcast:

```
! On the router interface facing the clients:
interface GigabitEthernet0/0
 ip helper-address 10.0.0.100              ← IP of the DHCP server
```

**How it works:**
1. Client sends broadcast Discover
2. Router (with `ip helper-address`) converts it to a **unicast** and forwards to the DHCP server
3. Server responds to the router
4. Router forwards the response to the client

> `ip helper-address` also forwards other broadcasts by default: TFTP, DNS, TACACS, and more (UDP ports 69, 53, 49, etc.)

---

## 5. DNS — Domain Name System

DNS resolves **hostnames to IP addresses** (and vice versa).

**Record types:**
| Record | Purpose | Example |
|--------|---------|---------|
| A | Hostname → IPv4 | `www.cisco.com → 72.163.4.185` |
| AAAA | Hostname → IPv6 | `www.cisco.com → 2001:db8::1` |
| MX | Mail server | `cisco.com → mail.cisco.com` |
| CNAME | Alias | `www → webserver1.cisco.com` |
| PTR | Reverse (IP → name) | `72.163.4.185 → www.cisco.com` |

**DNS hierarchy:** Root (.) → TLD (.com, .org) → Domain (cisco.com) → Host (www.cisco.com)

**IOS DNS configuration:**
```
ip domain-lookup                            ← enable DNS resolution (default)
ip name-server 8.8.8.8                      ← set DNS server
ip domain-name company.local                ← set default domain suffix
```

---

## 6. NAT — Network Address Translation

NAT translates between **private (inside)** and **public (outside)** IP addresses.

**NAT terminology:**

| Term | Meaning |
|------|---------|
| **Inside Local** | Private IP of the internal host (e.g., 192.168.1.10) |
| **Inside Global** | Public IP representing the internal host on the internet (e.g., 203.0.113.5) |
| **Outside Local** | How the internal network sees the external host (usually same as Outside Global) |
| **Outside Global** | Real IP of the external host (e.g., 8.8.8.8) |

**Why NAT?**
- IPv4 address conservation (many private hosts share few public IPs)
- Security (hides internal network structure)
- Required because private IPs (RFC 1918) are not routable on the internet

---

## 7. Static NAT

One-to-one mapping: one private IP ↔ one public IP. Used for servers that need to be reachable from the internet.

```
! Map internal server to a public IP
ip nat inside source static 192.168.1.100 203.0.113.10

! Define inside and outside interfaces
interface GigabitEthernet0/0
 ip nat inside
interface GigabitEthernet0/1
 ip nat outside
```

**Verification:**
```
show ip nat translations
show ip nat statistics
```

---

## 8. Dynamic NAT

Pool of public IPs mapped dynamically to internal hosts. One public IP per active host.

```
! Define the pool of public addresses
ip nat pool PUBLIC_POOL 203.0.113.10 203.0.113.20 netmask 255.255.255.0

! Define which internal hosts can use NAT (ACL)
access-list 1 permit 192.168.1.0 0.0.0.255

! Link the ACL to the pool
ip nat inside source list 1 pool PUBLIC_POOL

! Define interfaces
interface GigabitEthernet0/0
 ip nat inside
interface GigabitEthernet0/1
 ip nat outside
```

> Problem: If all public IPs in the pool are in use, new hosts can't get translated → connection fails.

---

## 9. PAT — Port Address Translation (NAT Overload)

**The most common NAT type.** Many private IPs share **one** public IP by using different **port numbers** to distinguish sessions.

```
! Using the outside interface's IP
access-list 1 permit 192.168.1.0 0.0.0.255
ip nat inside source list 1 interface GigabitEthernet0/1 overload

! Define interfaces
interface GigabitEthernet0/0
 ip nat inside
interface GigabitEthernet0/1
 ip nat outside
```

**How PAT works:**
```
Inside Local        Inside Global           Outside Global
192.168.1.10:49001 → 203.0.113.1:49001 → 8.8.8.8:53 (DNS)
192.168.1.20:49002 → 203.0.113.1:49002 → 8.8.8.8:53 (DNS)
192.168.1.30:50000 → 203.0.113.1:50000 → 93.184.216.34:80 (HTTP)
```

All three use the **same public IP** but different source ports.

---

## 10. NTP — Network Time Protocol

Synchronized time is critical for:
- Accurate log timestamps (Syslog, debugging)
- Certificate validation
- Correlation of events across devices

**Stratum levels:**
- **Stratum 0:** Atomic clocks, GPS (reference clocks)
- **Stratum 1:** Directly connected to Stratum 0 (NTP servers)
- **Stratum 2:** Syncs from Stratum 1
- Lower stratum = more accurate. Max = Stratum 15 (Stratum 16 = unsynchronized)

**IOS configuration:**
```
! Point to an NTP server
ntp server 10.0.0.1

! Or make this router the NTP master (for lab use)
ntp master 3                                ← stratum 3

! Set timezone
clock timezone EST -5
clock summer-time EDT recurring
```

**Verification:**
```
show ntp status                             ← sync status, stratum level
show ntp associations                       ← NTP peers
show clock                                  ← current time
```

---

## 11. SNMP — Simple Network Management Protocol

SNMP allows a **Network Management System (NMS)** to monitor and manage network devices.

**Components:**
- **SNMP Manager (NMS):** Software that collects data (e.g., SolarWinds, PRTG, Nagios)
- **SNMP Agent:** Runs on the network device (router, switch)
- **MIB (Management Information Base):** Database of objects the agent can report on (interface status, CPU, traffic)

**Operations:**
| Operation | Direction | Description |
|-----------|-----------|-------------|
| `GET` | Manager → Agent | Request a specific value |
| `SET` | Manager → Agent | Change a setting |
| `TRAP` | Agent → Manager | Alert about an event (unsolicited) |
| `INFORM` | Agent → Manager | Like Trap but requires acknowledgment |
| `GET-NEXT` | Manager → Agent | Walk through MIB entries sequentially |

**SNMP versions:**

| Version | Auth | Encryption | Notes |
|---------|------|------------|-------|
| SNMPv1 | Community string (plaintext) | None | Deprecated |
| SNMPv2c | Community string (plaintext) | None | Most common in practice |
| **SNMPv3** | Username/password | Yes (AES, DES) | **Recommended for security** |

**IOS configuration (SNMPv2c):**
```
snmp-server community PUBLIC_RO ro          ← read-only community string
snmp-server community PRIVATE_RW rw         ← read-write community string
snmp-server host 10.0.0.200 version 2c PUBLIC_RO     ← send traps here
snmp-server enable traps                    ← enable all traps
```

---

## 12. Syslog

Syslog provides centralized logging across all network devices.

**Severity levels (memorize these!):**

| Level | Keyword | Description | Mnemonic |
|-------|---------|-------------|----------|
| 0 | Emergency | System unusable | **E**very |
| 1 | Alert | Immediate action needed | **A**wesome |
| 2 | Critical | Critical conditions | **C**isco |
| 3 | Error | Error conditions | **E**ngineer |
| 4 | Warning | Warning conditions | **W**ill |
| 5 | Notification | Normal but significant | **N**eed |
| 6 | Informational | Informational messages | **I**ce |
| 7 | Debugging | Debug-level messages | **C**ream |

> **Lower number = more severe.** Setting a level includes all levels above it (more severe).

**IOS configuration:**
```
logging host 10.0.0.200                     ← send logs to syslog server
logging trap informational                  ← send severity 0-6 to the server
logging console warnings                   ← display severity 0-4 on console
logging buffered 16384                      ← buffer size in bytes
service timestamps log datetime msec        ← add timestamps to all logs
```

**Verification:**
```
show logging                                ← current logging config and buffered logs
```

---

## Quiz — 10 Questions

**1.** What does DORA stand for in DHCP?

<details><summary>Answer</summary>Discover, Offer, Request, Acknowledge</details>

**2.** What command enables a router to forward DHCP broadcasts to a server on another subnet?

<details><summary>Answer</summary>`ip helper-address <DHCP-server-IP>` on the router interface facing the clients</details>

**3.** What's the difference between Static NAT, Dynamic NAT, and PAT?

<details><summary>Answer</summary>

- **Static NAT:** One-to-one mapping (1 private IP ↔ 1 public IP). Used for servers.
- **Dynamic NAT:** Pool of public IPs mapped dynamically. One public IP per session (pool can run out).
- **PAT:** Many private IPs share ONE public IP using different port numbers. Most common type.

</details>

**4.** What is the Inside Local vs. Inside Global address?

<details><summary>Answer</summary>Inside Local = the private IP of the internal host (e.g., 192.168.1.10). Inside Global = the public IP representing that host on the internet (e.g., 203.0.113.5).</details>

**5.** What NTP stratum number indicates an unsynchronized device?

<details><summary>Answer</summary>Stratum 16</details>

**6.** Which SNMP version supports encryption?

<details><summary>Answer</summary>SNMPv3 (supports authentication and encryption via AES/DES)</details>

**7.** What Syslog severity level is "Warning"?

<details><summary>Answer</summary>Level 4. If you set `logging trap 4`, you get levels 0-4 (Emergency through Warning).</details>

**8.** What happens if you configure `logging trap debugging` (level 7)?

<details><summary>Answer</summary>ALL messages (levels 0-7) are sent to the syslog server, including very verbose debug output. This can flood the server and impact performance.</details>

**9.** In PAT, how does the router distinguish between multiple internal hosts using the same public IP?

<details><summary>Answer</summary>By using unique **source port numbers** for each session. The router maintains a translation table mapping inside local IP:port to inside global IP:port.</details>

**10.** What DNS record type maps a hostname to an IPv6 address?

<details><summary>Answer</summary>AAAA record</details>

---

**Next → [Week 7 Exercises](exercises.md)**
