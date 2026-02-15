# Week 8 — Exercises: Security Fundamentals

## Table of Contents
- [Part A — Containerlab: ACL Practice with FRR](#part-a--containerlab-acl-practice-with-frr)
  - [Lab CL-1: Packet Filtering with iptables](#lab-cl-1-packet-filtering-with-iptables)
- [Part B — Packet Tracer: Full Security Lab](#part-b--packet-tracer-full-security-lab)
  - [Lab PT-1: Device Hardening and SSH](#lab-pt-1-device-hardening-and-ssh)
  - [Lab PT-2: Standard ACL](#lab-pt-2-standard-acl)
  - [Lab PT-3: Extended ACL](#lab-pt-3-extended-acl)
  - [Lab PT-4: Port Security](#lab-pt-4-port-security)
  - [Lab PT-5: DHCP Snooping and DAI](#lab-pt-5-dhcp-snooping-and-dai)
  - [Lab PT-6: Comprehensive Security Audit](#lab-pt-6-comprehensive-security-audit)

---

## Part A — Containerlab: ACL Practice with FRR

### Lab CL-1: Packet Filtering with iptables

Containerlab uses Linux, so ACL concepts are demonstrated with `iptables` (the Linux equivalent of Cisco ACLs).

**Deploy the topology:**
```bash
cd week-08/lab
sudo containerlab deploy -t topology.yml
```

**Topology:** PC1 → R1 → Server

**Step 1: Verify baseline connectivity**
```bash
docker exec -it clab-week08-pc1 ping -c 3 192.168.2.100
docker exec -it clab-week08-pc1 curl -s http://192.168.2.100 | head -5
```

**Step 2: Block ICMP (ping) from PC1 to Server**
```bash
docker exec -it clab-week08-router1 iptables -A FORWARD -s 192.168.1.0/24 -d 192.168.2.100 -p icmp -j DROP
```

**Step 3: Test — ping should fail, HTTP should still work**
```bash
docker exec -it clab-week08-pc1 ping -c 3 192.168.2.100    # FAIL
docker exec -it clab-week08-pc1 curl -s http://192.168.2.100  # OK
```

**Step 4: Allow only HTTP (port 80), deny everything else to the server**
```bash
# Flush previous rules
docker exec -it clab-week08-router1 iptables -F FORWARD

# Permit HTTP
docker exec -it clab-week08-router1 iptables -A FORWARD -s 192.168.1.0/24 -d 192.168.2.100 -p tcp --dport 80 -j ACCEPT

# Permit return traffic (established connections)
docker exec -it clab-week08-router1 iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Deny everything else to server
docker exec -it clab-week08-router1 iptables -A FORWARD -d 192.168.2.100 -j DROP
```

**Step 5: Verify**
```bash
docker exec -it clab-week08-pc1 curl -s http://192.168.2.100  # OK
docker exec -it clab-week08-pc1 ping -c 3 192.168.2.100        # BLOCKED
```

**Conceptual mapping:**
| iptables | Cisco IOS ACL |
|----------|---------------|
| `-A FORWARD` | Applied to interface |
| `-s 192.168.1.0/24` | `192.168.1.0 0.0.0.255` |
| `-d 192.168.2.100` | `host 192.168.2.100` |
| `-p tcp --dport 80` | `eq 80` |
| `-j ACCEPT` | `permit` |
| `-j DROP` | `deny` |

**Cleanup:**
```bash
sudo containerlab destroy -t topology.yml
```

---

## Part B — Packet Tracer: Full Security Lab

### Lab PT-1: Device Hardening and SSH

**Topology:** PC → Switch → Router (any simple topology)

**Step 1: Basic hardening on the Router**
```
enable
configure terminal

! Set hostname (required for SSH)
hostname R1

! Set enable secret
enable secret Cisco$ecret1

! Console access
line console 0
 password ConsoleP@ss
 login
 exec-timeout 5 0

! Banner
banner motd #WARNING: Authorized access only!#

! Encrypt plaintext passwords
service password-encryption
```

**Step 2: Configure SSH**
```
ip domain-name lab.local
crypto key generate rsa modulus 2048
ip ssh version 2

username admin privilege 15 secret AdminP@ss1

line vty 0 15
 transport input ssh
 login local
 exec-timeout 5 0
```

**Step 3: Verify**
```
show ip ssh
show running-config | include password|secret
```

**Step 4: Test SSH from PC**
Open Command Prompt on PC: `ssh -l admin <router-IP>`

**Step 5: Repeat on the Switch (same commands)**

---

### Lab PT-2: Standard ACL

**Topology:** PC1 (192.168.1.10) and PC2 (192.168.1.20) → Router → Server (192.168.2.100)

**Task:** Block PC1 from reaching the server. Allow PC2.

**Step 1: Create standard ACL**
```
access-list 10 deny host 192.168.1.10
access-list 10 permit any
```

**Step 2: Apply close to DESTINATION (server side)**
```
interface GigabitEthernet0/1
 ip access-group 10 out
```

**Step 3: Test**
- PC1 → Server: `ping 192.168.2.100` → **FAIL**
- PC2 → Server: `ping 192.168.2.100` → **SUCCESS**
- PC1 → Router: `ping 192.168.2.1` → **SUCCESS** (ACL is on server-facing interface)

**Step 4: Check hit counts**
```
show access-lists 10
```

---

### Lab PT-3: Extended ACL

**Topology:** Same as PT-2, add a Web Server and DNS Server on the server subnet.

**Task:** Allow Sales VLAN (192.168.10.0/24):
- HTTP (80) and HTTPS (443) to Web Server (192.168.2.100)
- DNS (53) to DNS Server (192.168.2.200)
- Deny all other traffic from Sales to Server VLAN
- Permit all other traffic

**Step 1: Create named extended ACL**
```
ip access-list extended SALES_POLICY
 permit tcp 192.168.10.0 0.0.0.255 host 192.168.2.100 eq 80
 permit tcp 192.168.10.0 0.0.0.255 host 192.168.2.100 eq 443
 permit udp 192.168.10.0 0.0.0.255 host 192.168.2.200 eq 53
 deny ip 192.168.10.0 0.0.0.255 192.168.2.0 0.0.0.255
 permit ip any any
```

**Step 2: Apply close to SOURCE (Sales VLAN interface)**
```
interface GigabitEthernet0/0
 ip access-group SALES_POLICY in
```

**Step 3: Test**
- Sales PC → Web Server HTTP: Browse to 192.168.2.100 → **ALLOWED**
- Sales PC → Server SSH: → **BLOCKED**
- Sales PC → DNS query: → **ALLOWED**
- IT PC → Server: → **ALLOWED** (permit ip any any at end)

**Step 4: Check ACL statistics**
```
show access-lists SALES_POLICY
```
Each line shows the number of matches (hits).

---

### Lab PT-4: Port Security

**Topology:** Switch with 4 PCs connected to Fa0/1-Fa0/4

**Step 1: Enable port security on Fa0/1**
```
interface FastEthernet0/1
 switchport mode access
 switchport port-security
 switchport port-security maximum 1
 switchport port-security mac-address sticky
 switchport port-security violation shutdown
```

**Step 2: Let PC1 connect (MAC is learned)**
```
show port-security interface FastEthernet0/1
show port-security address
```
Note the sticky MAC address.

**Step 3: Disconnect PC1, connect a different PC to Fa0/1**
→ The port should go **err-disabled**.

**Step 4: Check status**
```
show port-security interface FastEthernet0/1
show interfaces FastEthernet0/1 status
```
Look for `err-disabled` and `SecureShutdown`.

**Step 5: Recover the port**
```
interface FastEthernet0/1
 shutdown
 no shutdown
```

**Step 6: Test Restrict mode**
```
interface FastEthernet0/2
 switchport mode access
 switchport port-security
 switchport port-security maximum 1
 switchport port-security violation restrict
```
Connect a second device → port stays up, but frames from the violating MAC are dropped. Check counters with `show port-security interface Fa0/2`.

---

### Lab PT-5: DHCP Snooping and DAI

**Topology:** Legitimate DHCP Server → Switch (trunk) → Access ports with PCs + Rogue DHCP Server

**Step 1: Enable DHCP snooping**
```
ip dhcp snooping
ip dhcp snooping vlan 10

! Trust the uplink to real DHCP server
interface GigabitEthernet0/1
 ip dhcp snooping trust

! Access ports are untrusted by default
interface range FastEthernet0/1-10
 ip dhcp snooping limit rate 10
```

**Step 2: Test — connect a rogue DHCP server to an untrusted port**
Place a server configured as DHCP on an access port. PCs should NOT receive offers from the rogue server.

**Step 3: Verify**
```
show ip dhcp snooping
show ip dhcp snooping binding
```

**Step 4: Enable DAI**
```
ip arp inspection vlan 10

interface GigabitEthernet0/1
 ip arp inspection trust
```

**Step 5: Verify**
```
show ip arp inspection vlan 10
```

---

### Lab PT-6: Comprehensive Security Audit

**Starting point:** Use any topology from previous weeks.

**Task: Audit and harden everything.**

**Checklist:**
- [ ] All routers/switches have `enable secret` (not `enable password`)
- [ ] `service password-encryption` enabled
- [ ] Console and VTY passwords set
- [ ] SSH configured, Telnet disabled (`transport input ssh`)
- [ ] Banner MOTD configured
- [ ] All unused switch ports shut down and in a "black hole" VLAN
- [ ] Port security on all access ports (sticky, max 2, shutdown)
- [ ] DHCP snooping enabled on access VLANs
- [ ] DAI enabled on access VLANs
- [ ] ACLs applied where needed
- [ ] Native VLAN changed from 1 on all trunks
- [ ] DTP disabled on all ports (`switchport nonegotiate`)

---

**Next → [Week 8 Challenges](challenges.md)**
