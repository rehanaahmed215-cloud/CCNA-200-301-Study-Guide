# Week 7 — Challenges: IP Services (DHCP, DNS, NAT/PAT, NTP, SNMP, Syslog)

## Table of Contents
- [Challenge 1: DHCP Relay Across Multiple Subnets](#challenge-1-dhcp-relay-across-multiple-subnets)
- [Challenge 2: Static NAT + PAT Combined](#challenge-2-static-nat--pat-combined)
- [Challenge 3: Small Office Complete Build](#challenge-3-small-office-complete-build)
- [Challenge 4: DHCP Troubleshooting](#challenge-4-dhcp-troubleshooting)
- [Challenge 5: NAT Translation Table Analysis](#challenge-5-nat-translation-table-analysis)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: DHCP Relay Across Multiple Subnets

**Task:** Build a topology with:
- **R1** = centralized DHCP server (has pools for 3 remote subnets)
- **R2** = relay for VLAN 10 (192.168.10.0/24)
- **R3** = relay for VLAN 20 (192.168.20.0/24)
- **R4** = relay for VLAN 30 (192.168.30.0/24)
- OSPF connecting all routers
- PCs in each VLAN receive DHCP from R1

**Verify:**
- `show ip dhcp binding` on R1 shows leases from all 3 subnets
- PCs can ping each other across VLANs

<details>
<summary><strong>Key configuration</strong></summary>

**On R1 (DHCP Server):**
```
ip dhcp excluded-address 192.168.10.1 192.168.10.10
ip dhcp excluded-address 192.168.20.1 192.168.20.10
ip dhcp excluded-address 192.168.30.1 192.168.30.10

ip dhcp pool VLAN10
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 8.8.8.8

ip dhcp pool VLAN20
 network 192.168.20.0 255.255.255.0
 default-router 192.168.20.1
 dns-server 8.8.8.8

ip dhcp pool VLAN30
 network 192.168.30.0 255.255.255.0
 default-router 192.168.30.1
 dns-server 8.8.8.8
```

The DHCP server determines which pool to use based on the **giaddr** (gateway address) field — the relay router's interface IP tells the server which subnet the client is on.

**On R2/R3/R4 (Relay Agents):**
```
interface GigabitEthernet0/0
 ip helper-address <R1-IP>
```

</details>

---

## Challenge 2: Static NAT + PAT Combined

**Task:** Configure a router with:
1. **Static NAT** for a web server: 192.168.1.100 ↔ 203.0.113.10
2. **Static NAT** for a mail server: 192.168.1.101 ↔ 203.0.113.11
3. **PAT** for all other internal hosts (192.168.1.0/24) using the router's outside interface

**Requirements:**
- External users can reach the web server via 203.0.113.10
- External users can reach the mail server via 203.0.113.11
- Internal users share the router's outside IP (PAT) for internet access
- All three NAT types work simultaneously

**Verify with:**
```
show ip nat translations
show ip nat statistics
```

<details>
<summary><strong>Configuration</strong></summary>

```
! Static NAT for servers
ip nat inside source static 192.168.1.100 203.0.113.10
ip nat inside source static 192.168.1.101 203.0.113.11

! PAT for everyone else
access-list 1 permit 192.168.1.0 0.0.0.255
ip nat inside source list 1 interface GigabitEthernet0/1 overload

! Interfaces
interface GigabitEthernet0/0
 ip nat inside
interface GigabitEthernet0/1
 ip nat outside
```

**Note:** Static NAT entries take priority over PAT. Even though ACL 1 matches the server IPs, the static entries are processed first.

</details>

---

## Challenge 3: Small Office Complete Build

**Task:** Build a complete small office from scratch with ALL IP services:

**Requirements:**
- 2 VLANs: Sales (10) and IT (20)
- Router-on-a-stick for inter-VLAN routing
- DHCP pools on the router for both VLANs
- PAT for internet access (ISP at 203.0.113.1/30)
- NTP: router as master, clients sync time
- Syslog: centralized logging server on IT VLAN
- DNS: router points to 8.8.8.8

**Verification checklist:**
- [ ] Sales PCs get 192.168.10.x via DHCP
- [ ] IT PCs get 192.168.20.x via DHCP
- [ ] Sales can ping IT (inter-VLAN routing works)
- [ ] Both VLANs can reach the ISP (PAT works)
- [ ] `show ntp status` shows synchronized
- [ ] Syslog server receives logs when you shut/no shut an interface
- [ ] `show ip nat translations` shows PAT entries

<details>
<summary><strong>Topology sketch</strong></summary>

```
              [ISP]
                |
          G0/1 (outside)
              [R1] ← NTP master, DHCP server, PAT
          G0/0 (trunk)
              [SW1]
         /          \
    VLAN 10       VLAN 20
   [PC-Sales]   [PC-IT] [Syslog-Server]
```

**Time target:** 45 minutes from a blank topology.

</details>

---

## Challenge 4: DHCP Troubleshooting

**Task:** Your DHCP isn't working. For each scenario below, identify the cause and fix:

**Scenario A:** PCs get 169.254.x.x addresses (APIPA)
- DHCP is configured on the router but PCs can't get addresses

**Scenario B:** PCs get addresses from the wrong pool
- You have two pools; VLAN 10 PCs are getting VLAN 20 addresses

**Scenario C:** DHCP works but PCs can't reach the internet
- PCs have correct IPs and can ping the default gateway

**Scenario D:** Only 5 PCs get addresses, the 6th one fails
- Pool has 254 addresses, excluded range is .1 to .10

<details>
<summary><strong>Answers</strong></summary>

**A:** APIPA means DHCP Discover received no Offer. Likely causes:
- DHCP server interface is down or wrong IP
- `ip helper-address` missing (if server is on another subnet)
- DHCP pool `network` doesn't match the interface subnet
- **Fix:** Check `show ip dhcp pool`, verify interface IP matches pool network

**B:** Wrong pool assignment. The server selects the pool based on the **receiving interface's IP** (or giaddr for relayed requests).
- If the router's VLAN 10 SVI has a VLAN 20 IP → wrong pool selected
- **Fix:** Verify `show ip interface brief` — each SVI must have an IP in its matching DHCP pool's subnet

**C:** DHCP gives IP + gateway but no internet access. Likely causes:
- NAT not configured (`ip nat inside/outside` missing)
- ACL for NAT doesn't match the DHCP-assigned subnet
- Default route to ISP missing
- **Fix:** Check `show ip nat statistics`, verify inside/outside, check `show ip route`

**D:** Only 5 leases despite large pool:
- `ip dhcp excluded-address` range might be too large
- Or there's a network somewhere creating conflicts
- Most likely: check `show ip dhcp pool` — "Total addresses" vs "Leased" vs "Excluded"
- **Fix:** Verify the excluded range, check for IP conflicts with `show ip dhcp conflict`

</details>

---

## Challenge 5: NAT Translation Table Analysis

**Task:** Given this `show ip nat translations` output, answer the questions below:

```
Pro Inside global     Inside local      Outside local     Outside global
tcp 203.0.113.1:1024 192.168.1.10:4500 8.8.8.8:53       8.8.8.8:53
tcp 203.0.113.1:1025 192.168.1.20:4600 93.184.216.34:80  93.184.216.34:80
--- 203.0.113.10     192.168.1.100     ---               ---
tcp 203.0.113.1:1026 192.168.1.30:5000 93.184.216.34:443 93.184.216.34:443
```

**Questions:**
1. Which type of NAT is the third entry (203.0.113.10)?
2. How many hosts are using PAT?
3. What is the public IP shared by PAT users?
4. What website is 192.168.1.20 accessing? (hint: port 80)
5. What service is 192.168.1.10 using? (hint: port 53)

<details>
<summary><strong>Answers</strong></summary>

1. **Static NAT** — no port number, permanent mapping (192.168.1.100 ↔ 203.0.113.10)
2. **3 hosts** — 192.168.1.10, 192.168.1.20, and 192.168.1.30 (all using 203.0.113.1 with different ports)
3. **203.0.113.1** (the router's outside interface IP)
4. **HTTP (web browsing)** — port 80 to 93.184.216.34 (this is example.com)
5. **DNS** — port 53 to 8.8.8.8 (Google's DNS server)

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. DHCP relay (3 subnets) | ⭐⭐ Medium | 25 minutes |
| 2. Static NAT + PAT combo | ⭐⭐ Medium | 20 minutes |
| 3. Small office complete | ⭐⭐⭐ Hard | 45 minutes |
| 4. DHCP troubleshooting | ⭐⭐ Medium | 15 minutes |
| 5. NAT table analysis | ⭐ Easy | 10 minutes |

---

**Week 7 complete! → [Start Week 8](../week-08/concepts.md)**
