# Week 4 — Network Access: Ethernet, Switching & VLANs

## Table of Contents
- [Learning Objectives](#learning-objectives)
- [1. Ethernet Standards](#1-ethernet-standards)
- [2. MAC Addresses & Frame Format](#2-mac-addresses--frame-format)
- [3. Switch Operation](#3-switch-operation)
- [4. VLANs (Virtual LANs)](#4-vlans-virtual-lans)
- [5. VLAN Trunking (802.1Q)](#5-vlan-trunking-8021q)
- [6. VLAN Configuration Commands](#6-vlan-configuration-commands)
- [Quiz — Test Your Understanding](#quiz--test-your-understanding)
- [Key Takeaways](#key-takeaways)

---

## Learning Objectives

By the end of this week, you should be able to:
- Identify Ethernet standards and cable types
- Explain how a switch builds and uses its MAC address table
- Create VLANs and assign ports
- Configure trunk links with 802.1Q
- Explain the purpose of the native VLAN
- Describe the difference between access and trunk ports

---

## 1. Ethernet Standards

| Standard | Speed | Cable Type | Max Distance |
|----------|-------|-----------|-------------|
| 10BASE-T | 10 Mbps | Cat3+ (UTP) | 100m |
| 100BASE-TX | 100 Mbps | Cat5+ (UTP) | 100m |
| 1000BASE-T | 1 Gbps | Cat5e+ (UTP) | 100m |
| 10GBASE-T | 10 Gbps | Cat6a (UTP) | 100m |
| 100BASE-FX | 100 Mbps | MMF (Fiber) | 400m |
| 1000BASE-SX | 1 Gbps | MMF (Fiber) | 550m |
| 1000BASE-LX | 1 Gbps | SMF (Fiber) | 5km |
| 10GBASE-SR | 10 Gbps | MMF (Fiber) | 400m |
| 10GBASE-LR | 10 Gbps | SMF (Fiber) | 10km |

### Cable Types
- **UTP (Unshielded Twisted Pair):** Cat5e, Cat6, Cat6a — uses RJ-45 connectors
- **MMF (Multi-Mode Fiber):** Short distances, cheaper, uses LED light
- **SMF (Single-Mode Fiber):** Long distances, expensive, uses laser light

### Cable Wiring
- **Straight-through:** Host ↔ Switch, Router ↔ Switch (unlike devices)
- **Crossover:** Switch ↔ Switch, Host ↔ Host, Router ↔ Router (like devices)
- **Modern devices** use **Auto-MDIX** (automatically detect and adjust)

---

## 2. MAC Addresses & Frame Format

### MAC Address
- **48 bits** (6 bytes), written as 12 hex digits: `AA:BB:CC:DD:EE:FF`
- First 24 bits = **OUI** (Organizationally Unique Identifier) — identifies manufacturer
- Last 24 bits = **Device identifier** — unique per device
- **Burned-in** to the NIC (but can be overridden in software)

### Special MAC Addresses
| Address | Purpose |
|---------|---------|
| `FF:FF:FF:FF:FF:FF` | Broadcast — sent to ALL devices on the LAN |
| `01:00:5E:xx:xx:xx` | IPv4 multicast |
| `33:33:xx:xx:xx:xx` | IPv6 multicast |

### Ethernet Frame Format (802.3)

```
┌──────────┬──────────┬──────────┬──────────────┬─────────┬─────┐
│ Preamble │ Dest MAC │ Src MAC  │ Type/Length   │ Payload │ FCS │
│ 8 bytes  │ 6 bytes  │ 6 bytes  │ 2 bytes      │ 46-1500 │ 4B  │
└──────────┴──────────┴──────────┴──────────────┴─────────┴─────┘
```

- **Preamble:** Synchronization (7 bytes) + SFD (1 byte)
- **Dest MAC:** Destination MAC address
- **Src MAC:** Source MAC address
- **Type:** 0x0800 (IPv4), 0x86DD (IPv6), 0x0806 (ARP), 0x8100 (802.1Q VLAN tag)
- **Payload:** The encapsulated L3 packet (46–1500 bytes)
- **FCS:** Frame Check Sequence — CRC error detection

> **Minimum frame size:** 64 bytes (excluding preamble). If payload is less than 46 bytes, padding is added.

---

## 3. Switch Operation

### MAC Address Table (CAM Table)

A switch learns which MAC addresses are on which ports by examining the **source MAC** of every incoming frame.

### Three Switch Actions

| Action | When | What Happens |
|--------|------|-------------|
| **Learn** | Frame arrives | Switch records source MAC + ingress port in MAC table |
| **Forward** | Destination MAC found in table | Switch sends frame out the specific port only |
| **Flood** | Destination MAC NOT in table (or broadcast) | Switch sends frame out ALL ports except source |

### Step-by-Step: How a Switch Processes a Frame

1. Frame arrives on port Fa0/1 with source MAC `AAAA` and destination MAC `BBBB`
2. **Learn:** Switch adds `AAAA → Fa0/1` to its MAC address table
3. **Lookup:** Switch checks MAC table for `BBBB`
   - **If found** (e.g., `BBBB → Fa0/3`): **Forward** only to Fa0/3
   - **If not found**: **Flood** to all ports except Fa0/1
4. When `BBBB` replies, the switch learns `BBBB → Fa0/3`

### MAC Table Aging
- Entries are removed after **300 seconds** (5 minutes) of inactivity
- Can be cleared manually: `clear mac address-table dynamic`

---

## 4. VLANs (Virtual LANs)

### What is a VLAN?
A VLAN is a **logical segmentation** of a switch into multiple broadcast domains. Without VLANs, all ports on a switch are in the same broadcast domain.

### Why VLANs?
- **Security:** Isolate sensitive traffic (e.g., HR from Guest WiFi)
- **Performance:** Reduce broadcast domain size (fewer broadcasts = less noise)
- **Flexibility:** Group users by function, not physical location
- **Management:** Apply policies per VLAN (ACLs, QoS)

### VLAN Facts
- VLAN range: **1–4094** (1 is default, 1002-1005 reserved for legacy)
- **VLAN 1** is the default VLAN — all ports start here
- Each VLAN is its own **broadcast domain**
- Traffic between VLANs requires a **router** (Inter-VLAN routing)
- VLANs are **local to each switch** unless trunking is configured

### Access Ports vs. Trunk Ports

| Feature | Access Port | Trunk Port |
|---------|-------------|-----------|
| Carries | One VLAN only | Multiple VLANs |
| Connects to | End devices (PCs, printers, phones) | Switches, routers |
| Tagging | No tag (untagged) | 802.1Q tagged |
| Configuration | `switchport mode access` | `switchport mode trunk` |

---

## 5. VLAN Trunking (802.1Q)

### How 802.1Q Works
When a frame crosses a **trunk link**, the switch inserts a **4-byte VLAN tag** into the Ethernet frame header:

```
┌──────────┬──────────┬──────────┬──────────┬──────────────┬─────────┬─────┐
│ Preamble │ Dest MAC │ Src MAC  │ 802.1Q   │ Type/Length   │ Payload │ FCS │
│ 8 bytes  │ 6 bytes  │ 6 bytes  │ 4 bytes  │ 2 bytes      │ 46-1500 │ 4B  │
└──────────┴──────────┴──────────┴──────────┴──────────────┴─────────┴─────┘
                                  ↑
                           VLAN Tag inserted
```

The 802.1Q tag contains:
- **TPID** (Tag Protocol Identifier): 0x8100 — identifies this as a tagged frame
- **PCP** (Priority Code Point): 3 bits — QoS priority (0-7)
- **DEI** (Drop Eligible Indicator): 1 bit
- **VID** (VLAN Identifier): 12 bits — the VLAN number (0-4095)

### Native VLAN
- The native VLAN is the **one VLAN that is NOT tagged** on a trunk
- Default: **VLAN 1**
- Frames in the native VLAN cross the trunk **without a tag**
- **Security best practice:** Change the native VLAN to something other than VLAN 1
- Native VLAN **must match** on both ends of a trunk link

### DTP (Dynamic Trunking Protocol)
- Cisco proprietary protocol that auto-negotiates trunk links
- Modes: `auto`, `desirable`, `nonegotiate`
- **Best practice:** Disable DTP and manually set trunk/access: `switchport nonegotiate`

---

## 6. VLAN Configuration Commands

### Create a VLAN
```
Switch(config)# vlan 10
Switch(config-vlan)# name Sales
Switch(config-vlan)# exit
```

### Assign an Access Port
```
Switch(config)# interface FastEthernet0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 10
```

### Configure a Trunk Port
```
Switch(config)# interface GigabitEthernet0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20,30
Switch(config-if)# switchport trunk native vlan 99
```

### Verification Commands
```
show vlan brief                    ← VLANs and port assignments
show interfaces trunk              ← Trunk links, allowed VLANs, native VLAN
show interfaces status             ← Port status, VLAN, speed, duplex
show mac address-table             ← MAC-to-port mappings
show mac address-table dynamic     ← Only dynamically learned entries
```

---

## Quiz — Test Your Understanding

### Question 1
What is the maximum distance for a 1000BASE-T (Gigabit Ethernet) connection over Cat5e cable?

### Question 2
A frame arrives at a switch on port Fa0/5. The destination MAC is `FF:FF:FF:FF:FF:FF`. What does the switch do?

### Question 3
What is the default VLAN on a Cisco switch, and what happens if you never configure any VLANs?

### Question 4
Explain the difference between an access port and a trunk port.

### Question 5
What is a native VLAN? Why is it a security best practice to change it from VLAN 1?

### Question 6
A switch has this MAC address table:

| MAC Address | Port |
|-------------|------|
| AA:AA:AA:AA:AA:AA | Fa0/1 |
| BB:BB:BB:BB:BB:BB | Fa0/3 |

A frame arrives on Fa0/5 with: Source=`CC:CC:CC:CC:CC:CC`, Destination=`BB:BB:BB:BB:BB:BB`. What two things does the switch do?

### Question 7
True or False: Devices in different VLANs can communicate without a router.

### Question 8
What happens if the native VLAN is VLAN 10 on one end of a trunk and VLAN 20 on the other end?

### Question 9
What 802.1Q field identifies which VLAN a frame belongs to?

### Question 10
You want to allow only VLANs 10, 20, and 30 on a trunk link. What command do you use?

---

<details>
<summary><strong>Click to reveal answers</strong></summary>

### Answer 1
**100 meters** (328 feet). This applies to all standard UTP Ethernet (10BASE-T through 10GBASE-T).

### Answer 2
The switch **floods** the frame out ALL ports except Fa0/5. `FF:FF:FF:FF:FF:FF` is the broadcast address, and broadcasts are always flooded to the entire VLAN.

### Answer 3
**VLAN 1** is the default VLAN. If you never configure any VLANs, all ports remain in VLAN 1 — meaning all ports are in one broadcast domain (just like an unmanaged switch).

### Answer 4
- **Access port:** Carries traffic for ONE VLAN only. Connects to end devices (PCs, printers). Frames are untagged.
- **Trunk port:** Carries traffic for MULTIPLE VLANs simultaneously. Connects to other switches or routers. Frames are tagged with 802.1Q VLAN ID (except the native VLAN).

### Answer 5
The **native VLAN** is the VLAN whose traffic is sent across a trunk link **without an 802.1Q tag**. Changing it from VLAN 1 is a security best practice because:
- Attackers can craft double-tagged frames to "hop" VLANs (VLAN hopping attack)
- VLAN 1 is the default management VLAN — if trunks carry it untagged, it's exposed
- Best practice: set native VLAN to an unused VLAN (e.g., VLAN 999)

### Answer 6
1. **Learn:** Adds `CC:CC:CC:CC:CC:CC → Fa0/5` to the MAC table
2. **Forward:** Looks up `BB:BB:BB:BB:BB:BB` → found on Fa0/3 → sends frame ONLY to Fa0/3

### Answer 7
**False.** VLANs create separate broadcast domains. A router (or Layer 3 switch with SVIs) is required for inter-VLAN communication.

### Answer 8
**Native VLAN mismatch.** This causes:
- Frames from VLAN 10 (untagged on side A) will be placed into VLAN 20 on side B
- CDP/STP will report a native VLAN mismatch error
- Traffic will be misplaced into the wrong VLAN — a security and connectivity issue
- **Always ensure native VLAN matches on both ends of a trunk.**

### Answer 9
The **VID (VLAN Identifier)** field — a 12-bit field within the 802.1Q tag that can represent VLAN numbers 0–4095.

### Answer 10
```
switchport trunk allowed vlan 10,20,30
```

</details>

---

## Key Takeaways

1. Switches operate at **Layer 2**: learn source MACs, forward/flood based on destination MAC
2. **VLANs** segment a switch into multiple broadcast domains — traffic between VLANs needs a router
3. **Access ports** = one VLAN, **Trunk ports** = multiple VLANs with 802.1Q tagging
4. **Native VLAN** = untagged on trunk — change from VLAN 1 for security
5. Know your Ethernet standards: 1000BASE-T = 1 Gbps copper, 100m max
6. Key commands: `show vlan brief`, `show interfaces trunk`, `show mac address-table`

---

**Next:** [Exercises →](exercises.md)
