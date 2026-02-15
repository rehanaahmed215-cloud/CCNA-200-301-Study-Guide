# Week 8 — Challenges: Security Fundamentals

## Table of Contents
- [Challenge 1: Write the ACL — Sales VLAN Policy](#challenge-1-write-the-acl--sales-vlan-policy)
- [Challenge 2: DHCP Snooping Attack Test](#challenge-2-dhcp-snooping-attack-test)
- [Challenge 3: Security Audit and Remediation](#challenge-3-security-audit-and-remediation)
- [Challenge 4: ACL Troubleshooting](#challenge-4-acl-troubleshooting)
- [Challenge 5: Full Secure Network Build](#challenge-5-full-secure-network-build)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Write the ACL — Sales VLAN Policy

**Scenario:** You manage a network with these VLANs:
- **VLAN 10 (Sales):** 192.168.10.0/24
- **VLAN 20 (IT):** 192.168.20.0/24  
- **VLAN 30 (Servers):** 10.0.0.0/24 — contains:
  - File Server: 10.0.0.10 (port 445 SMB)
  - Web Server: 10.0.0.20 (ports 80, 443)
  - DNS Server: 10.0.0.30 (port 53)

**Policy:**
1. Sales can access the File Server on port 445 **only**
2. Sales can access the Web Server on ports 80 and 443
3. Sales can use DNS
4. **Deny all other traffic from Sales to the Server VLAN**
5. IT has **full access** to everything
6. All other traffic is permitted

Write the complete named extended ACL and specify where to apply it.

<details>
<summary><strong>Answer</strong></summary>

```
ip access-list extended SALES_SECURITY
 ! 1. Sales → File Server SMB
 permit tcp 192.168.10.0 0.0.0.255 host 10.0.0.10 eq 445
 ! 2. Sales → Web Server HTTP/HTTPS
 permit tcp 192.168.10.0 0.0.0.255 host 10.0.0.20 eq 80
 permit tcp 192.168.10.0 0.0.0.255 host 10.0.0.20 eq 443
 ! 3. Sales → DNS
 permit udp 192.168.10.0 0.0.0.255 host 10.0.0.30 eq 53
 ! 4. Deny ALL other Sales → Server traffic
 deny ip 192.168.10.0 0.0.0.255 10.0.0.0 0.0.0.255
 ! 5+6. IT and all other traffic permitted
 permit ip any any
```

**Apply close to source (Sales VLAN interface):**
```
interface GigabitEthernet0/0.10          ← Sales sub-interface
 ip access-group SALES_SECURITY in
```

**Why this works:**
- Lines 1-4 handle Sales specifically
- Line 5 blocks everything else from Sales to Servers
- Line 6 allows IT and all other traffic (IT is not in 192.168.10.0/24, so line 5 doesn't affect IT)
- The implicit deny at the end doesn't matter because of "permit ip any any"

</details>

---

## Challenge 2: DHCP Snooping Attack Test

**Task:** In Packet Tracer:

1. Build a switch with DHCP snooping **disabled**
2. Place a legitimate DHCP server on one port and a rogue DHCP server on another
3. Connect a PC and observe — which DHCP server does it get an IP from? (race condition!)
4. **Enable DHCP snooping**, trust only the legitimate server's port
5. Test again — the rogue server's offers should be blocked

**Document:**
- What addresses did the PC receive in each scenario?
- What `show` commands prove snooping is working?
- What would happen to users if the rogue DHCP gave them a bad default gateway?

<details>
<summary><strong>Answer</strong></summary>

**Without snooping:** The PC may receive an address from either DHCP server (whichever responds first). A rogue server can provide:
- Wrong default gateway (MitM attack — traffic routed through attacker)
- Wrong DNS server (DNS poisoning — redirect to phishing sites)
- Invalid IP (DoS — device can't communicate)

**With snooping:**
```
show ip dhcp snooping                      ← shows trusted/untrusted ports
show ip dhcp snooping binding              ← valid bindings from trusted server only
```

The switch drops DHCP Offers from untrusted ports → rogue server is ineffective.

**Real-world impact:** Without DHCP snooping, an attacker with a $50 device could redirect all traffic on a VLAN through their machine, capturing credentials, modifying data, etc.

</details>

---

## Challenge 3: Security Audit and Remediation

**Task:** You receive this `show running-config` excerpt. Find ALL security issues and write the fix for each.

```
hostname Router
!
enable password cisco
!
line console 0
 no password
 no login
!
line vty 0 15
 password cisco
 login
 transport input telnet ssh
!
interface GigabitEthernet0/0
 ip address 192.168.1.1 255.255.255.0
!
no service password-encryption
```

<details>
<summary><strong>Answer — Issues found</strong></summary>

| # | Issue | Fix |
|---|-------|-----|
| 1 | `enable password` (plaintext) | `no enable password` → `enable secret Str0ngP@ss` |
| 2 | Console has no password | `line console 0` → `password <strong>` → `login` |
| 3 | VTY password is weak ("cisco") | Change to strong password |
| 4 | Telnet enabled (`transport input telnet ssh`) | `transport input ssh` (remove telnet) |
| 5 | No SSH configured (no hostname change, no domain, no keys) | Configure SSH: domain, RSA keys, local user, `login local` |
| 6 | `no service password-encryption` | `service password-encryption` |
| 7 | No banner | `banner motd #Authorized access only#` |
| 8 | No exec-timeout | `exec-timeout 5 0` on console and vty |
| 9 | Hostname is default "Router" | Change to descriptive name (also needed for SSH) |

**Complete remediation:**
```
hostname R1-EDGE
enable secret Str0ngP@ss!1
service password-encryption
banner motd #AUTHORIZED ACCESS ONLY#
ip domain-name company.local
crypto key generate rsa modulus 2048
username admin privilege 15 secret AdminP@ss1

line console 0
 password C0nsole$ecure
 login
 exec-timeout 5 0

line vty 0 15
 transport input ssh
 login local
 exec-timeout 5 0
```

</details>

---

## Challenge 4: ACL Troubleshooting

**Task:** The following ACL is applied but isn't working as expected. Users in 10.0.0.0/24 should be able to browse the web (HTTP/HTTPS) but nothing else. However, EVERYTHING is blocked.

```
ip access-list extended WEB_ONLY
 deny ip 10.0.0.0 0.0.0.255 any
 permit tcp 10.0.0.0 0.0.0.255 any eq 80
 permit tcp 10.0.0.0 0.0.0.255 any eq 443

interface GigabitEthernet0/0
 ip access-group WEB_ONLY in
```

Find and fix the problem.

<details>
<summary><strong>Answer</strong></summary>

**Problem:** The `deny ip` statement is **first** and matches ALL traffic from 10.0.0.0/24 (including HTTP/HTTPS). ACLs are processed top-down, first match wins — so the permit lines are never reached.

**Fix — reorder the ACL:**
```
ip access-list extended WEB_ONLY
 no 10                                      ← remove the deny line
 no 20
 no 30
 10 permit tcp 10.0.0.0 0.0.0.255 any eq 80
 20 permit tcp 10.0.0.0 0.0.0.255 any eq 443
 30 deny ip 10.0.0.0 0.0.0.255 any
```

Or recreate:
```
no ip access-list extended WEB_ONLY
ip access-list extended WEB_ONLY
 permit tcp 10.0.0.0 0.0.0.255 any eq 80
 permit tcp 10.0.0.0 0.0.0.255 any eq 443
 deny ip 10.0.0.0 0.0.0.255 any
```

**Also note:** You may need to add `permit ip any any` at the end if you want traffic from other subnets to pass through.

**Key takeaway:** ACL order matters! Put specific permits BEFORE broad denies.

</details>

---

## Challenge 5: Full Secure Network Build

**Task:** Build a complete secured network from scratch in Packet Tracer:

**Topology:**
- 2 VLANs (Sales, IT) with inter-VLAN routing
- 1 Server VLAN
- Internet connection (simulated ISP)

**Security requirements:**
1. SSH-only management, Telnet disabled
2. Strong passwords, `enable secret`, `service password-encryption`
3. Port security on all access ports (sticky, max 2, shutdown)
4. Extended ACL: Sales → Server: HTTP only; IT → Server: full access
5. DHCP snooping enabled
6. DAI enabled
7. PAT for internet access
8. All unused ports shut down
9. Native VLAN changed to 99
10. DTP disabled on all ports

**Time target:** 60 minutes.

<details>
<summary><strong>Verification checklist</strong></summary>

```
! On all devices:
show ip ssh                                 ← SSH enabled
show running-config | include secret        ← enable secret present
show running-config | include transport     ← transport input ssh

! On switches:
show port-security                          ← all access ports secured
show ip dhcp snooping                       ← enabled
show ip arp inspection vlan 10,20           ← enabled
show interfaces trunk                       ← native vlan 99
show interfaces status                      ← unused ports disabled

! On router:
show access-lists                           ← ACL configured correctly
show ip nat translations                    ← PAT entries visible
```

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Write the ACL | ⭐⭐ Medium | 15 minutes |
| 2. DHCP snooping test | ⭐⭐ Medium | 20 minutes |
| 3. Security audit | ⭐⭐ Medium | 15 minutes |
| 4. ACL troubleshooting | ⭐⭐ Medium | 10 minutes |
| 5. Full secure build | ⭐⭐⭐ Hard | 60 minutes |

---

**Week 8 complete! → [Start Week 9](../week-09/concepts.md)**
