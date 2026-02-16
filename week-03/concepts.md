# Week 3 — IPv6 & Dual Stack

## Table of Contents
- [Learning Objectives](#learning-objectives)
- [1. Why IPv6?](#1-why-ipv6)
- [2. IPv6 Address Format](#2-ipv6-address-format)
- [3. IPv6 Address Types](#3-ipv6-address-types)
- [4. IPv6 Address Assignment Methods](#4-ipv6-address-assignment-methods)
- [5. Neighbor Discovery Protocol (NDP)](#5-neighbor-discovery-protocol-ndp)
- [6. Dual-Stack, Tunneling, NAT64](#6-dual-stack-tunneling-nat64)
- [Quiz — Test Your Understanding](#quiz--test-your-understanding)
- [Key Takeaways](#key-takeaways)

---

## Learning Objectives

By the end of this week, you should be able to:
- Explain why IPv6 exists and its advantages over IPv4
- Read, write, and shorten IPv6 addresses
- Identify IPv6 address types (GUA, Link-Local, Multicast, Anycast)
- Configure IPv6 on routers and verify connectivity
- Understand SLAAC vs. DHCPv6
- Explain dual-stack operation

---

## 1. Why IPv6?

### The Problem: IPv4 Address Exhaustion
- IPv4 has $2^{32}$ = ~4.3 billion addresses
- IANA exhausted its pool in **February 2011**
- NAT has extended IPv4's life, but it's a workaround, not a solution

### IPv6 Advantages
- **Massive address space:** $2^{128}$ = ~340 undecillion addresses
- **Simplified header:** Fixed 40-byte header (no checksum, no fragmentation by routers)
- **No broadcast:** Uses multicast and anycast instead
- **Built-in autoconfiguration:** SLAAC (no DHCP server needed)
- **Built-in IPsec support**
- **No NAT needed** (every device can have a global address)

---

## 2. IPv6 Address Format

### Structure
- **128 bits** long, written as 8 groups of 4 hex digits, separated by colons
- Example: `2001:0db8:0000:0000:0000:0000:0000:0001`

### Shortening Rules

**Rule 1: Remove leading zeros** in each group
```
2001:0db8:0000:0000:0000:0000:0000:0001
→ 2001:db8:0:0:0:0:0:1
```

**Rule 2: Replace ONE consecutive run of all-zero groups with `::`** (only once!)
```
2001:db8:0:0:0:0:0:1
→ 2001:db8::1
```

### Shortening Examples

| Full Form | Shortened |
|-----------|-----------|
| `2001:0db8:0000:0000:0000:0000:0000:0001` | `2001:db8::1` |
| `fe80:0000:0000:0000:0000:0000:0000:0001` | `fe80::1` |
| `2001:0db8:abcd:0000:0000:0000:0000:0000` | `2001:db8:abcd::` |
| `2001:0db8:0000:0001:0000:0000:0000:0001` | `2001:db8:0:1::1` |
| `0000:0000:0000:0000:0000:0000:0000:0001` | `::1` (loopback) |
| `0000:0000:0000:0000:0000:0000:0000:0000` | `::` (unspecified) |

> **Trap:** You can only use `::` ONCE in an address. If you use it twice, the parser can't determine how many zero groups each `::` represents.

---

## 3. IPv6 Address Types

### Global Unicast Address (GUA)
- **Range:** `2000::/3` (starts with 2 or 3)
- **Purpose:** Routable on the Internet (like IPv4 public addresses)
- **Structure:**

```
| 48 bits          | 16 bits   | 64 bits        |
| Global Routing   | Subnet ID | Interface ID   |
| Prefix           |           |                |
|← ISP assigns →|← You →|← Auto/Manual →|
```

### Link-Local Address
- **Range:** `fe80::/10`
- **Purpose:** Communication on the local link only (not routable)
- **Auto-generated** on every IPv6-enabled interface
- **Used for:** Neighbor discovery, routing protocol next-hops, default gateways
- Example: `fe80::1`

### Unique Local Address (ULA)
- **Range:** `fc00::/7` (typically `fd00::/8`)
- **Purpose:** Like IPv4 private addresses — not routable on Internet
- Rarely tested on CCNA but good to know

### Multicast
- **Range:** `ff00::/8`
- **Key addresses:**
  - `ff02::1` — All nodes on the link (like IPv4 broadcast)
  - `ff02::2` — All routers on the link
  - `ff02::5` — All OSPF routers
  - `ff02::a` — All EIGRP routers
  - `ff02::1:ff00:0/104` — Solicited-node multicast (used by NDP)

### Anycast
- Assigned to multiple interfaces; traffic goes to the **nearest** one
- Same format as unicast — the routing determines anycast behavior

### Special Addresses
| Address | Purpose |
|---------|---------|
| `::1` | Loopback (like 127.0.0.1) |
| `::` | Unspecified (like 0.0.0.0) |
| `::ffff:0:0/96` | IPv4-mapped IPv6 |

---

## 4. IPv6 Address Assignment Methods

### Method 1: Manual (Static)
Just like IPv4 — administrator configures the address:
```
interface GigabitEthernet0/0
 ipv6 address 2001:db8:1::1/64
```

### Method 2: SLAAC (Stateless Address Auto-Configuration)
- Router sends **Router Advertisements (RA)** with the prefix
- Host generates its own Interface ID (using EUI-64 or random)
- **No DHCP server needed**
- Host gets: prefix + interface ID + default gateway (router's link-local)

#### EUI-64 Process
1. Take the 48-bit MAC address: `AA:BB:CC:DD:EE:FF`
2. Split in half: `AA:BB:CC` | `DD:EE:FF`
3. Insert `FF:FE` in the middle: `AA:BB:CC:FF:FE:DD:EE:FF`
4. Flip the 7th bit (U/L bit): `A8:BB:CC:FF:FE:DD:EE:FF`
5. Result: Interface ID = `a8bb:ccff:fedd:eeff`

### Method 3: Stateless DHCPv6
- SLAAC gives the IP address
- DHCPv6 provides **additional info** (DNS servers, domain name)
- RA flag: O=1 (Other configuration)

### Method 4: Stateful DHCPv6
- DHCPv6 server assigns the **full address** (like IPv4 DHCP)
- RA flag: M=1 (Managed address configuration)
- Server tracks which addresses are assigned (stateful)

### Comparison

| Feature | SLAAC | Stateless DHCPv6 | Stateful DHCPv6 |
|---------|-------|------------------|-----------------|
| Address from | Router prefix + self-generated | Router prefix + self-generated | DHCPv6 server |
| DNS from | Not provided | DHCPv6 server | DHCPv6 server |
| Server needed | No | Yes (for DNS only) | Yes |
| RA flags | M=0, O=0 | M=0, O=1 | M=1 |

---

## 5. Neighbor Discovery Protocol (NDP)

NDP replaces ARP in IPv6. It uses ICMPv6 messages:

| Message | Type | Purpose | IPv4 Equivalent |
|---------|------|---------|----------------|
| Router Solicitation (RS) | 133 | "Any routers out there?" | — |
| Router Advertisement (RA) | 134 | "I'm a router, here's the prefix" | — |
| Neighbor Solicitation (NS) | 135 | "What's your MAC address?" | ARP Request |
| Neighbor Advertisement (NA) | 136 | "Here's my MAC address" | ARP Reply |
| Redirect | 137 | "Use a better next-hop" | ICMP Redirect |

---

## 6. Dual-Stack, Tunneling, NAT64

### Dual-Stack
- Devices run **both IPv4 and IPv6** simultaneously
- Most common transition method today
- Each interface has both an IPv4 and IPv6 address
- DNS returns both A (IPv4) and AAAA (IPv6) records

### Tunneling (6to4, ISATAP, Teredo)
- Encapsulate IPv6 packets inside IPv4 packets
- Used when IPv6 traffic needs to cross IPv4-only networks
- Mostly legacy — dual-stack is preferred

### NAT64
- Translates between IPv6 and IPv4
- Allows IPv6-only clients to reach IPv4-only servers
- Uses DNS64 to synthesize AAAA records

---

## Quiz — Test Your Understanding

### Question 1
Shorten this IPv6 address: `2001:0db8:0000:0000:0000:0000:0000:0001`

### Question 2
Expand this IPv6 address to full form: `fe80::1`

### Question 3
What type of IPv6 address starts with `fe80`?

### Question 4
What is the IPv6 equivalent of an ARP request?

### Question 5
True or False: In IPv6, broadcast addresses are used to send traffic to all hosts on a subnet.

### Question 6
A host receives a Router Advertisement with the prefix `2001:db8:1::/64`. Using SLAAC with EUI-64, and a MAC address of `00:1A:2B:3C:4D:5E`, what will the host's IPv6 address be?

### Question 7
What is the difference between SLAAC and Stateful DHCPv6?

### Question 8
Which IPv6 multicast address means "all routers on this link"?

### Question 9
Why can you only use `::` once in an IPv6 address?

### Question 10
Your router has this configuration:
```
interface GigabitEthernet0/0
 ipv6 address 2001:db8:cafe::1/64
 ipv6 address fe80::1 link-local
```
Is this valid? Why might you manually set the link-local address?

---

<details>
<summary><strong>Click to reveal answers</strong></summary>

### Answer 1
`2001:db8::1`

Steps: Remove leading zeros → `2001:db8:0:0:0:0:0:1` → Replace consecutive zeros with `::` → `2001:db8::1`

### Answer 2
`fe80:0000:0000:0000:0000:0000:0000:0001`

The `::` replaces six groups of `0000`.

### Answer 3
**Link-Local** address (fe80::/10). It's auto-generated on every IPv6 interface and is used for local-link communication only (not routable).

### Answer 4
**Neighbor Solicitation (NS)** — ICMPv6 Type 135. It's sent to the solicited-node multicast address of the target to resolve an IPv6 address to a MAC address.

### Answer 5
**False.** IPv6 has **no broadcast**. Instead, it uses **multicast** (e.g., `ff02::1` for all nodes) and **anycast**.

### Answer 6
EUI-64 process:
1. MAC: `00:1A:2B:3C:4D:5E`
2. Split: `00:1A:2B` | `3C:4D:5E`
3. Insert FFFE: `00:1A:2B:FF:FE:3C:4D:5E`
4. Flip 7th bit of first byte: `00` → binary `00000000` → flip 7th bit → `00000010` → `02`
5. Result: `02:1A:2B:FF:FE:3C:4D:5E`
6. Convert to IPv6 format: `021a:2bff:fe3c:4d5e`

**Full address:** `2001:db8:1::21a:2bff:fe3c:4d5e`

### Answer 7
- **SLAAC:** Host auto-generates its own address from the router's prefix + self-generated Interface ID. No server needed. Cannot provide DNS info natively.
- **Stateful DHCPv6:** A DHCPv6 server assigns the full IPv6 address and can provide DNS, domain name, and other options. The server tracks all assignments (stateful).

### Answer 8
`ff02::2`

- `ff02::1` = all nodes
- `ff02::2` = all routers

### Answer 9
Because the expander wouldn't know how to distribute zeros. Example: `2001::1::2` — is this `2001:0000:0000:0001:0000:0000:0000:0002` or `2001:0000:0000:0000:0001:0000:0000:0002`? There's no way to tell. Only one `::` is allowed so the parser can unambiguously fill in the remaining zeros.

### Answer 10
**Yes, it's valid.** An interface can have both a GUA (2001:db8:cafe::1) and a link-local address. The link-local is auto-generated, but manually setting it to `fe80::1` makes it **predictable and easy to remember** — useful because link-local addresses are used as next-hop addresses in routing tables and as default gateways. `fe80::1` is much easier to type than an auto-generated address like `fe80::a1b2:c3ff:fe45:6789`.

</details>

---

## Key Takeaways

1. IPv6 = 128 bits, written as 8 groups of hex, shortened with leading-zero removal and `::`
2. **GUA** (2000::/3) = public, **Link-Local** (fe80::/10) = local only, **Multicast** (ff00::/8)
3. **No broadcast in IPv6** — only multicast and anycast
4. **NDP** replaces ARP — uses Neighbor Solicitation/Advertisement
5. **SLAAC** = auto-addressing from router prefix; **DHCPv6** = server-assigned
6. **Dual-stack** runs IPv4 + IPv6 simultaneously — most common transition method

---

## Sources & Further Reading

- [RFC 8200 — IPv6 Specification](https://datatracker.ietf.org/doc/html/rfc8200) — Core IPv6 protocol
- [RFC 4291 — IPv6 Addressing Architecture](https://datatracker.ietf.org/doc/html/rfc4291) — Address types and formats
- [RFC 4861 — Neighbor Discovery Protocol (NDP)](https://datatracker.ietf.org/doc/html/rfc4861) — IPv6's replacement for ARP
- [RFC 4862 — SLAAC](https://datatracker.ietf.org/doc/html/rfc4862) — Stateless Address Autoconfiguration
- [Cisco — IPv6 Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipv6_basic/configuration/xe-16/ip6b-xe-16-book.html) — Cisco IOS IPv6 config
- [Google IPv6 Statistics](https://www.google.com/intl/en/ipv6/statistics.html) — Real-world IPv6 adoption rates
- [Jeremy's IT Lab — IPv6 (YouTube)](https://www.youtube.com/watch?v=YR0MoEBjwN4&list=PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ) — Video walkthrough

---

**Next:** [Exercises →](exercises.md)
