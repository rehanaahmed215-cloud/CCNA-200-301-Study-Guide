# Week 5 — Challenges: STP, EtherChannel & Inter-VLAN Routing

## Table of Contents
- [Challenge 1: EtherChannel Misconfiguration Troubleshooting](#challenge-1-etherchannel-misconfiguration-troubleshooting)
- [Challenge 2: Draw the STP Topology](#challenge-2-draw-the-stp-topology)
- [Challenge 3: PortFast and BPDU Guard Lab](#challenge-3-portfast-and-bpdu-guard-lab)
- [Challenge 4: Full Enterprise Topology Build](#challenge-4-full-enterprise-topology-build)
- [Challenge 5: STP Root Bridge Manipulation](#challenge-5-stp-root-bridge-manipulation)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: EtherChannel Misconfiguration Troubleshooting

**Task:** In Packet Tracer, configure an EtherChannel between two switches, but **intentionally misconfigure** it in each of these ways (one at a time). Diagnose and fix using `show` commands.

**Misconfigurations to test:**

1. **Mode mismatch:** SW1 = `mode active`, SW2 = `mode desirable` (LACP vs PAgP)
2. **Speed mismatch:** One link at 100 Mbps, other at auto
3. **VLAN mismatch:** One port in VLAN 10, other in VLAN 20 within the same channel-group
4. **Trunk mismatch:** One side trunk, other side access

**For each, document:**
- The error symptoms (port status, `show etherchannel summary` output)
- Which `show` command revealed the problem
- The fix applied

<details>
<summary><strong>Key diagnostics</strong></summary>

```
show etherchannel summary    ← Look for (SD) = suspended, (I) = individual
show etherchannel detail     ← Detailed status per port
show interfaces status       ← Speed/duplex/VLAN per port
show interfaces trunk        ← Trunk status
show spanning-tree           ← STP status (may show inconsistent ports)
```

**Fixes:**
1. Both sides must use the **same protocol** (LACP or PAgP, not mixed)
2. All member ports must have **matching speed/duplex**
3. All member ports must be in the **same VLAN** (or same trunk config)
4. All member ports must be **same mode** (all trunk or all access)

</details>

---

## Challenge 2: Draw the STP Topology

**Task:** Given this network, determine all STP port roles WITHOUT using a simulator.

```
        SW1 (Priority: 32768, MAC: 0000.0000.0001)
       /    \
   Gig     Gig
    /        \
SW2           SW3
(Pri:32768   (Pri:32768
MAC:0000.    MAC:0000.
0000.0005)   0000.0003)
    \        /
   Fast    Fast
     \    /
      SW4
  (Pri:32768
  MAC:0000.
  0000.0009)
```

Link speeds: SW1↔SW2 = Gig (cost 4), SW1↔SW3 = Gig (cost 4), SW2↔SW4 = Fast (cost 19), SW3↔SW4 = Fast (cost 19)

**Determine:**
1. Which switch is the root bridge?
2. What is the root port on each non-root switch?
3. What is the designated port on each segment?
4. Which port(s) are blocked?

<details>
<summary><strong>Check your answer</strong></summary>

**1. Root Bridge:** SW1 (lowest MAC: 0000.0000.0001, all priorities equal at 32768)

**2. Root Ports (best path to root):**
- SW2: Port facing SW1 (cost 4) — this is the Root Port
- SW3: Port facing SW1 (cost 4) — this is the Root Port
- SW4: Two paths:
  - Via SW2: cost 4 (SW2→SW1) + 19 (SW4→SW2) = **23**
  - Via SW3: cost 4 (SW3→SW1) + 19 (SW4→SW3) = **23**
  - **Tie!** → Tiebreaker: lowest sender BID → SW3 (MAC 0003) < SW2 (MAC 0005)
  - SW4's Root Port: **port facing SW3**

**3. Designated Ports:**
- SW1: Both ports are **Designated** (root bridge, all ports designated)
- SW2→SW4: SW2's port toward SW4 = **cost to root is 4**
- SW3→SW4: SW3's port toward SW4 = **cost to root is 4**
  - Both offer cost 4 to root → tiebreaker: lowest BID → SW3 (0003) wins
  - SW3's port toward SW4 = **Designated**

**4. Blocked Port:**
- SW2's port toward SW4 = **Blocked** (Alternate) — it lost the designated port election to SW3

</details>

---

## Challenge 3: PortFast and BPDU Guard Lab

**Task:** In Packet Tracer:

1. Configure **PortFast** on all access ports connected to PCs
2. Configure **BPDU Guard** on those same ports
3. Connect a **second switch** to one of those PortFast ports
4. Observe what happens

**Commands:**
```
interface FastEthernet0/1
 spanning-tree portfast
 spanning-tree bpduguard enable
```

**Document:**
- What happens to the port when the rogue switch sends BPDUs?
- What message appears in the log?
- How do you recover the port? (`shutdown` then `no shutdown`)
- Why is this combination critical for security?

<details>
<summary><strong>Expected behavior</strong></summary>

When a switch is connected to a PortFast + BPDU Guard port:
1. The rogue switch sends BPDUs
2. BPDU Guard detects BPDUs on a PortFast port
3. The port enters **err-disabled** state immediately
4. Log message: `%PM-4-ERR_DISABLE: bpduguard error detected on Fa0/1`

**Recovery:**
```
interface FastEthernet0/1
 shutdown
 no shutdown
```

Or automatic recovery:
```
errdisable recovery cause bpduguard
errdisable recovery interval 300
```

</details>

---

## Challenge 4: Full Enterprise Topology Build

**Task:** Build this complete topology in Packet Tracer from scratch:

**Requirements:**
- 3 switches in a triangle (SW1, SW2, SW3)
- EtherChannel (LACP, 2-link bundle) between SW1↔SW2
- Regular trunk links SW2↔SW3 and SW1↔SW3
- VLANs: 10 (Sales), 20 (IT), 30 (Management)
- 2 PCs per VLAN (distributed across switches)
- Router-on-a-stick for inter-VLAN routing
- PortFast + BPDU Guard on all access ports
- SW1 forced as root bridge for all VLANs
- Native VLAN changed to 99 on all trunks

**Verification:** All PCs can ping all other PCs, regardless of VLAN or switch.

<details>
<summary><strong>Topology hints</strong></summary>

**IP Scheme:**
- VLAN 10: 192.168.10.0/24, Gateway: .1
- VLAN 20: 192.168.20.0/24, Gateway: .1
- VLAN 30: 192.168.30.0/24, Gateway: .1

**Router sub-interfaces:**
```
interface Gig0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
interface Gig0/0.20
 encapsulation dot1Q 20
 ip address 192.168.20.1 255.255.255.0
interface Gig0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
```

**EtherChannel:**
```
interface range Fa0/23-24
 channel-group 1 mode active
interface Port-channel1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,30
 switchport trunk native vlan 99
```

</details>

---

## Challenge 5: STP Root Bridge Manipulation

**Task:** Using the 3-switch triangle from Exercise PT-1:

1. Note which switch is currently root bridge (by default)
2. Force **SW3** to be root for VLAN 10
3. Force **SW2** to be root for VLAN 20
4. Verify each VLAN has a different root bridge
5. Observe that the blocked ports are DIFFERENT for each VLAN

**Commands:**
```
SW3(config)# spanning-tree vlan 10 root primary
SW2(config)# spanning-tree vlan 20 root primary
```

**Verify:**
```
show spanning-tree vlan 10
show spanning-tree vlan 20
```

**Questions:**
- What port roles change when you change the root bridge?
- Why might you want different root bridges for different VLANs? (hint: load balancing)

<details>
<summary><strong>Answer</strong></summary>

Having different root bridges per VLAN is a form of **STP load balancing**. For example:
- VLAN 10 traffic primarily flows through SW3 (root) → links toward SW3 are forwarding
- VLAN 20 traffic primarily flows through SW2 (root) → links toward SW2 are forwarding

This distributes traffic across different physical paths instead of routing everything through one switch. The blocked ports for VLAN 10 may be forwarding for VLAN 20, and vice versa.

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. EtherChannel troubleshooting | ⭐⭐ Medium | 20 minutes |
| 2. Draw STP topology | ⭐⭐⭐ Hard | 15 minutes |
| 3. PortFast + BPDU Guard | ⭐⭐ Medium | 15 minutes |
| 4. Full enterprise build | ⭐⭐⭐ Hard | 45 minutes |
| 5. Root bridge manipulation | ⭐⭐ Medium | 15 minutes |

---

**Week 5 complete! → [Start Week 6](../week-06/concepts.md)**
