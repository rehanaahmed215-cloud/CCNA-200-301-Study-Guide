# Week 5 — Exercises: STP, EtherChannel & Inter-VLAN Routing

## Table of Contents
- [Lab Overview](#lab-overview)
- [Part A: Containerlab — Inter-VLAN Routing with FRR](#part-a-containerlab--inter-vlan-routing-with-frr)
  - [Exercise 1: Deploy Router-on-a-Stick Topology](#exercise-1-deploy-router-on-a-stick-topology)
  - [Exercise 2: Verify Inter-VLAN Routing](#exercise-2-verify-inter-vlan-routing)
  - [Exercise 3: Convert to L3 Switch Routing](#exercise-3-convert-to-l3-switch-routing)
  - [Exercise 4: Clean Up](#exercise-4-clean-up)
- [Part B: Cisco Packet Tracer — STP, EtherChannel, Inter-VLAN](#part-b-cisco-packet-tracer--stp-etherchannel-inter-vlan)
  - [Exercise PT-1: Build the 3-Switch Triangle](#exercise-pt-1-build-the-3-switch-triangle)
  - [Exercise PT-2: Investigate STP](#exercise-pt-2-investigate-stp)
  - [Exercise PT-3: Force Root Bridge](#exercise-pt-3-force-root-bridge)
  - [Exercise PT-4: Configure EtherChannel (LACP)](#exercise-pt-4-configure-etherchannel-lacp)
  - [Exercise PT-5: Router-on-a-Stick](#exercise-pt-5-router-on-a-stick)
  - [Exercise PT-6: Convert to L3 Switch SVIs](#exercise-pt-6-convert-to-l3-switch-svis)
- [Verification Checklist](#verification-checklist)

---

## Lab Overview

In this lab, you will:
1. Configure inter-VLAN routing in Containerlab (router-on-a-stick concept)
2. Use Packet Tracer for full STP, EtherChannel, and inter-VLAN routing practice
3. Identify root bridges and port roles
4. Bundle links with LACP EtherChannel

> **Note:** STP and EtherChannel are Cisco switch features — **Packet Tracer is the primary tool this week.**

---

## Part A: Containerlab — Inter-VLAN Routing with FRR

### Exercise 1: Deploy Router-on-a-Stick Topology

This simulates inter-VLAN routing using FRR as the router and separate bridges per VLAN.

```
  VLAN 10              VLAN 20
  ┌──────┐             ┌──────┐
  │ PC1  │             │ PC2  │
  │.10   │             │.10   │
  └──┬───┘             └──┬───┘
     │                    │
  [Bridge10]          [Bridge20]
     │                    │
     └────── Router ──────┘
         .1 (eth1)  .1 (eth2)
  192.168.10.0/24   192.168.20.0/24
```

```bash
cd ~/Desktop/CCNA/week-05/lab/
containerlab deploy -t topology.yml
```

> **Tip — Connecting to nodes:**
> Use `lab <node>` to open a shell inside a container. All commands below assume you are **inside** the container's shell.
>
> ```bash
> lab router       # opens a shell on the router
> lab pc1          # opens a shell on PC1
> lab --all        # opens a tab for every node
> ```

### Exercise 2: Verify Inter-VLAN Routing

**On the router** (`lab router`):
```bash
ip addr show
```

**On PC1** (`lab pc1`):
```bash
# Ping PC2 (VLAN 20) from PC1 (VLAN 10)
ping -c 3 192.168.20.10
```

**On PC1** — traceroute to see the router hop:
```bash
traceroute 192.168.20.10
```

**What to observe:** The packet goes PC1 → Router (192.168.10.1) → PC2. The router is the gateway between VLANs.

**On the router** — check the routing table:
```bash
ip route
```

You should see connected routes for both 192.168.10.0/24 and 192.168.20.0/24.

### Exercise 3: Convert to L3 Switch Routing

In this exercise, we replace the router with a Linux host that has both interfaces — simulating how an L3 switch routes between VLANs internally.

**On PC1** (`lab pc1`):
```bash
# The router already has both subnets — it IS functioning as an L3 device
# Ping the router's VLAN 20 interface
ping -c 2 192.168.20.1
```

**On PC2** (`lab pc2`):
```bash
# Ping the router's VLAN 10 interface
ping -c 2 192.168.10.1
```

### Exercise 4: Clean Up

Exit all container shells (type `exit`), then from your Mac terminal:
```bash
cd ~/Desktop/CCNA/week-05/lab/
lab destroy
```

---

## Part B: Cisco Packet Tracer — STP, EtherChannel, Inter-VLAN

### Exercise PT-1: Build the 3-Switch Triangle

**Place:** 3 Switches (2960), 3 PCs

**Connections (redundant triangle):**
| Link | From | To |
|------|------|----|
| 1 | SW1 Fa0/23 | SW2 Fa0/23 |
| 2 | SW2 Fa0/24 | SW3 Fa0/24 |
| 3 | SW1 Fa0/24 | SW3 Fa0/23 |

**PCs:**
| PC | Switch Port | IP | VLAN |
|----|------------|-----|------|
| PC0 | SW1 Fa0/1 | 192.168.10.10/24 | 10 |
| PC1 | SW2 Fa0/1 | 192.168.10.20/24 | 10 |
| PC2 | SW3 Fa0/1 | 192.168.10.30/24 | 10 |

**On all 3 switches, create VLAN 10 and assign PC ports:**
```
enable
configure terminal
vlan 10
 name Sales
 exit
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
 exit
```

**Configure trunks on all inter-switch links:**
```
! On each switch, for each inter-switch port:
interface FastEthernet0/23
 switchport mode trunk
 switchport trunk allowed vlan 10
 exit
interface FastEthernet0/24
 switchport mode trunk
 switchport trunk allowed vlan 10
 exit
```

### Exercise PT-2: Investigate STP

**Step 1:** On each switch, run:
```
show spanning-tree vlan 10
```

**Step 2:** Identify:
- Which switch is the **Root Bridge**? (Look for "This bridge is the root")
- On non-root switches, which port is the **Root Port**?
- Which port is in **Blocking** (BLK) state?

**Step 3:** Draw the topology on paper. Label each port with its role:
- R = Root Port
- D = Designated Port
- B = Blocked/Alternate Port

### Exercise PT-3: Force Root Bridge

**Step 1:** Choose SW1 as root bridge:
```
SW1(config)# spanning-tree vlan 10 root primary
```

**Step 2:** Verify:
```
SW1# show spanning-tree vlan 10
```
SW1 should now show "This bridge is the root" and priority 24576.

**Step 3:** Check the other switches — their root ports should now point toward SW1.

### Exercise PT-4: Configure EtherChannel (LACP)

**Step 1:** Remove existing trunk config on SW1↔SW2 links, then add a second link:
- SW1 Fa0/23 — SW2 Fa0/23 (already exists)
- SW1 Fa0/22 — SW2 Fa0/22 (add this cable)

**Step 2:** Configure LACP on SW1:
```
SW1(config)# interface range FastEthernet0/22 - 23
SW1(config-if-range)# channel-group 1 mode active
SW1(config-if-range)# exit
SW1(config)# interface Port-channel1
SW1(config-if)# switchport mode trunk
SW1(config-if)# switchport trunk allowed vlan 10
```

**Step 3:** Configure LACP on SW2:
```
SW2(config)# interface range FastEthernet0/22 - 23
SW2(config-if-range)# channel-group 1 mode passive
SW2(config-if-range)# exit
SW2(config)# interface Port-channel1
SW2(config-if)# switchport mode trunk
SW2(config-if)# switchport trunk allowed vlan 10
```

**Step 4:** Verify:
```
show etherchannel summary
```

Expected output:
```
Group  Port-channel  Protocol    Ports
------+-------------+-----------+---------
1      Po1(SU)       LACP       Fa0/22(P) Fa0/23(P)
```
- `SU` = Layer 2, in use
- `P` = Bundled in port-channel

### Exercise PT-5: Router-on-a-Stick

**Step 1:** Add VLAN 20 to the topology:
- Add PC3 (192.168.20.10/24) to SW1 Fa0/2 in VLAN 20
- Update trunks to allow VLANs 10 and 20

**Step 2:** Add a Router (2911). Connect Router Gig0/0 to SW1 Gig0/1.

**Step 3:** Configure the switch trunk to router:
```
SW1(config)# interface GigabitEthernet0/1
SW1(config-if)# switchport mode trunk
SW1(config-if)# switchport trunk allowed vlan 10,20
```

**Step 4:** Configure router sub-interfaces:
```
Router(config)# interface GigabitEthernet0/0
Router(config-if)# no shutdown

Router(config)# interface GigabitEthernet0/0.10
Router(config-subif)# encapsulation dot1Q 10
Router(config-subif)# ip address 192.168.10.1 255.255.255.0

Router(config)# interface GigabitEthernet0/0.20
Router(config-subif)# encapsulation dot1Q 20
Router(config-subif)# ip address 192.168.20.1 255.255.255.0
```

**Step 5:** Set default gateways on PCs:
- VLAN 10 PCs: gateway = 192.168.10.1
- VLAN 20 PCs: gateway = 192.168.20.1

**Step 6:** Test: Ping PC0 (VLAN 10) → PC3 (VLAN 20). Should now work!

### Exercise PT-6: Convert to L3 Switch SVIs

**Step 1:** Remove the router. Replace SW1 with a **3560** (Layer 3 switch).

**Step 2:** Configure SVIs:
```
Switch(config)# ip routing

Switch(config)# interface vlan 10
Switch(config-if)# ip address 192.168.10.1 255.255.255.0
Switch(config-if)# no shutdown

Switch(config)# interface vlan 20
Switch(config-if)# ip address 192.168.20.1 255.255.255.0
Switch(config-if)# no shutdown
```

**Step 3:** Update PC gateways to point to SVIs (same IPs as before).

**Step 4:** Test inter-VLAN ping. Should work without an external router!

---

## Verification Checklist

- [ ] I can identify the STP root bridge using `show spanning-tree`
- [ ] I can identify Root, Designated, and Blocked ports
- [ ] I can force a specific switch to be root bridge
- [ ] I can configure LACP EtherChannel and verify with `show etherchannel summary`
- [ ] I can configure router-on-a-stick (sub-interfaces, `encapsulation dot1Q`)
- [ ] I can configure L3 switch SVIs with `ip routing`
- [ ] I understand why PortFast + BPDU Guard matter for access ports

---

**Next:** [Challenges →](challenges.md)
