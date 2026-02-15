# Week 1 — Challenges: OSI & TCP/IP Models

## Table of Contents
- [Challenge 1: Draw the OSI Model from Memory](#challenge-1-draw-the-osi-model-from-memory)
- [Challenge 2: Trace a Ping — Full Layer-by-Layer Write-Up](#challenge-2-trace-a-ping--full-layer-by-layer-write-up)
- [Challenge 3: Frame at a Switch vs. Packet at a Router](#challenge-3-frame-at-a-switch-vs-packet-at-a-router)
- [Challenge 4: Protocol Identification Drill](#challenge-4-protocol-identification-drill)
- [Challenge 5: Build and Break — Troubleshooting Lab](#challenge-5-build-and-break--troubleshooting-lab)
- [Scoring Guide](#scoring-guide)

---

These challenges are designed to be completed **without looking at your notes**. Try each one independently before checking your work.

---

## Challenge 1: Draw the OSI Model from Memory

**Task:** On a piece of paper (or whiteboard), draw the complete OSI model and fill in:

| Layer # | Layer Name | PDU | Key Protocols | Devices |
|---------|-----------|-----|---------------|---------|
| 7 | ? | ? | ? | ? |
| 6 | ? | ? | ? | ? |
| 5 | ? | ? | ? | ? |
| 4 | ? | ? | ? | ? |
| 3 | ? | ? | ? | ? |
| 2 | ? | ? | ? | ? |
| 1 | ? | ? | ? | ? |

**Success criteria:** Complete the entire table without any references in under 3 minutes.

<details>
<summary><strong>Check your answer</strong></summary>

| Layer # | Layer Name | PDU | Key Protocols | Devices |
|---------|-----------|-----|---------------|---------|
| 7 | Application | Data | HTTP, HTTPS, DNS, DHCP, FTP, SSH, SMTP, SNMP | — |
| 6 | Presentation | Data | SSL/TLS, JPEG, ASCII | — |
| 5 | Session | Data | NetBIOS, RPC | — |
| 4 | Transport | Segment/Datagram | TCP, UDP | — |
| 3 | Network | Packet | IP, ICMP, ARP, OSPF | Router, L3 Switch |
| 2 | Data Link | Frame | Ethernet (802.3), Wi-Fi (802.11) | Switch, Bridge |
| 1 | Physical | Bits | — (cables, signals) | Hub, Repeater, Cables |

</details>

---

## Challenge 2: Trace a Ping — Full Layer-by-Layer Write-Up

**Scenario:** PC-A (192.168.1.10, MAC: AA:AA:AA:AA:AA:AA) pings PC-B (192.168.1.20, MAC: BB:BB:BB:BB:BB:BB). They are on the same subnet, connected via a switch.

**Task:** Write a detailed, step-by-step explanation of what happens at **every OSI layer** from the moment the ping command is entered until the reply is received. Include:

- What happens at each layer on the **sending** side
- What the **switch** does when it receives the frame
- What happens at each layer on the **receiving** side
- What happens with the **reply**

**Minimum detail:** Mention ARP (if needed), ICMP type codes, encapsulation/de-encapsulation, MAC address table lookups.

<details>
<summary><strong>Check your answer</strong></summary>

**Sending Side (PC-A):**

1. **L7 (Application):** The `ping` command invokes ICMP — no application layer protocol per se, but the OS generates the request.

2. **L4 (Transport):** ICMP doesn't use TCP or UDP. It is encapsulated directly in IP. (Some exam materials show it at L3; the key point is it's an IP protocol, protocol number 1.)

3. **L3 (Network):** 
   - PC-A creates an ICMP Echo Request (Type 8, Code 0)
   - Source IP: 192.168.1.10, Destination IP: 192.168.1.20
   - PC-A checks: "Is 192.168.1.20 on my subnet?" → Same /24 → Yes, deliver directly (no router needed)
   - PC-A checks ARP cache for 192.168.1.20's MAC address

4. **L3/L2 (ARP — if MAC not cached):**
   - PC-A sends ARP Request: "Who has 192.168.1.20? Tell 192.168.1.10"
   - ARP Request is broadcast: Dest MAC = FF:FF:FF:FF:FF:FF
   - Switch floods ARP to all ports
   - PC-B receives, replies: "192.168.1.20 is at BB:BB:BB:BB:BB:BB"
   - PC-A caches the mapping

5. **L2 (Data Link):**
   - PC-A builds an Ethernet frame:
     - Dest MAC: BB:BB:BB:BB:BB:BB
     - Source MAC: AA:AA:AA:AA:AA:AA
     - EtherType: 0x0800 (IPv4)
     - Payload: IP packet containing ICMP Echo Request
     - FCS: Frame Check Sequence (error detection)

6. **L1 (Physical):** Frame converted to electrical signals (or light/radio) and sent on the wire.

**Switch:**
- Receives frame on port Fa0/1
- Reads **source MAC** (AA:AA:AA:AA:AA:AA) → adds to MAC address table mapped to Fa0/1
- Reads **destination MAC** (BB:BB:BB:BB:BB:BB) → looks up in MAC table
  - If found → forwards to that specific port only
  - If not found → floods to all ports except source
- Switch operates at **Layer 2 only** — it does NOT look at IP addresses

**Receiving Side (PC-B):**
1. **L1:** Receives electrical signals, converts to bits
2. **L2:** Reads Ethernet frame, checks dest MAC = own MAC → accepts. Strips Ethernet header, passes IP packet up.
3. **L3:** Reads IP header, sees ICMP Echo Request → generates ICMP Echo Reply (Type 0, Code 0)
4. **L2:** Builds reply frame with reversed MAC addresses
5. **L1:** Sends the reply

**Reply reaches PC-A** → de-encapsulated → ping reports "Reply from 192.168.1.20, time=X ms"

</details>

---

## Challenge 3: Frame at a Switch vs. Packet at a Router

**Task:** Research and write a comparison answering these questions:

1. When a frame arrives at a **switch**, what does the switch examine and what decision does it make?
2. When a packet arrives at a **router**, what does the router examine and what decision does it make?
3. What happens to the **frame** when a packet crosses a router? (Does it stay the same? Change? Why?)

Write at least one paragraph for each question.

<details>
<summary><strong>Check your answer</strong></summary>

**1. Switch behavior:**
A switch examines the **Layer 2 Ethernet frame header** — specifically the **destination MAC address**. It looks up this MAC in its **MAC address table** (also called CAM table). If the MAC is found, the switch forwards the frame **only to the port** associated with that MAC. If the MAC is not found, the switch **floods** the frame to all ports except the one it arrived on. The switch also learns the **source MAC address** and maps it to the ingress port. A switch does NOT examine IP addresses — it has no concept of Layer 3.

**2. Router behavior:**
A router examines the **Layer 3 IP packet header** — specifically the **destination IP address**. It performs a **longest prefix match** lookup in its **routing table** to determine the best next-hop and exit interface. The router then decrements the **TTL** (Time to Live) by 1. If TTL reaches 0, the router drops the packet and sends an ICMP "Time Exceeded" message. If no matching route exists, the router drops the packet (unless a default route exists).

**3. Frame rewrite at routers:**
When a packet crosses a router, the **original Layer 2 frame is discarded** and a **new frame is created**. The router strips the incoming frame header, processes the IP packet, determines the next hop, and builds a new Ethernet frame with:
- **New source MAC:** The router's exit interface MAC
- **New destination MAC:** The next-hop's MAC (found via ARP)

The IP packet inside remains mostly unchanged (only TTL decrements and header checksum is recalculated). This is why MAC addresses are "local" to each network segment, while IP addresses are "end-to-end."

</details>

---

## Challenge 4: Protocol Identification Drill

**Task:** For each scenario, identify which protocols are involved and at which layers:

1. You type `ssh admin@10.0.0.1` in your terminal
2. Your laptop connects to Wi-Fi and gets an IP address automatically
3. You browse to `http://www.cisco.com`
4. A network monitoring system polls a router for CPU usage
5. You transfer a file using `ftp 10.0.0.5`

<details>
<summary><strong>Check your answer</strong></summary>

**1. SSH to a device:**
- L7: SSH (port 22)
- L6: Encryption (SSH handles its own encryption)
- L4: TCP (connection-oriented)
- L3: IP (destination: 10.0.0.1)
- L2: Ethernet/Wi-Fi (MAC addressing)
- L1: Physical transmission

**2. Wi-Fi connection + DHCP:**
- L1/L2: 802.11 (Wi-Fi association, authentication)
- L3/L7: DHCP (Discover → Offer → Request → Acknowledge)
  - DHCP uses UDP ports 67 (server) and 68 (client)
  - Client broadcasts DHCP Discover (no IP yet, uses 0.0.0.0 as source)
- L3: ARP (after receiving IP, client may do Gratuitous ARP)

**3. Browsing HTTP:**
- L7: DNS (resolves www.cisco.com to IP) then HTTP (port 80)
- L4: UDP (DNS query), then TCP (HTTP connection, 3-way handshake)
- L3: IP routing to destination
- L2: Ethernet framing
- L1: Physical

**4. Network monitoring:**
- L7: SNMP (Simple Network Management Protocol, port 161)
- L4: UDP
- L3: IP
- L2/L1: Ethernet

**5. FTP file transfer:**
- L7: FTP (port 21 for control, port 20 for data)
- L4: TCP (reliable transfer required for files)
- L3: IP
- L2/L1: Ethernet

</details>

---

## Challenge 5: Build and Break — Troubleshooting Lab

**Task:** Deploy the Week 1 Containerlab topology, then:

1. **Configure everything correctly** — both PCs should be able to ping each other
2. **Intentionally break it** in three different ways (one at a time):
   - Assign PCs to different subnets (e.g., 192.168.1.10/24 and 192.168.2.20/24)
   - Remove the IP address from one PC
   - Bring down the interface on one PC (`ip link set eth1 down`)
3. For each break, **predict** what will happen before testing, then **verify** with ping and tcpdump
4. **Fix** each issue and verify connectivity is restored

**Document for each scenario:**
- What you broke
- What you predicted would happen
- What actually happened (error messages, tcpdump output)
- What OSI layer the problem exists at
- How you fixed it

<details>
<summary><strong>Hints</strong></summary>

- Different subnets → L3 problem. Ping will fail because ARP won't find the destination (not on the same broadcast domain without a router).
- No IP address → L3 problem. The host can't construct an IP packet.
- Interface down → L1 problem. No physical connectivity. You'll see "Network is unreachable" immediately.

Use `tcpdump -i eth1 -n` on both hosts to see exactly where communication breaks down.

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. OSI from memory | ⭐ Easy | 3 minutes |
| 2. Trace a ping | ⭐⭐ Medium | 20 minutes |
| 3. Switch vs. Router | ⭐⭐ Medium | 15 minutes |
| 4. Protocol drill | ⭐ Easy | 10 minutes |
| 5. Build and break | ⭐⭐⭐ Hard | 30 minutes |

**Target:** Complete all challenges in under 90 minutes total.

---

**Week 1 complete! → [Start Week 2](../week-02/concepts.md)**
