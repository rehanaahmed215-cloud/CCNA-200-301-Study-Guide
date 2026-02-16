# Week 2 — IPv4 Addressing & Subnetting

## Table of Contents
- [Learning Objectives](#learning-objectives)
- [1. Binary ↔ Decimal Conversion](#1-binary--decimal-conversion)
- [2. IPv4 Address Structure](#2-ipv4-address-structure)
- [3. IPv4 Address Classes](#3-ipv4-address-classes)
- [4. Subnetting — Step by Step](#4-subnetting--step-by-step)
- [5. Splitting a Network into Subnets](#5-splitting-a-network-into-subnets)
- [6. VLSM (Variable Length Subnet Masking)](#6-vlsm-variable-length-subnet-masking)
- [Quiz — Test Your Understanding](#quiz--test-your-understanding)
- [Key Takeaways](#key-takeaways)

---

## Learning Objectives

By the end of this week, you should be able to:
- Convert between binary and decimal
- Identify IPv4 address classes and private ranges
- Calculate subnet mask, network address, broadcast address, and usable hosts
- Perform subnetting with CIDR notation
- Design a VLSM addressing scheme

---

## 1. Binary ↔ Decimal Conversion

Every IPv4 address is a **32-bit number** written as four octets in decimal (e.g., `192.168.1.10`).

### Binary Place Values (one octet)

| Bit position | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|---|---|---|---|---|---|---|---|---|
| **Value** | 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |

### Examples

**Decimal → Binary:**
- `192` = 128 + 64 = `11000000`
- `168` = 128 + 32 + 8 = `10101000`
- `10` = 8 + 2 = `00001010`
- `255` = 128+64+32+16+8+4+2+1 = `11111111`

**Binary → Decimal:**
- `11001100` = 128 + 64 + 8 + 4 = `204`
- `10110000` = 128 + 32 + 16 = `176`

### Quick Method
Start from the left (128). If the bit is 1, add the value. Move right.

---

## 2. IPv4 Address Structure

An IPv4 address has two parts:
- **Network portion** — identifies the network (like a street name)
- **Host portion** — identifies the specific device (like a house number)

The **subnet mask** tells you where the split is:
```
IP Address:   192.168.1.  10
Subnet Mask:  255.255.255.0
              |--Network--| Host |
```

### CIDR Notation
Instead of writing `255.255.255.0`, we write `/24` — meaning the first 24 bits are the network portion.

| CIDR | Subnet Mask | Network Bits | Host Bits | Usable Hosts |
|------|------------|-------------|-----------|-------------|
| /8 | 255.0.0.0 | 8 | 24 | 16,777,214 |
| /16 | 255.255.0.0 | 16 | 16 | 65,534 |
| /24 | 255.255.255.0 | 24 | 8 | 254 |
| /25 | 255.255.255.128 | 25 | 7 | 126 |
| /26 | 255.255.255.192 | 26 | 6 | 62 |
| /27 | 255.255.255.224 | 27 | 5 | 30 |
| /28 | 255.255.255.240 | 28 | 4 | 14 |
| /29 | 255.255.255.248 | 29 | 3 | 6 |
| /30 | 255.255.255.252 | 30 | 2 | 2 |
| /31 | 255.255.255.254 | 31 | 1 | 2* |
| /32 | 255.255.255.255 | 32 | 0 | 1 (host route) |

> **/30 is standard for point-to-point links.** /31 is used on some modern router links (RFC 3021).

**Formula:** Usable hosts = $2^{h} - 2$ where $h$ = number of host bits. (Subtract 2 for network address and broadcast address.)

---

## 3. IPv4 Address Classes

| Class | First Octet Range | Default Mask | Purpose |
|-------|-------------------|-------------|---------|
| A | 1 – 126 | /8 (255.0.0.0) | Large networks |
| B | 128 – 191 | /16 (255.255.0.0) | Medium networks |
| C | 192 – 223 | /24 (255.255.255.0) | Small networks |
| D | 224 – 239 | — | Multicast |
| E | 240 – 255 | — | Experimental |

> **Note:** 127.0.0.0/8 is reserved for **loopback** (127.0.0.1 = localhost).

### Private Address Ranges (RFC 1918)

These are **not routable** on the Internet — used inside organizations:

| Class | Range | CIDR |
|-------|-------|------|
| A | 10.0.0.0 – 10.255.255.255 | 10.0.0.0/8 |
| B | 172.16.0.0 – 172.31.255.255 | 172.16.0.0/12 |
| C | 192.168.0.0 – 192.168.255.255 | 192.168.0.0/16 |

### Special Addresses
- `0.0.0.0` — "this network" / default route
- `255.255.255.255` — limited broadcast
- `169.254.0.0/16` — APIPA (auto-assigned when DHCP fails)

---

## 4. Subnetting — Step by Step

### The 4 Things You Need to Calculate

Given an IP and mask (e.g., `192.168.10.50/26`):

1. **Network address** — the first address in the subnet (all host bits = 0)
2. **Broadcast address** — the last address in the subnet (all host bits = 1)
3. **First usable host** — network address + 1
4. **Last usable host** — broadcast address - 1

### Method: The "Magic Number"

1. Find the interesting octet (where the subnet mask is not 255 or 0)
2. **Magic number** = 256 − (subnet mask value in that octet)
3. Subnets start at 0 and increment by the magic number

### Worked Example: 192.168.10.50/26

**Step 1:** /26 = `255.255.255.192` → interesting octet is the 4th (192)

**Step 2:** Magic number = 256 − 192 = **64**

**Step 3:** Subnets in the 4th octet: 0, 64, 128, 192

**Step 4:** 50 falls in the 0–63 range:
- **Network address:** 192.168.10.0
- **Broadcast address:** 192.168.10.63 (next subnet − 1)
- **First usable:** 192.168.10.1
- **Last usable:** 192.168.10.62
- **Usable hosts:** $2^6 - 2 = 62$

### Another Example: 172.16.45.200/21

**Step 1:** /21 = `255.255.248.0` → interesting octet is the 3rd (248)

**Step 2:** Magic number = 256 − 248 = **8**

**Step 3:** Subnets in the 3rd octet: 0, 8, 16, 24, 32, **40**, 48, ...

**Step 4:** 45 falls in the 40–47 range:
- **Network address:** 172.16.40.0
- **Broadcast address:** 172.16.47.255
- **First usable:** 172.16.40.1
- **Last usable:** 172.16.47.254
- **Usable hosts:** $2^{11} - 2 = 2046$

---

## 5. Splitting a Network into Subnets

**Task:** Subnet `192.168.10.0/24` into **4 equal subnets**.

**Step 1:** How many bits do we need to borrow? $2^n \geq 4$ → n = 2 bits

**Step 2:** New mask: /24 + 2 = **/26** (`255.255.255.192`)

**Step 3:** Magic number: 256 − 192 = 64

**Step 4:** Four subnets:

| Subnet | Network Address | First Usable | Last Usable | Broadcast | Hosts |
|--------|----------------|-------------|------------|-----------|-------|
| 1 | 192.168.10.0/26 | 192.168.10.1 | 192.168.10.62 | 192.168.10.63 | 62 |
| 2 | 192.168.10.64/26 | 192.168.10.65 | 192.168.10.126 | 192.168.10.127 | 62 |
| 3 | 192.168.10.128/26 | 192.168.10.129 | 192.168.10.190 | 192.168.10.191 | 62 |
| 4 | 192.168.10.192/26 | 192.168.10.193 | 192.168.10.254 | 192.168.10.255 | 62 |

---

## 6. VLSM (Variable Length Subnet Masking)

VLSM lets you use **different subnet sizes** for different needs — no wasted addresses.

### VLSM Method
1. **Sort** requirements from largest to smallest
2. **Allocate** the largest subnet first
3. Use the **next available** address space for each subsequent subnet

### Worked Example

**Given:** 10.0.0.0/8, create subnets for:
- HQ: 500 hosts
- Branch A: 120 hosts
- Branch B: 60 hosts
- WAN link: 2 hosts

**Step 1: Sort** → HQ (500), Branch A (120), Branch B (60), WAN (2)

**Step 2: Calculate mask for each:**

| Subnet | Hosts Needed | Host Bits ($2^h - 2 \geq$ need) | Mask |
|--------|-------------|--------------------------------|------|
| HQ | 500 | $2^9 - 2 = 510$ ✓ (9 bits) | /23 |
| Branch A | 120 | $2^7 - 2 = 126$ ✓ (7 bits) | /25 |
| Branch B | 60 | $2^6 - 2 = 62$ ✓ (6 bits) | /26 |
| WAN | 2 | $2^2 - 2 = 2$ ✓ (2 bits) | /30 |

**Step 3: Allocate sequentially:**

| Subnet | Network | Mask | Range | Broadcast |
|--------|---------|------|-------|-----------|
| HQ | 10.0.0.0 | /23 | 10.0.0.1 – 10.0.1.254 | 10.0.1.255 |
| Branch A | 10.0.2.0 | /25 | 10.0.2.1 – 10.0.2.126 | 10.0.2.127 |
| Branch B | 10.0.2.128 | /26 | 10.0.2.129 – 10.0.2.190 | 10.0.2.191 |
| WAN | 10.0.2.192 | /30 | 10.0.2.193 – 10.0.2.194 | 10.0.2.195 |

---

## Quiz — Test Your Understanding

### Question 1
Convert `172` to binary.

### Question 2
What is the subnet mask for `/27` in dotted decimal?

### Question 3
Given `192.168.5.130/25`:
- What is the network address?
- What is the broadcast address?
- How many usable hosts?

### Question 4
Which of these are private IP addresses? (Select all)
- a) 10.5.3.1
- b) 172.32.1.1
- c) 192.168.100.50
- d) 172.20.0.1
- e) 8.8.8.8

### Question 5
You need to subnet `10.10.0.0/16` into subnets that each support at least 500 hosts. What subnet mask should you use, and how many subnets will you get?

### Question 6
A host has IP `10.1.1.50/28`. Can it communicate directly (without a router) with `10.1.1.60/28`? Why or why not?

### Question 7
What is the purpose of the network address and broadcast address? Why can't they be assigned to hosts?

### Question 8
Your company has been assigned `192.168.50.0/24`. You need:
- Subnet A: 100 hosts
- Subnet B: 50 hosts
- Subnet C: 25 hosts
- Subnet D: 2 hosts (point-to-point link)

Design a VLSM scheme.

### Question 9
True or False: A host with IP `192.168.1.255/23` is a valid host address.

### Question 10
What is APIPA, and when does a device use it?

---

<details>
<summary><strong>Click to reveal answers</strong></summary>

### Answer 1
`172` = 128 + 32 + 8 + 4 = `10101100`

### Answer 2
/27 → 27 network bits → last octet: `11100000` = 128+64+32 = 224
**255.255.255.224**

### Answer 3
/25 → magic number = 256 - 128 = 128. Subnets: .0 and .128. 130 falls in .128:
- **Network address:** 192.168.5.128
- **Broadcast address:** 192.168.5.255
- **Usable hosts:** $2^7 - 2 = 126$

### Answer 4
**a) 10.5.3.1** ✓ (10.0.0.0/8)
**c) 192.168.100.50** ✓ (192.168.0.0/16)
**d) 172.20.0.1** ✓ (172.16.0.0/12 → 172.16.0.0 – 172.31.255.255)

b) 172.32.1.1 is NOT private (172.16–172.31 only)
e) 8.8.8.8 is Google's public DNS

### Answer 5
500 hosts → need $2^h - 2 \geq 500$ → $h = 9$ → 9 host bits → /23
Number of subnets: /23 - /16 = 7 bits borrowed → $2^7 = 128$ subnets
**Mask: /23 (255.255.254.0), 128 subnets, 510 hosts each**

### Answer 6
/28 → magic number = 256 - 240 = 16. Subnets: 0, 16, 32, **48**, 64...
- 10.1.1.50 → subnet 10.1.1.48/28 (range 48–63)
- 10.1.1.60 → subnet 10.1.1.48/28 (range 48–63)
**Yes, they CAN communicate directly** — both are in the same /28 subnet.

### Answer 7
- **Network address** (all host bits 0): Identifies the subnet itself. Used in routing tables. Cannot be assigned to a host because it represents the entire network.
- **Broadcast address** (all host bits 1): Used to send traffic to ALL hosts on that subnet. Cannot be assigned to a host because it's reserved for broadcast traffic.

### Answer 8
Sort largest first: A(100), B(50), C(25), D(2)

| Subnet | Hosts | Bits | Mask | Network | Range | Broadcast |
|--------|-------|------|------|---------|-------|-----------|
| A | 100 | $2^7-2=126$ | /25 | 192.168.50.0/25 | .1–.126 | .127 |
| B | 50 | $2^6-2=62$ | /26 | 192.168.50.128/26 | .129–.190 | .191 |
| C | 25 | $2^5-2=30$ | /27 | 192.168.50.192/27 | .193–.222 | .223 |
| D | 2 | $2^2-2=2$ | /30 | 192.168.50.224/30 | .225–.226 | .227 |

### Answer 9
**True!** With a /23 mask, the network is 192.168.0.0/23 (or 192.168.1.0 depending on the base).
The broadcast for 192.168.0.0/23 is 192.168.1.255. BUT — if the network is 192.168.0.0/23, then 192.168.1.255 IS the broadcast. If the network is 192.168.1.0/23, then 192.168.1.255 is a valid host (broadcast would be 192.168.2.255... wait — /23 from 192.168.1.0 would give network 192.168.0.0).

Let's be precise: /23 in the third octet means subnets increment by 2 (magic = 256-254=2). 
- Subnet: 192.168.0.0/23 → broadcast 192.168.1.255 → 192.168.1.255 is the **broadcast**, NOT a valid host
- Subnet: 192.168.2.0/23 → broadcast 192.168.3.255

So 192.168.1.255/23 belongs to network 192.168.0.0/23 and is the broadcast address.
**False — it's the broadcast address for 192.168.0.0/23.**

### Answer 10
**APIPA** (Automatic Private IP Addressing) assigns an address in the `169.254.0.0/16` range when a device is configured for DHCP but **cannot reach a DHCP server**. It allows basic local communication but not Internet access.

</details>

---

## Key Takeaways

1. **Binary fluency** is essential — practice until conversion is automatic
2. **Subnetting formula:** Magic number = 256 − mask value in the interesting octet
3. **Usable hosts** = $2^h - 2$ (subtract network and broadcast)
4. Know private ranges: **10.0.0.0/8**, **172.16.0.0/12**, **192.168.0.0/16**
5. **VLSM:** Always allocate largest subnet first, then fill remaining space
6. The **/30** mask is standard for point-to-point links (2 usable hosts)

---

## Sources & Further Reading

- [Cisco — IP Addressing Guide](https://www.cisco.com/c/en/us/support/docs/ip/routing-information-protocol-rip/13788-3.html) — Cisco's IP addressing & subnetting reference
- [RFC 791 — Internet Protocol](https://datatracker.ietf.org/doc/html/rfc791) — IPv4 specification
- [RFC 1918 — Private Address Space](https://datatracker.ietf.org/doc/html/rfc1918) — Private IP ranges (10.x, 172.16.x, 192.168.x)
- [RFC 4632 — CIDR](https://datatracker.ietf.org/doc/html/rfc4632) — Classless Inter-Domain Routing
- [Subnet Calculator](https://www.subnet-calculator.com/) — Online subnetting practice tool
- [Practical Networking — Subnetting Mastery](https://www.practicalnetworking.net/stand-alone/subnetting-mastery/) — Step-by-step subnetting guide
- [Jeremy's IT Lab — Subnetting (YouTube)](https://www.youtube.com/watch?v=Ct4PU6CyvTQ&list=PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ) — Video walkthrough
- [Subnetting Practice — subnettingpractice.com](https://subnettingpractice.com/) — Timed subnetting drills

---

**Next:** [Exercises →](exercises.md)
