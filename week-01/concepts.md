# Week 1 — Network Fundamentals: OSI & TCP/IP Models

## Table of Contents
- [Learning Objectives](#learning-objectives)
- [1. The OSI Model](#1-the-osi-model-open-systems-interconnection)
- [2. The TCP/IP Model](#2-the-tcpip-model)
- [3. Encapsulation & De-encapsulation](#3-encapsulation--de-encapsulation)
- [4. Common Protocols by Layer](#4-common-protocols-by-layer)
- [5. Devices at Each Layer](#5-devices-at-each-layer)
- [Quiz — Test Your Understanding](#quiz--test-your-understanding)
- [Key Takeaways](#key-takeaways)

---

## Learning Objectives

By the end of this week, you should be able to:
- Name and describe all 7 layers of the OSI model
- Map the OSI model to the TCP/IP 4-layer model
- Explain encapsulation and de-encapsulation with correct PDU names
- Identify common protocols at each layer
- Describe how data flows from application to wire and back

---

## 1. The OSI Model (Open Systems Interconnection)

The OSI model is a **conceptual framework** that standardizes how network communication works. It divides networking into **7 layers**, each with a specific responsibility.

### Layer 7 — Application
- **What it does:** Provides network services directly to end-user applications
- **Key protocols:** HTTP, HTTPS, FTP, SMTP, DNS, DHCP, Telnet, SSH, SNMP
- **PDU name:** Data
- **Think of it as:** The interface between the user and the network

> **Important:** The Application layer is NOT the application itself (e.g., Chrome). It's the *protocol* the application uses (e.g., HTTP).

### Layer 6 — Presentation
- **What it does:** Translates data formats, encryption/decryption, compression
- **Examples:** SSL/TLS encryption, JPEG/PNG encoding, ASCII/Unicode translation
- **PDU name:** Data
- **Think of it as:** The translator — makes sure both sides understand the data format

### Layer 5 — Session
- **What it does:** Manages sessions (establishing, maintaining, terminating connections)
- **Examples:** NetBIOS, RPC, SQL sessions
- **PDU name:** Data
- **Think of it as:** The conversation manager — "Let's start talking... still there?... OK, goodbye"

### Layer 4 — Transport
- **What it does:** End-to-end communication, segmentation, flow control, error recovery
- **Key protocols:**
  - **TCP** (Transmission Control Protocol) — reliable, connection-oriented, uses three-way handshake (SYN, SYN-ACK, ACK)
  - **UDP** (User Datagram Protocol) — unreliable, connectionless, faster
- **PDU name:** **Segment** (TCP) or **Datagram** (UDP)
- **Key concept:** Port numbers (HTTP=80, HTTPS=443, SSH=22, DNS=53, DHCP=67/68)

#### TCP vs. UDP

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Connection-oriented (3-way handshake) | Connectionless |
| Reliability | Guaranteed delivery (ACKs, retransmission) | Best-effort (no ACKs) |
| Ordering | Sequence numbers ensure order | No ordering |
| Speed | Slower (overhead) | Faster (less overhead) |
| Use cases | HTTP, SSH, FTP, email | DNS, DHCP, VoIP, video streaming |

### Layer 3 — Network
- **What it does:** Logical addressing (IP addresses) and routing between networks
- **Key protocols:** IP (IPv4, IPv6), ICMP, OSPF, EIGRP, BGP, ARP*
- **PDU name:** **Packet**
- **Devices:** Routers, Layer 3 switches
- **Think of it as:** The GPS — determines the best path from source to destination

> *ARP operates between L2 and L3. Some references place it at L2.

### Layer 2 — Data Link
- **What it does:** Physical addressing (MAC addresses), frame creation, error detection
- **Sub-layers:**
  - **LLC** (Logical Link Control) — interfaces with Layer 3
  - **MAC** (Media Access Control) — deals with hardware addressing
- **Key protocols:** Ethernet (802.3), Wi-Fi (802.11), PPP, HDLC
- **PDU name:** **Frame**
- **Devices:** Switches, bridges, NICs
- **Key concept:** MAC addresses are 48-bit, written as `AA:BB:CC:DD:EE:FF`

### Layer 1 — Physical
- **What it does:** Transmits raw bits over physical media
- **Examples:** Cables (Cat5e, Cat6, fiber), connectors (RJ-45), signals (electrical, optical, radio)
- **PDU name:** **Bits**
- **Devices:** Hubs, repeaters, cables, NICs (physical aspect)
- **Key concept:** Defines speeds, voltages, pin layouts, cable types

### Memory Aid: OSI Layer Mnemonics

**Top-down (7→1):** **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing  
**Bottom-up (1→7):** **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way

---

## 2. The TCP/IP Model

The TCP/IP model is the **practical, real-world** model that the Internet actually uses. It has **4 layers** (sometimes shown as 5).

| TCP/IP Layer | OSI Equivalent | Protocols |
|-------------|----------------|-----------|
| **Application** | Application + Presentation + Session (L7+L6+L5) | HTTP, DNS, DHCP, SSH, FTP |
| **Transport** | Transport (L4) | TCP, UDP |
| **Internet** | Network (L3) | IP, ICMP, ARP |
| **Network Access** | Data Link + Physical (L2+L1) | Ethernet, Wi-Fi |

### Key Differences: OSI vs. TCP/IP

| OSI | TCP/IP |
|-----|--------|
| 7 layers | 4 layers |
| Theoretical/reference model | Practical/implemented model |
| Developed by ISO | Developed by DoD/DARPA |
| Layers 5-7 are distinct | Layers 5-7 merged into "Application" |

---

## 3. Encapsulation & De-encapsulation

When data travels **down** the OSI model (sender side), each layer adds its own **header** (and sometimes trailer). This is called **encapsulation**.

```
Application Layer    →  DATA
Transport Layer      →  [TCP Header] + DATA               = SEGMENT
Network Layer        →  [IP Header] + SEGMENT             = PACKET
Data Link Layer      →  [Frame Header] + PACKET + [FCS]   = FRAME
Physical Layer       →  101010001110010...                 = BITS
```

When data travels **up** the OSI model (receiver side), each layer **strips its header** and passes the payload up. This is **de-encapsulation**.

### PDU Summary

| Layer | PDU Name |
|-------|----------|
| L7-L5 | Data |
| L4 | Segment (TCP) / Datagram (UDP) |
| L3 | Packet |
| L2 | Frame |
| L1 | Bits |

---

## 4. Common Protocols by Layer

| Layer | Protocol | Port(s) | Purpose |
|-------|----------|---------|---------|
| L7 | HTTP | 80 | Web browsing |
| L7 | HTTPS | 443 | Secure web browsing |
| L7 | FTP | 20, 21 | File transfer |
| L7 | SSH | 22 | Secure remote access |
| L7 | Telnet | 23 | Unsecure remote access |
| L7 | DNS | 53 | Name → IP resolution |
| L7 | DHCP | 67, 68 | Automatic IP assignment |
| L7 | SMTP | 25 | Email sending |
| L7 | SNMP | 161, 162 | Network management |
| L4 | TCP | — | Reliable transport |
| L4 | UDP | — | Fast, unreliable transport |
| L3 | IPv4 | — | Logical addressing & routing |
| L3 | IPv6 | — | Next-gen addressing |
| L3 | ICMP | — | Ping, error messages |
| L3 | ARP | — | IP → MAC resolution |
| L2 | Ethernet | — | LAN framing |
| L2 | 802.11 | — | Wireless LAN |

---

## 5. Devices at Each Layer

| Layer | Device | What It Uses |
|-------|--------|-------------|
| L1 | Hub | Bits — broadcasts to all ports |
| L2 | Switch | MAC addresses — forwards to specific ports |
| L3 | Router | IP addresses — routes between networks |
| L7 | Firewall (next-gen) | Application data — deep packet inspection |

### Switch vs. Router — Critical Comparison

| | Switch | Router |
|-|--------|--------|
| Operates at | Layer 2 (Data Link) | Layer 3 (Network) |
| Uses | MAC address table | Routing table |
| Receives unknown destination | Floods to all ports (except source) | Drops the packet |
| Broadcast domain | Does NOT break broadcast domains | Breaks broadcast domains |
| Collision domain | Each port is its own collision domain | Each interface is its own collision domain |

---

## Quiz — Test Your Understanding

**Answer each question before revealing the answers below.**

### Question 1
What are the 7 layers of the OSI model, from bottom to top?

### Question 2
A user opens a web browser and requests `https://www.example.com`. Which protocols are involved at each layer?

### Question 3
What is the PDU at each layer?
- Transport layer: ___
- Network layer: ___
- Data Link layer: ___

### Question 4
True or False: A switch operates at Layer 3 and uses IP addresses to forward traffic.

### Question 5
You run `ping 192.168.1.1` from your computer. Which protocol does ping use, and at which OSI layer does it operate?

### Question 6
What are the three steps of the TCP three-way handshake?

### Question 7
A frame arrives at a switch, but the destination MAC address is not in the switch's MAC address table. What does the switch do?

### Question 8
Which of the following protocols use UDP? (Select all that apply)
- a) HTTP
- b) DNS
- c) DHCP  
- d) FTP
- e) TFTP

### Question 9
What is the key difference between the OSI model and the TCP/IP model?

### Question 10
Place these in order of encapsulation (first added to last): IP header, TCP header, Ethernet frame header, Application data.

---

<details>
<summary><strong>Click to reveal answers</strong></summary>

### Answer 1
From bottom to top:
1. **Physical**
2. **Data Link**
3. **Network**
4. **Transport**
5. **Session**
6. **Presentation**
7. **Application**

### Answer 2
- **Application (L7):** HTTPS (HTTP over TLS), DNS (to resolve the domain name)
- **Presentation (L6):** TLS/SSL (encryption)
- **Session (L5):** Session management for the HTTPS connection
- **Transport (L4):** TCP (port 443 for HTTPS, port 53 for DNS)
- **Network (L3):** IP (source and destination IP addresses), ARP (resolve gateway MAC)
- **Data Link (L2):** Ethernet (MAC addressing, framing)
- **Physical (L1):** Electrical signals over Cat6 cable (or Wi-Fi radio signals)

### Answer 3
- Transport layer: **Segment** (TCP) or **Datagram** (UDP)
- Network layer: **Packet**
- Data Link layer: **Frame**

### Answer 4
**False.** A switch operates at **Layer 2** and uses **MAC addresses**. (Note: L3 switches exist but the default behavior of a switch is L2.)

### Answer 5
Ping uses **ICMP** (Internet Control Message Protocol), which operates at **Layer 3** (Network layer). Specifically, it sends an ICMP Echo Request and expects an ICMP Echo Reply.

### Answer 6
1. **SYN** — Client sends a synchronization request to the server
2. **SYN-ACK** — Server acknowledges and sends its own synchronization
3. **ACK** — Client acknowledges the server's synchronization

After these three steps, the TCP connection is established and data transfer can begin.

### Answer 7
The switch **floods** the frame — it sends copies out **all ports except the port it was received on**. When the destination replies, the switch learns its MAC address and port mapping, and future frames are forwarded directly.

### Answer 8
**b) DNS** and **c) DHCP** and **e) TFTP**

- DNS uses UDP port 53 (and TCP for zone transfers)
- DHCP uses UDP ports 67/68
- TFTP uses UDP port 69
- HTTP uses TCP port 80
- FTP uses TCP ports 20/21

### Answer 9
The OSI model has **7 layers** and is a **theoretical reference model** developed by ISO. The TCP/IP model has **4 layers** and is the **practical model** that the Internet uses, developed by DARPA. In TCP/IP, the top three OSI layers (Application, Presentation, Session) are combined into a single "Application" layer, and the bottom two (Data Link, Physical) are combined into "Network Access."

### Answer 10
Order of encapsulation (inner to outer):
1. **Application data** (created first, at the top)
2. **TCP header** is added (Transport layer)
3. **IP header** is added (Network layer)
4. **Ethernet frame header** is added (Data Link layer — also adds FCS trailer)

So the final frame looks like: `[Ethernet Header][IP Header][TCP Header][Data][FCS]`

</details>

---

## Key Takeaways

1. The **OSI model** has 7 layers; the **TCP/IP model** has 4 — know both and how they map
2. **Encapsulation** adds headers as data goes down; **de-encapsulation** removes them going up
3. PDUs: Data → Segment → Packet → Frame → Bits
4. **Switches** = Layer 2 = MAC addresses; **Routers** = Layer 3 = IP addresses
5. **TCP** = reliable (3-way handshake); **UDP** = fast but unreliable
6. Know your port numbers — they WILL be on the exam

---

**Next:** [Exercises →](exercises.md)
