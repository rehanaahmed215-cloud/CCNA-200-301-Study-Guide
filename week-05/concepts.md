# Week 5 — STP, EtherChannel & Inter-VLAN Routing

## Table of Contents
- [Learning Objectives](#learning-objectives)
- [1. Spanning Tree Protocol (STP)](#1-spanning-tree-protocol-stp)
- [2. STP Port Roles and States](#2-stp-port-roles-and-states)
- [3. Rapid STP (802.1w)](#3-rapid-stp-8021w)
- [4. STP Best Practices](#4-stp-best-practices)
- [5. EtherChannel](#5-etherchannel)
- [6. Inter-VLAN Routing](#6-inter-vlan-routing)
- [Quiz — Test Your Understanding](#quiz--test-your-understanding)
- [Key Takeaways](#key-takeaways)

---

## Learning Objectives

By the end of this week, you should be able to:
- Explain why STP exists and how it prevents loops
- Identify root bridge election, port roles, and port states
- Configure Rapid STP and PortFast
- Configure EtherChannel using LACP
- Set up inter-VLAN routing using router-on-a-stick and Layer 3 SVIs

---

## 1. Spanning Tree Protocol (STP)

### The Problem: Layer 2 Loops

Redundant links between switches are desirable for **fault tolerance**, but they create a deadly problem: **broadcast storms**.

Without STP, a broadcast frame would:
1. Be flooded by Switch A to Switch B and Switch C
2. Switch B floods back to Switch A and to Switch C
3. Switch C floods to Switch A and Switch B
4. ∞ loop → **network crash** (CPU at 100%, MAC table instability)

### The Solution: STP (802.1D)

STP creates a **loop-free logical topology** by:
1. Electing a **Root Bridge** (the center of the tree)
2. Calculating the **shortest path** from every switch to the Root
3. **Blocking** redundant ports to eliminate loops
4. If an active link fails, STP **unblocks** a backup path

### Root Bridge Election

Every switch has a **Bridge ID (BID):**
```
Bridge ID = Bridge Priority (16 bits) + MAC Address (48 bits)
             Default: 32768           + unique per switch
```

**The switch with the LOWEST Bridge ID becomes Root Bridge.**

Election process:
1. All switches send BPDUs (Bridge Protocol Data Units) claiming to be root
2. Switches compare BIDs — lower BID wins
3. Eventually all agree on one root bridge
4. If priorities are equal, **lowest MAC address** wins

**To force a specific root:**
```
Switch(config)# spanning-tree vlan 1 root primary      ! Sets priority to 24576
Switch(config)# spanning-tree vlan 1 priority 4096     ! Manual priority (must be multiple of 4096)
```

### STP Cost

Each link has a **cost** based on bandwidth:

| Bandwidth | STP Cost |
|-----------|----------|
| 10 Mbps | 100 |
| 100 Mbps | 19 |
| 1 Gbps | 4 |
| 10 Gbps | 2 |

The path with the **lowest total cost** to the root bridge wins.

---

## 2. STP Port Roles and States

### Port Roles

| Role | Description |
|------|-------------|
| **Root Port** | The port with the BEST path to the root bridge (one per non-root switch) |
| **Designated Port** | The port that forwards traffic on each segment (one per segment) |
| **Blocked (Alternate) Port** | Redundant port that does NOT forward — prevents loops |

### How Port Roles Are Determined

1. **Root Bridge:** All its ports are **Designated** (it's the center)
2. **Other switches:** Calculate cost to root → port with lowest cost = **Root Port**
3. **Per segment:** The port that can offer the best path to root = **Designated**
4. **Remaining ports:** **Blocked**

### Tiebreakers (when costs are equal):
1. Lowest sender Bridge ID
2. Lowest sender Port Priority
3. Lowest sender Port Number

### STP Port States (802.1D)

| State | Duration | Sends/Receives BPDUs | Learns MACs | Forwards Data |
|-------|----------|---------------------|-------------|---------------|
| **Blocking** | 20 sec (max age) | Receives only | No | No |
| **Listening** | 15 sec (forward delay) | Yes | No | No |
| **Learning** | 15 sec (forward delay) | Yes | Yes | No |
| **Forwarding** | — | Yes | Yes | Yes |
| **Disabled** | — | No | No | No |

**Total convergence time: ~30-50 seconds** (this is why Rapid STP was created)

---

## 3. Rapid STP (802.1w)

RSTP improves convergence to **under 6 seconds** (often < 1 second).

### Key Differences from 802.1D

| Feature | STP (802.1D) | RSTP (802.1w) |
|---------|-------------|---------------|
| Convergence | 30-50 seconds | < 6 seconds |
| Port states | 5 (Blocking, Listening, Learning, Forwarding, Disabled) | 3 (Discarding, Learning, Forwarding) |
| Port roles | Root, Designated, Blocked | Root, Designated, Alternate, Backup |
| Proposal/Agreement | No | Yes (faster negotiation) |
| Backward compatible | — | Yes (falls back to 802.1D) |

### RSTP Port Roles

| Role | Purpose |
|------|---------|
| **Root** | Best path to root (same as STP) |
| **Designated** | Forwards on segment (same as STP) |
| **Alternate** | Backup for root port (instant failover!) |
| **Backup** | Backup for designated port (rare) |

---

## 4. STP Best Practices

### PortFast
- **Enables immediate transition to Forwarding** for access ports
- Skips Listening/Learning states → no 30-second wait for PCs
- **Only use on ports connected to end devices** (NOT switches!)

```
Switch(config-if)# spanning-tree portfast
! Or globally for all access ports:
Switch(config)# spanning-tree portfast default
```

### BPDU Guard
- **Shuts down a port** if it receives a BPDU
- Protects PortFast ports — if someone plugs in a rogue switch, the port disables

```
Switch(config-if)# spanning-tree bpduguard enable
! Or globally:
Switch(config)# spanning-tree portfast bpduguard default
```

### Root Guard
- Prevents an unauthorized switch from becoming root bridge
- Applied on designated ports facing other networks

```
Switch(config-if)# spanning-tree guard root
```

---

## 5. EtherChannel

EtherChannel bundles multiple physical links into one **logical link**, providing:
- **Increased bandwidth** (e.g., 2x 1 Gbps = 2 Gbps logical link)
- **Redundancy** (if one link fails, others continue)
- **STP sees one link** — no blocking of bundled ports

### EtherChannel Protocols

| Protocol | Standard | Negotiation | Modes |
|----------|----------|-------------|-------|
| **LACP** | IEEE 802.3ad | Dynamic | Active, Passive |
| **PAgP** | Cisco proprietary | Dynamic | Desirable, Auto |
| **Static** | — | None | On, On |

### LACP Mode Combinations

| Side A | Side B | Result |
|--------|--------|--------|
| Active | Active | ✅ Channel forms |
| Active | Passive | ✅ Channel forms |
| Passive | Passive | ❌ No channel (nobody initiates) |

### Configuration (LACP)

```
Switch(config)# interface range GigabitEthernet0/1 - 2
Switch(config-if-range)# channel-group 1 mode active
Switch(config-if-range)# exit

Switch(config)# interface Port-channel 1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk allowed vlan 10,20
```

### Verification

```
show etherchannel summary
show etherchannel port-channel
show interfaces port-channel 1
```

### EtherChannel Requirements (ALL must match):
- Same speed and duplex
- Same VLAN configuration (access VLAN or trunk allowed VLANs)
- Same STP settings
- Same mode (access or trunk)

---

## 6. Inter-VLAN Routing

VLANs isolate broadcast domains — a **router** is needed to route between them.

### Method 1: Router-on-a-Stick (802.1Q Sub-interfaces)

One physical router interface, multiple sub-interfaces — each in a different VLAN.

```
                    ┌────────┐
                    │ Router │
                    │ Gig0/0 │ (trunk)
                    └───┬────┘
                        │
                    ┌───┴────┐
                    │ Switch │
                    │ VL10   │ VL20
                    └───┬──┬─┘
                     PC1  PC2
```

**Router configuration:**
```
interface GigabitEthernet0/0
 no shutdown

interface GigabitEthernet0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0

interface GigabitEthernet0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
```

**Switch trunk to router:**
```
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
```

### Method 2: Layer 3 Switch with SVIs

A Layer 3 switch can route between VLANs **internally** — no external router needed.

```
Switch(config)# ip routing

Switch(config)# interface vlan 10
Switch(config-if)# ip address 192.168.10.1 255.255.255.0
Switch(config-if)# no shutdown

Switch(config)# interface vlan 20
Switch(config-if)# ip address 192.168.20.1 255.255.255.0
Switch(config-if)# no shutdown
```

### Comparison

| Feature | Router-on-a-Stick | L3 Switch (SVI) |
|---------|------------------|-----------------|
| Performance | Slower (single link bottleneck) | Faster (hardware routing) |
| Cost | Cheaper (basic router) | More expensive (L3 switch) |
| Scalability | Limited by trunk bandwidth | Scales well |
| Complexity | Simple for small networks | Better for enterprise |

---

## Quiz — Test Your Understanding

### Question 1
What problem does STP solve?

### Question 2
Three switches have these Bridge IDs:
- SW1: Priority 32768, MAC 0000.0000.0001
- SW2: Priority 32768, MAC 0000.0000.0003
- SW3: Priority 24576, MAC 0000.0000.0009

Which becomes the root bridge?

### Question 3
A switch has these paths to the root bridge:
- Path A: Via Gig0/1 (1 Gbps) → cost 4
- Path B: Via Fa0/1 (100 Mbps) → cost 19

Which becomes the root port?

### Question 4
What is PortFast, and why should it NEVER be enabled on a port connecting to another switch?

### Question 5
What is the advantage of EtherChannel over just having two separate links between switches?

### Question 6
In an LACP EtherChannel, what happens if one side is Active and the other is Passive?

### Question 7
Explain the difference between router-on-a-stick and a Layer 3 switch for inter-VLAN routing.

### Question 8
What happens if the physical interfaces in an EtherChannel have mismatched speed settings?

### Question 9
How does RSTP achieve faster convergence than STP?

### Question 10
You have a router-on-a-stick configuration. PC1 (VLAN 10: 192.168.10.10) can ping the router sub-interface 192.168.10.1 but cannot ping PC2 (VLAN 20: 192.168.20.20). What should you check?

---

<details>
<summary><strong>Click to reveal answers</strong></summary>

### Answer 1
STP prevents **Layer 2 loops** (broadcast storms) in networks with redundant switch links. It creates a loop-free logical topology by blocking redundant ports while keeping them available as backups.

### Answer 2
**SW3** becomes root bridge. Despite having the highest MAC, it has the **lowest priority** (24576 < 32768). Priority is compared first.

### Answer 3
**Path A (Gig0/1)** becomes the root port because it has the lowest cost (4 < 19). The root port is always the port with the best (lowest cost) path to the root bridge.

### Answer 4
PortFast allows a port to **skip Listening and Learning states** and go directly to Forwarding. This prevents the 30-second delay for end devices. It should NEVER be on a switch-to-switch port because if a loop forms, STP won't have time to detect and block it — causing a broadcast storm. **BPDU Guard** should be paired with PortFast as a safety net.

### Answer 5
With two separate links, STP would **block one** to prevent a loop — wasting half the bandwidth. EtherChannel bundles both links into one logical link that STP sees as a single path, so **both links are active** and load-balanced.

### Answer 6
The EtherChannel **forms successfully.** Active mode initiates LACP negotiation, and Passive mode responds. The only combination that fails is Passive + Passive (nobody initiates).

### Answer 7
- **Router-on-a-stick:** Uses a physical router with 802.1Q sub-interfaces. Simple but limited by the single trunk link bandwidth. Good for small networks.
- **Layer 3 switch:** Has built-in routing via SVIs. Routes between VLANs in hardware at wire speed. Better performance and scalability for enterprise networks.

### Answer 8
The EtherChannel **will not form.** All member interfaces must have matching speed, duplex, VLAN configuration, and trunk mode. A mismatch causes the channel to stay down or individual links to be suspended.

### Answer 9
RSTP uses:
- **Proposal/Agreement mechanism** for fast designated port election
- **Alternate port** role — instant failover when root port fails (no waiting)
- Only 3 port states (Discarding, Learning, Forwarding) instead of 5
- Convergence in **< 6 seconds** vs. 30-50 seconds for STP

### Answer 10
Check:
1. Is the sub-interface Gig0/0.20 configured with `encapsulation dot1Q 20` and IP `192.168.20.1`?
2. Is the trunk between switch and router allowing VLAN 20? (`show interfaces trunk`)
3. Is PC2's default gateway set to 192.168.20.1?
4. Is the access port for PC2 in VLAN 20? (`show vlan brief`)

</details>

---

## Key Takeaways

1. **STP** prevents loops by electing a root bridge and blocking redundant ports
2. **Root bridge** = lowest Bridge ID (priority first, then MAC)
3. **RSTP** converges in < 6 sec; use **PortFast + BPDU Guard** on access ports
4. **EtherChannel** bundles links — use **LACP** (Active/Passive) — all member settings must match
5. **Inter-VLAN routing:** Router-on-a-stick (sub-interfaces) for small networks, L3 switch (SVIs) for enterprise
6. Key commands: `show spanning-tree`, `show etherchannel summary`, `show vlan brief`

---

**Next:** [Exercises →](exercises.md)
