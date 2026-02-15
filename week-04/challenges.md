# Week 4 — Challenges: Ethernet, Switching & VLANs

## Table of Contents
- [Challenge 1: Triangle Topology — Broadcast Storm](#challenge-1-triangle-topology--broadcast-storm)
- [Challenge 2: Native VLAN Security Lab](#challenge-2-native-vlan-security-lab)
- [Challenge 3: Small Company VLAN Design](#challenge-3-small-company-vlan-design)
- [Challenge 4: MAC Address Table Analysis](#challenge-4-mac-address-table-analysis)
- [Challenge 5: VLAN Troubleshooting Scenarios](#challenge-5-vlan-troubleshooting-scenarios)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Triangle Topology — Broadcast Storm

**Task:** In Packet Tracer, build a 3-switch triangle topology:

```
     Switch1
    /       \
Switch2 ── Switch3
```

1. Connect Switch1↔Switch2, Switch2↔Switch3, Switch1↔Switch3
2. Add one PC to each switch
3. Assign all PCs to the same VLAN with IPs in 192.168.1.0/24
4. **Do NOT configure STP** (it's on by default, so leave it)
5. Observe: what happens when you ping?

**Questions to answer:**
- What would happen if STP were disabled? (research "broadcast storm")
- Which switch became the root bridge? (check `show spanning-tree`)
- Which port(s) are in blocking state?

<details>
<summary><strong>What to expect</strong></summary>

With STP enabled (default), one of the ports in the triangle will be in a **Blocking** state. This prevents loops.

If STP were disabled, a broadcast frame would:
1. Be flooded by Switch1 to Switch2 and Switch3
2. Switch2 floods to Switch3, Switch3 floods to Switch2
3. Infinite loop → **broadcast storm** → network crash

Check with `show spanning-tree`:
- The switch with the **lowest bridge priority** (or lowest MAC if tied) becomes root bridge
- Look for port roles: Root, Designated, or Blocking (Alternate)

**This is the motivation for Week 5's STP deep-dive!**

</details>

---

## Challenge 2: Native VLAN Security Lab

**Task:** Configure a trunk with a non-default native VLAN across your 2-switch setup:

1. Create VLAN 99 on both switches (name it "NativeVLAN")
2. Set the native VLAN to 99 on both trunk links
3. Verify with `show interfaces trunk`
4. Create VLAN 999 (name it "Blackhole") — assign all **unused** ports to VLAN 999
5. Shut down all unused ports

**Commands to use:**
```
! Assign unused ports to blackhole VLAN
interface range FastEthernet0/3 - 24
 switchport mode access
 switchport access vlan 999
 shutdown
```

**Questions:**
- Why is putting unused ports in a separate VLAN and shutting them a security best practice?
- What attack does this help prevent? (research "VLAN hopping")

<details>
<summary><strong>Check your answer</strong></summary>

**Why blackhole unused ports:**
- Prevents unauthorized devices from being plugged in and gaining network access
- An attacker plugging into an unused port would end up in VLAN 999 with no connectivity
- Shutting the port adds another layer — the port won't even come up

**VLAN hopping attacks:**
1. **Switch spoofing:** Attacker configures their NIC to act like a trunk (negotiate DTP). Countermeasure: `switchport mode access` on all access ports, `switchport nonegotiate` on trunks.
2. **Double tagging:** Attacker sends a frame with TWO 802.1Q tags. The first tag matches the native VLAN (stripped by the first switch), the second tag pushes the frame into a target VLAN. Countermeasure: change native VLAN to something unused.

</details>

---

## Challenge 3: Small Company VLAN Design

**Scenario:** Design a complete VLAN scheme for a small company with:
- HR Department: 15 users
- IT Department: 10 users
- Guest WiFi: 50 users
- Management (switches, APs): dedicated VLAN
- Native VLAN: dedicated, unused

**Deliverables:**

| VLAN ID | Name | Subnet | Usable Range | Purpose |
|---------|------|--------|-------------|---------|
| ? | ? | ? | ? | ? |

Also document:
1. Which ports on each switch go to which VLAN
2. Trunk configuration between switches
3. How many switches you need and where they're placed
4. Which subnet should be used for switch management SVIs?

<details>
<summary><strong>Sample design</strong></summary>

| VLAN ID | Name | Subnet | Usable Range | Hosts |
|---------|------|--------|-------------|-------|
| 10 | HR | 192.168.10.0/27 | .1–.30 | 15 |
| 20 | IT | 192.168.20.0/28 | .1–.14 | 10 |
| 30 | GuestWiFi | 192.168.30.0/26 | .1–.62 | 50 |
| 40 | Management | 192.168.40.0/28 | .1–.14 | Switches/APs |
| 99 | NativeVLAN | — | — | Trunk native |
| 999 | Blackhole | — | — | Unused ports |

**Switch layout (2 switches):**
- Switch1 (Main): Fa0/1-15 = VLAN 10 (HR), Fa0/16-24 = VLAN 20 (IT), Gig0/1 = Trunk
- Switch2 (Wireless/Guest): Fa0/1-4 = VLAN 30 (Guest APs), Gig0/1 = Trunk

**Trunk config:**
```
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40
switchport trunk native vlan 99
switchport nonegotiate
```

**Management:** Access switches via SVIs on VLAN 40:
```
interface vlan 40
 ip address 192.168.40.1 255.255.255.240
 no shutdown
```

</details>

---

## Challenge 4: MAC Address Table Analysis

**Scenario:** Given this network and MAC table, answer the questions below.

**Topology:**
```
PC-A (MAC: AAAA) ── Fa0/1 ─┐
PC-B (MAC: BBBB) ── Fa0/2 ─┤ Switch1 ── Gig0/1 (trunk) ── Gig0/1 ── Switch2 ┬─ Fa0/1 ── PC-C (MAC: CCCC)
PC-D (MAC: DDDD) ── Fa0/3 ─┘                                                  └─ Fa0/2 ── PC-E (MAC: EEEE)
```

**Switch1 MAC Table:**
| MAC | Port | VLAN |
|-----|------|------|
| AAAA | Fa0/1 | 10 |
| BBBB | Fa0/2 | 20 |
| CCCC | Gig0/1 | 10 |

**Questions:**
1. PC-A sends a frame to PC-C. What does Switch1 do?
2. PC-A sends a frame to PC-E. What does Switch1 do?
3. PC-D (MAC: DDDD, VLAN 10) sends a frame to PC-B (VLAN 20). What happens?
4. A new device (MAC: FFFF) is plugged into Fa0/4 and sends a frame. What does Switch1 do with the source MAC?

<details>
<summary><strong>Check your answers</strong></summary>

**1.** PC-A → PC-C: Switch1 looks up CCCC in MAC table → found on Gig0/1 → **forwards** the frame out Gig0/1 (trunk) with VLAN 10 tag. Switch2 receives it and forwards to its Fa0/1 port.

**2.** PC-A → PC-E (MAC: EEEE): Switch1 looks up EEEE → **not found** → **floods** the frame to ALL ports in VLAN 10 (not VLAN 20). Since EEEE is not in the MAC table, the frame goes out Gig0/1 (trunk, VLAN 10 tag). It does NOT go to PC-B (different VLAN) or PC-D (unless PC-D is in VLAN 10).

**3.** PC-D (VLAN 10) → PC-B (VLAN 20): **Fails.** Even though both are on Switch1, they're in different VLANs. The switch will NOT forward between VLANs — a router is required.

**4.** New device FFFF on Fa0/4: Switch1 **learns** FFFF → Fa0/4, and adds it to the MAC table for whatever VLAN Fa0/4 is assigned to.

</details>

---

## Challenge 5: VLAN Troubleshooting Scenarios

**For each scenario, identify the problem and provide the fix:**

### Scenario A
PC0 (VLAN 10, Switch1) cannot ping PC2 (VLAN 10, Switch2), even though a cable connects Gig0/1 on both switches.

`show interfaces trunk` on Switch1 shows nothing.

### Scenario B
PC0 (VLAN 10) and PC1 (VLAN 20) are on the same switch. A router-on-a-stick is connected to Gig0/1. PCs still can't reach the other VLAN.

`show interfaces trunk` shows Gig0/1 is trunking with `allowed vlan 1`.

### Scenario C
Cross-switch ping works for VLAN 10 but not VLAN 20.

`show interfaces trunk` on Switch1: `allowed vlan 10`
`show interfaces trunk` on Switch2: `allowed vlan 10,20`

<details>
<summary><strong>Check your answers</strong></summary>

**Scenario A:** The trunk was never configured. The link between switches is still in access mode (default).
**Fix:**
```
Switch1(config-if)# switchport mode trunk
Switch2(config-if)# switchport mode trunk
```

**Scenario B:** The trunk only allows VLAN 1 (default). VLANs 10 and 20 are not permitted on the trunk.
**Fix:**
```
Switch(config-if)# switchport trunk allowed vlan 10,20
```
Or: `switchport trunk allowed vlan add 10,20`

**Scenario C:** Switch1 only allows VLAN 10 on the trunk. VLAN 20 traffic from Switch2 is blocked at Switch1.
**Fix:**
```
Switch1(config-if)# switchport trunk allowed vlan add 20
```

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Broadcast storm | ⭐⭐ Medium | 20 minutes |
| 2. Native VLAN security | ⭐⭐ Medium | 15 minutes |
| 3. Company VLAN design | ⭐⭐⭐ Hard | 30 minutes |
| 4. MAC table analysis | ⭐⭐ Medium | 10 minutes |
| 5. Troubleshooting | ⭐⭐ Medium | 15 minutes |

---

**Week 4 complete! → [Start Week 5](../week-05/concepts.md)**
