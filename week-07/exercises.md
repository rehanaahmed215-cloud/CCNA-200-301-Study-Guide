# Week 7 — Exercises: IP Services (DHCP, DNS, NAT/PAT, NTP, SNMP, Syslog)

## Table of Contents
- [Part A — Containerlab: DHCP and NAT with FRR](#part-a--containerlab-dhcp-and-nat-with-frr)
  - [Lab CL-1: DHCP Server with dnsmasq](#lab-cl-1-dhcp-server-with-dnsmasq)
  - [Lab CL-2: NAT/PAT with iptables](#lab-cl-2-natpat-with-iptables)
- [Part B — Packet Tracer: Full IP Services](#part-b--packet-tracer-full-ip-services)
  - [Lab PT-1: Router as DHCP Server](#lab-pt-1-router-as-dhcp-server)
  - [Lab PT-2: DHCP Relay Agent](#lab-pt-2-dhcp-relay-agent)
  - [Lab PT-3: PAT Configuration](#lab-pt-3-pat-configuration)
  - [Lab PT-4: Static NAT for a Web Server](#lab-pt-4-static-nat-for-a-web-server)
  - [Lab PT-5: NTP Configuration](#lab-pt-5-ntp-configuration)
  - [Lab PT-6: Syslog Configuration](#lab-pt-6-syslog-configuration)

---

## Part A — Containerlab: DHCP and NAT with FRR

### Lab CL-1: DHCP Server with dnsmasq

**Deploy the topology:**
```bash
cd week-07/lab
containerlab deploy -t topology.yml
```

The topology includes a router (R1) with dnsmasq running as a DHCP server for LAN hosts.

> **Tip — Connecting to nodes:**
> Use `lab <node>` to open a shell inside a container. All commands below assume you are **inside** the container's shell.
>
> ```bash
> lab router1      # opens a shell on R1
> lab pc1          # opens a shell on PC1
> lab --all        # opens a tab for every node
> ```

**On R1** (`lab router1`):
```bash
ps aux | grep dnsmasq
```

**On PC1** (`lab pc1`) — check if client received an IP:
```bash
ip addr show eth1
```
The client should have been assigned an IP from the 192.168.1.0/24 pool.

**On PC1** — manually request a DHCP lease (if needed):
```bash
dhclient eth1
ip addr show eth1
```

**On R1** — check DHCP leases on the server:
```bash
cat /var/lib/misc/dnsmasq.leases
```

**On PC1** — verify connectivity:
```bash
ping -c 3 192.168.1.1
```

---

### Lab CL-2: NAT/PAT with iptables

This lab demonstrates PAT using Linux iptables (the real-world equivalent of Cisco PAT).

**On R1** (`lab router1`) — configure PAT (masquerade):
```bash
iptables -t nat -A POSTROUTING -o eth2 -s 192.168.1.0/24 -j MASQUERADE
```

**On R1** — verify the NAT rule:
```bash
iptables -t nat -L -v
```

**On PC1** (`lab pc1`) — access the "internet" (R1's outside network):
```bash
ping -c 3 10.0.0.2
```

**On R1** — watch NAT translations:
```bash
conntrack -L 2>/dev/null || cat /proc/net/nf_conntrack
```

**Conceptual mapping to Cisco:**
| Linux (iptables) | Cisco IOS |
|-------------------|-----------|
| `-j MASQUERADE` | `ip nat inside source list 1 interface Gig0/1 overload` |
| `-o eth2` | `ip nat outside` on the exit interface |
| `-s 192.168.1.0/24` | `access-list 1 permit 192.168.1.0 0.0.0.255` |
| `conntrack -L` | `show ip nat translations` |

**Cleanup:** Exit all container shells, then from your Mac terminal:
```bash
lab destroy
```

---

## Part B — Packet Tracer: Full IP Services

### Lab PT-1: Router as DHCP Server

**Topology:** Router R1 → Switch → 3 PCs (set to DHCP)

**Step 1: Configure R1 as DHCP server**
```
ip dhcp excluded-address 192.168.10.1 192.168.10.10
ip dhcp pool SALES
 network 192.168.10.0 255.255.255.0
 default-router 192.168.10.1
 dns-server 8.8.8.8
 domain-name sales.local
 lease 7

interface GigabitEthernet0/0
 ip address 192.168.10.1 255.255.255.0
 no shutdown
```

**Step 2: Set PCs to DHCP**
On each PC: Desktop → IP Configuration → DHCP

**Step 3: Verify**
```
show ip dhcp binding                        ← see assigned addresses
show ip dhcp pool                           ← pool utilization
show ip dhcp server statistics              ← DORA counters
```

**Step 4: Use Simulation Mode**
Filter for DHCP → watch the DORA process: Discover (broadcast), Offer, Request, Acknowledge.

---

### Lab PT-2: DHCP Relay Agent

**Topology:** R1 (DHCP server, 10.0.0.1/30) ─── R2 (relay, 10.0.0.2/30 & 192.168.20.1/24) ─── Switch ─── PCs

The DHCP server is on R1, but clients are on R2's LAN.

**Step 1: Configure DHCP pool on R1 for the remote subnet**
```
ip dhcp excluded-address 192.168.20.1 192.168.20.10
ip dhcp pool REMOTE_LAN
 network 192.168.20.0 255.255.255.0
 default-router 192.168.20.1
 dns-server 8.8.8.8
```

**Step 2: Configure R2 as relay agent**
```
interface GigabitEthernet0/0
 ip address 192.168.20.1 255.255.255.0
 ip helper-address 10.0.0.1                ← R1's IP (the DHCP server)
 no shutdown
```

**Step 3: Ensure routing**
R1 needs a route back to 192.168.20.0/24, and R2 needs a route to R1.

**Step 4: Set PCs to DHCP and verify they get 192.168.20.x addresses**

**Step 5: On R1, verify**
```
show ip dhcp binding
```
You should see leases in the 192.168.20.0/24 range even though R1 is on a different subnet.

---

### Lab PT-3: PAT Configuration

**Topology:** Internal LAN (192.168.1.0/24) → R1 → ISP (203.0.113.0/30)

**Step 1: Configure interfaces**
```
interface GigabitEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 ip nat inside
 no shutdown

interface GigabitEthernet0/1
 ip address 203.0.113.2 255.255.255.252
 ip nat outside
 no shutdown
```

**Step 2: Configure PAT**
```
access-list 1 permit 192.168.1.0 0.0.0.255
ip nat inside source list 1 interface GigabitEthernet0/1 overload
```

**Step 3: Add default route to ISP**
```
ip route 0.0.0.0 0.0.0.0 203.0.113.1
```

**Step 4: From PCs, ping 203.0.113.1 (ISP router)**

**Step 5: Verify NAT translations**
```
show ip nat translations
show ip nat statistics
```

Note: All internal IPs translate to 203.0.113.2 with different port numbers.

**Step 6: Clear translations and test again**
```
clear ip nat translation *
```

---

### Lab PT-4: Static NAT for a Web Server

**Add to the Lab PT-3 topology:** An internal web server at 192.168.1.100.

**Step 1: Configure static NAT**
```
ip nat inside source static 192.168.1.100 203.0.113.10
```

**Step 2: On the ISP router, add a route to 203.0.113.10**
```
ip route 203.0.113.10 255.255.255.255 203.0.113.2
```

**Step 3: From the ISP router (or an outside PC), access the web server**
```
ping 203.0.113.10
```

**Step 4: Verify**
```
show ip nat translations
```
You should see a permanent static entry: `192.168.1.100 ↔ 203.0.113.10`.

---

### Lab PT-5: NTP Configuration

**Step 1: Configure R1 as NTP master**
```
ntp master 3
clock timezone EST -5
```

**Step 2: Configure R2 and R3 as NTP clients**
```
ntp server 10.0.12.1                        ← R1's WAN IP
```

**Step 3: Verify synchronization (wait 1-2 minutes)**
```
show ntp status
show ntp associations
show clock
```

Look for:
- `Clock is synchronized` on R2/R3
- Stratum level = 4 (one more than R1's stratum 3)
- Reference peer = R1's IP

---

### Lab PT-6: Syslog Configuration

**Step 1: Add a Syslog server (use a generic server in Packet Tracer)**
- Place a Server on the LAN
- Enable Syslog service on the Server (Services → Syslog)

**Step 2: Configure routers to send logs**
```
logging host 192.168.1.200                  ← Syslog server IP
logging trap informational                  ← Send levels 0-6
service timestamps log datetime msec        ← Add timestamps
```

**Step 3: Generate some log messages**
```
interface GigabitEthernet0/0
 shutdown
 no shutdown
```

**Step 4: Check the Syslog server**
Go to Server → Services → Syslog → view received messages.

**Step 5: Check local log buffer**
```
show logging
```

---

**Next → [Week 7 Challenges](challenges.md)**
