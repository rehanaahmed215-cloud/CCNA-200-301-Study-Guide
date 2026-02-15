# Week 8 — Concepts: Security Fundamentals

## Table of Contents
- [1. CIA Triad](#1-cia-triad)
- [2. Common Network Threats](#2-common-network-threats)
- [3. AAA Framework](#3-aaa-framework)
- [4. Device Hardening — Passwords and Access](#4-device-hardening--passwords-and-access)
- [5. SSH Configuration](#5-ssh-configuration)
- [6. Access Control Lists (ACLs)](#6-access-control-lists-acls)
- [7. Standard ACLs](#7-standard-acls)
- [8. Extended ACLs](#8-extended-acls)
- [9. Named ACLs](#9-named-acls)
- [10. ACL Placement Guidelines](#10-acl-placement-guidelines)
- [11. Port Security](#11-port-security)
- [12. DHCP Snooping](#12-dhcp-snooping)
- [13. Dynamic ARP Inspection (DAI)](#13-dynamic-arp-inspection-dai)
- [14. Security Best Practices Summary](#14-security-best-practices-summary)
- [Quiz — 10 Questions](#quiz--10-questions)

---

## 1. CIA Triad

The foundation of all information security:

| Principle | Meaning | Example |
|-----------|---------|---------|
| **Confidentiality** | Only authorized users can access data | Encryption, ACLs, SSH |
| **Integrity** | Data is not altered in transit or at rest | Hashing (MD5, SHA), digital signatures |
| **Availability** | Systems and data are accessible when needed | Redundancy, UPS, disaster recovery |

---

## 2. Common Network Threats

| Threat | Description | Mitigation |
|--------|-------------|------------|
| **Phishing** | Fraudulent emails to steal credentials | User training, email filtering |
| **DDoS** | Flood target to deny service | Rate limiting, ISP filtering, CDN |
| **Man-in-the-Middle** | Attacker intercepts communication | Encryption (HTTPS, SSH), DAI |
| **ARP Spoofing** | Fake ARP replies redirect traffic | Dynamic ARP Inspection (DAI) |
| **DHCP Spoofing** | Rogue DHCP server assigns bad config | DHCP Snooping |
| **MAC Flooding** | Overflow switch MAC table → switch floods all frames | Port security |
| **VLAN Hopping** | Exploit DTP/native VLAN to jump VLANs | Disable DTP, change native VLAN |
| **Brute Force** | Try all password combinations | Strong passwords, login delay, lockout |
| **Password Attack** | Intercept plaintext passwords | SSH (encrypted), `service password-encryption` |

---

## 3. AAA Framework

| Component | Purpose | Example |
|-----------|---------|---------|
| **Authentication** | Verify identity ("Who are you?") | Username/password, certificate |
| **Authorization** | Determine permissions ("What can you do?") | Privilege levels, ACLs |
| **Accounting** | Track actions ("What did you do?") | Logging, TACACS+/RADIUS |

**AAA Servers:**
- **TACACS+** (Cisco proprietary): Separates authentication, authorization, and accounting. Uses TCP port 49. Encrypts entire packet.
- **RADIUS** (open standard): Combines authentication and authorization. Uses UDP 1812/1813. Encrypts only password.

> CCNA level: Know the difference between TACACS+ and RADIUS, and that they provide centralized AAA.

---

## 4. Device Hardening — Passwords and Access

**Console password:**
```
line console 0
 password cisco123
 login                                      ← requires password
 exec-timeout 5 0                           ← auto-logout after 5 min idle
```

**VTY (remote access) password:**
```
line vty 0 15
 password cisco123
 login
 exec-timeout 5 0
 transport input ssh                        ← SSH only (no Telnet)
```

**Enable secret (privileged EXEC mode):**
```
enable secret Str0ngP@ss                    ← hashed with MD5 (type 5)
```
> Always use `enable secret` (not `enable password` which stores in cleartext)

**Encrypt all plaintext passwords:**
```
service password-encryption                 ← type 7 encryption (weak but better than plaintext)
```

**Banner:**
```
banner motd #Authorized access only. Violators will be prosecuted.#
```

**Disable unused services:**
```
no ip http server                           ← disable HTTP management
no cdp run                                  ← disable CDP (if not needed)
```

---

## 5. SSH Configuration

SSH provides **encrypted** remote access (vs. Telnet which is plaintext).

**Requirements:**
1. Hostname (not "Router")
2. Domain name
3. RSA key pair (minimum 1024 bits for SSHv2)
4. Local user account
5. VTY lines configured for SSH

```
hostname R1
ip domain-name company.local
crypto key generate rsa modulus 2048
username admin privilege 15 secret Str0ngP@ss

line vty 0 15
 transport input ssh
 login local                                ← use local user database
```

**Verify:**
```
show ip ssh                                 ← SSH version and status
show ssh                                    ← active SSH sessions
```

---

## 6. Access Control Lists (ACLs)

ACLs filter traffic based on criteria (source/destination IP, protocol, port).

**Key rules:**
1. ACLs are processed **top-down** — first match wins
2. Every ACL has an **implicit deny all** at the end
3. ACLs are applied to an interface in a **direction** (inbound or outbound)
4. One ACL per interface, per direction, per protocol

**Wildcard Masks** (inverse of subnet mask):
| Subnet Mask | Wildcard Mask | Meaning |
|-------------|---------------|---------|
| 255.255.255.255 | 0.0.0.0 | Match exact host |
| 255.255.255.0 | 0.0.0.255 | Match /24 network |
| 255.255.0.0 | 0.0.255.255 | Match /16 network |
| 255.255.255.252 | 0.0.0.3 | Match /30 network |

> Shortcut: `host 10.1.1.1` = `10.1.1.1 0.0.0.0` and `any` = `0.0.0.0 255.255.255.255`

---

## 7. Standard ACLs

Filter based on **source IP only**. Numbers **1-99** (or 1300-1999).

```
! Deny host 192.168.1.10, allow all others
access-list 10 deny host 192.168.1.10
access-list 10 permit any

! Apply to interface (close to destination)
interface GigabitEthernet0/1
 ip access-group 10 out
```

> **Placement rule:** Standard ACLs should be placed **close to the destination** (because they only filter on source IP — placing them at the source would block traffic to ALL destinations, not just the intended one).

---

## 8. Extended ACLs

Filter based on **source IP, destination IP, protocol, and port**. Numbers **100-199** (or 2000-2699).

```
! Allow HTTP from 192.168.1.0/24 to server 10.0.0.100
access-list 100 permit tcp 192.168.1.0 0.0.0.255 host 10.0.0.100 eq 80

! Deny Telnet from 192.168.1.0/24 to anywhere
access-list 100 deny tcp 192.168.1.0 0.0.0.255 any eq 23

! Allow everything else
access-list 100 permit ip any any

! Apply close to the source
interface GigabitEthernet0/0
 ip access-group 100 in
```

**Common port numbers:**
| Port | Service |
|------|---------|
| 20/21 | FTP |
| 22 | SSH |
| 23 | Telnet |
| 25 | SMTP |
| 53 | DNS |
| 67/68 | DHCP |
| 80 | HTTP |
| 110 | POP3 |
| 443 | HTTPS |

> **Placement rule:** Extended ACLs should be placed **close to the source** (because they can be specific enough to not block unintended traffic).

---

## 9. Named ACLs

More readable and editable than numbered ACLs.

```
ip access-list extended SALES_TO_SERVER
 permit tcp 192.168.10.0 0.0.0.255 host 10.0.0.100 eq 80
 permit tcp 192.168.10.0 0.0.0.255 host 10.0.0.100 eq 443
 deny ip 192.168.10.0 0.0.0.255 10.0.0.0 0.0.0.255
 permit ip any any

interface GigabitEthernet0/0
 ip access-group SALES_TO_SERVER in
```

**Advantages of named ACLs:**
- Descriptive names (SALES_TO_SERVER vs. 100)
- Can insert/delete individual lines: `no 20` removes sequence 20
- `show access-lists SALES_TO_SERVER` shows hit counts per line

---

## 10. ACL Placement Guidelines

| ACL Type | Place Close To | Why |
|----------|---------------|-----|
| Standard | **Destination** | Only filters on source — placing at source blocks ALL destinations |
| Extended | **Source** | Can be specific (src + dst + port) — block unwanted traffic early |

**Verification:**
```
show access-lists                           ← all ACLs and hit counts
show ip interface GigabitEthernet0/0        ← which ACL is applied and direction
show running-config | section access-list   ← ACL configuration
```

---

## 11. Port Security

Limits which MAC addresses can use a switch port, preventing MAC flooding and unauthorized devices.

**Configuration:**
```
interface FastEthernet0/1
 switchport mode access                     ← must be access mode
 switchport port-security                   ← enable port security
 switchport port-security maximum 2         ← max 2 MAC addresses
 switchport port-security mac-address sticky ← learn and save MACs automatically
 switchport port-security violation shutdown ← action on violation
```

**Violation modes:**
| Mode | Action | Counter increments | Port state |
|------|--------|-------------------|------------|
| **Shutdown** | Port enters err-disabled | Yes | Down — requires manual recovery |
| **Restrict** | Drops violating frames, sends SNMP trap | Yes | Up — legitimate traffic still flows |
| **Protect** | Drops violating frames silently | No | Up — legitimate traffic still flows |

**Recovery from err-disabled:**
```
interface FastEthernet0/1
 shutdown
 no shutdown
```

Or automatic:
```
errdisable recovery cause psecure-violation
errdisable recovery interval 300            ← seconds
```

**Verification:**
```
show port-security
show port-security interface FastEthernet0/1
show port-security address                  ← saved MAC addresses
```

---

## 12. DHCP Snooping

Prevents rogue DHCP servers from assigning bogus IP configurations.

**How it works:**
- Switch ports are classified as **trusted** or **untrusted**
- **Trusted ports:** Connected to legitimate DHCP servers (uplinks)
- **Untrusted ports:** Connected to end devices (access ports)
- DHCP Offers/Acks from untrusted ports are **dropped**
- Builds a **DHCP snooping binding table** (MAC ↔ IP ↔ port ↔ VLAN)

```
ip dhcp snooping                            ← enable globally
ip dhcp snooping vlan 10,20                 ← enable for specific VLANs

interface GigabitEthernet0/1
 ip dhcp snooping trust                     ← trunk/uplink to DHCP server

! Access ports are untrusted by default
interface range FastEthernet0/1-24
 ip dhcp snooping limit rate 15             ← limit DHCP packets per second
```

**Verification:**
```
show ip dhcp snooping
show ip dhcp snooping binding               ← binding table
```

---

## 13. Dynamic ARP Inspection (DAI)

Prevents ARP spoofing by validating ARP packets against the DHCP snooping binding table.

**Prerequisite:** DHCP snooping must be enabled (DAI uses its binding table).

```
ip arp inspection vlan 10,20

! Trust uplinks (where legitimate ARP replies come from)
interface GigabitEthernet0/1
 ip arp inspection trust

! Access ports are untrusted by default — ARP replies are validated
```

**How it works:**
1. Host sends an ARP reply on an untrusted port
2. Switch checks: does the source MAC + IP in the ARP packet match the DHCP snooping binding table?
3. If **match** → forward the ARP reply
4. If **no match** → drop the ARP reply and log the violation

**Verification:**
```
show ip arp inspection vlan 10
show ip arp inspection interfaces
```

---

## 14. Security Best Practices Summary

| Category | Best Practice |
|----------|--------------|
| Passwords | Use `enable secret`, `service password-encryption`, strong passwords |
| Remote access | SSH only (`transport input ssh`), disable Telnet |
| Unused ports | `shutdown` all unused switch ports, assign to a "black hole" VLAN |
| ACLs | Filter traffic at network boundaries, use named extended ACLs |
| Port security | Enable on all access ports, sticky MACs, shutdown violation |
| DHCP | Enable DHCP snooping, rate-limit untrusted ports |
| ARP | Enable DAI on access VLANs |
| VLANs | Change native VLAN from 1, disable DTP (`switchport nonegotiate`) |
| Banners | Legal warning banner on all devices |
| Logging | Send logs to syslog server, NTP for time sync |

---

## Quiz — 10 Questions

**1.** What does the CIA triad stand for?

<details><summary>Answer</summary>Confidentiality, Integrity, Availability</details>

**2.** What is the implicit rule at the end of every ACL?

<details><summary>Answer</summary>Implicit deny all (deny any) — any traffic not explicitly permitted is dropped</details>

**3.** Where should you place a standard ACL — close to source or destination?

<details><summary>Answer</summary>Close to the **destination**, because standard ACLs only filter on source IP. Placing at source would block that source from reaching ALL destinations.</details>

**4.** What wildcard mask matches the entire 172.16.0.0/16 network?

<details><summary>Answer</summary>0.0.255.255</details>

**5.** What are the three port security violation modes?

<details><summary>Answer</summary>Shutdown (err-disables port), Restrict (drops frames + logs + increments counter), Protect (drops frames silently)</details>

**6.** What is the purpose of DHCP snooping?

<details><summary>Answer</summary>Prevents rogue DHCP servers by dropping DHCP Offers/Acks on untrusted ports. Builds a binding table (MAC ↔ IP ↔ port) used by DAI.</details>

**7.** What does DAI validate?

<details><summary>Answer</summary>ARP packets on untrusted ports — checks that the source MAC + IP in the ARP reply matches the DHCP snooping binding table</details>

**8.** What command generates RSA keys for SSH?

<details><summary>Answer</summary>`crypto key generate rsa modulus 2048` (minimum 1024 bits for SSHv2)</details>

**9.** What is the difference between `enable password` and `enable secret`?

<details><summary>Answer</summary>`enable password` stores the password in cleartext (or weak type 7). `enable secret` hashes it with MD5 (type 5). Always use `enable secret`.</details>

**10.** An extended ACL permits TCP from 10.0.0.0/8 to host 172.16.1.100 on port 443. Write the ACL statement.

<details><summary>Answer</summary>`permit tcp 10.0.0.0 0.255.255.255 host 172.16.1.100 eq 443`</details>

---

**Next → [Week 8 Exercises](exercises.md)**
