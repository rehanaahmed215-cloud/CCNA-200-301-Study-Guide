# Week 4 — Exercises: Ethernet, Switching & VLANs

## Table of Contents
- [Lab Overview](#lab-overview)
- [Part A: Containerlab Lab — Switch Behavior & VLANs](#part-a-containerlab-lab--switch-behavior--vlans)
  - [Exercise 1: Deploy the Topology](#exercise-1-deploy-the-topology)
  - [Exercise 2: Observe Switch MAC Learning](#exercise-2-observe-switch-mac-learning)
  - [Exercise 3: Observe Broadcast Flooding](#exercise-3-observe-broadcast-flooding)
  - [Exercise 4: VLAN Isolation with Linux Bridges](#exercise-4-vlan-isolation-with-linux-bridges)
  - [Exercise 5: Clean Up](#exercise-5-clean-up)
- [Part B: Cisco Packet Tracer Lab — Full VLAN Configuration](#part-b-cisco-packet-tracer-lab--full-vlan-configuration)
  - [Exercise PT-1: Build the Topology](#exercise-pt-1-build-the-topology)
  - [Exercise PT-2: Create VLANs and Assign Ports](#exercise-pt-2-create-vlans-and-assign-ports)
  - [Exercise PT-3: Verify VLANs](#exercise-pt-3-verify-vlans)
  - [Exercise PT-4: Configure Trunking](#exercise-pt-4-configure-trunking-between-switches)
  - [Exercise PT-5: Verify Cross-Switch VLANs](#exercise-pt-5-verify-cross-switch-vlans)
  - [Exercise PT-6: Change Native VLAN](#exercise-pt-6-change-native-vlan)
- [Verification Checklist](#verification-checklist)

---

## Lab Overview

In this lab, you will:
1. Observe how switches learn MAC addresses and flood unknown unicasts
2. Create VLANs and verify isolation
3. Configure trunk links between switches
4. Test cross-switch VLAN communication

> **Note:** VLANs are a switch-specific feature. The Containerlab exercises demonstrate switching concepts with Linux bridges, but **Cisco Packet Tracer** is the primary tool this week for full VLAN/trunk CLI practice.

---

## Part A: Containerlab Lab — Switch Behavior & VLANs

### Exercise 1: Deploy the Topology

```bash
cd ~/Desktop/CCNA/week-04/lab/
sudo containerlab deploy -t topology.yml
```

Our topology: 4 hosts connected to a Linux bridge (acting as a switch).

```
┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
│ PC1  │  │ PC2  │  │ PC3  │  │ PC4  │
│ .10  │  │ .20  │  │ .30  │  │ .40  │
└──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘
   │         │         │         │
┌──┴─────────┴─────────┴─────────┴───┐
│          Switch (Bridge)            │
└─────────────────────────────────────┘
         192.168.1.0/24
```

### Exercise 2: Observe Switch MAC Learning

**Step 1:** Check the bridge's MAC table (forwarding database)
```bash
docker exec clab-week04-switch bridge fdb show
```

**Step 2:** Ping from PC1 to PC2
```bash
docker exec clab-week04-pc1 ping -c 2 192.168.1.20
```

**Step 3:** Check the MAC table again
```bash
docker exec clab-week04-switch bridge fdb show | grep -v permanent
```

**What to observe:** New entries appear showing which MAC addresses were learned on which ports.

### Exercise 3: Observe Broadcast Flooding

**Step 1:** Start tcpdump on PC3 and PC4
```bash
docker exec clab-week04-pc3 tcpdump -i eth1 -n -c 5 &
docker exec clab-week04-pc4 tcpdump -i eth1 -n -c 5 &
```

**Step 2:** Send a broadcast ping from PC1
```bash
docker exec clab-week04-pc1 ping -c 1 -b 192.168.1.255
```

**What to observe:** PC3 and PC4 both see the broadcast — this is switch flooding behavior. All ports in the same broadcast domain receive broadcasts.

### Exercise 4: VLAN Isolation with Linux Bridges

We'll create two separate bridges to simulate two VLANs.

**Step 1:** This is pre-configured in the topology. Check:
```bash
# PC1 and PC2 should be able to ping (same "VLAN")
docker exec clab-week04-pc1 ping -c 2 192.168.1.20

# PC1 and PC3 will NOT be able to ping if on separate bridges
docker exec clab-week04-pc1 ping -c 2 192.168.1.30
```

**Key insight:** VLANs create separate broadcast domains. Without a router, hosts in different VLANs cannot communicate — just like separate physical switches.

### Exercise 5: Clean Up

```bash
cd ~/Desktop/CCNA/week-04/lab/
sudo containerlab destroy -t topology.yml
```

---

## Part B: Cisco Packet Tracer Lab — Full VLAN Configuration

**This is the primary lab for this week.** VLANs, trunks, and 802.1Q are best practiced in Packet Tracer.

### Exercise PT-1: Build the Topology

**Place these devices:**
- 2 Switches (2960-24TT)
- 4 PCs

**Connections:**
| Device | Port | Connect To | Port |
|--------|------|-----------|------|
| PC0 | Fa0 | Switch1 | Fa0/1 |
| PC1 | Fa0 | Switch1 | Fa0/2 |
| PC2 | Fa0 | Switch2 | Fa0/1 |
| PC3 | Fa0 | Switch2 | Fa0/2 |
| Switch1 | Gig0/1 | Switch2 | Gig0/1 |

**Assign IPs:**
| PC | IP Address | Subnet Mask | Default Gateway |
|----|-----------|-------------|-----------------|
| PC0 | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 |
| PC1 | 192.168.20.10 | 255.255.255.0 | 192.168.20.1 |
| PC2 | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 |
| PC3 | 192.168.20.20 | 255.255.255.0 | 192.168.20.1 |

### Exercise PT-2: Create VLANs and Assign Ports

**On Switch1:**
```
enable
configure terminal

! Create VLANs
vlan 10
 name Sales
 exit
vlan 20
 name Engineering
 exit

! Assign ports to VLANs
interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
 exit

interface FastEthernet0/2
 switchport mode access
 switchport access vlan 20
 exit
```

**On Switch2 (same VLAN configuration):**
```
enable
configure terminal

vlan 10
 name Sales
 exit
vlan 20
 name Engineering
 exit

interface FastEthernet0/1
 switchport mode access
 switchport access vlan 10
 exit

interface FastEthernet0/2
 switchport mode access
 switchport access vlan 20
 exit
```

### Exercise PT-3: Verify VLANs

**On both switches, run these commands:**

```
show vlan brief
```

**Expected output:**
```
VLAN Name                Status    Ports
---- ------------------- --------- --------------------------------
1    default             active    Fa0/3, Fa0/4, ... (unassigned ports)
10   Sales               active    Fa0/1
20   Engineering         active    Fa0/2
```

**Test connectivity:**
1. Ping PC0 (VLAN 10) → PC1 (VLAN 20): **Should FAIL** (different VLANs)
2. Ping PC0 (VLAN 10) → PC2 (VLAN 10): **Should FAIL** (trunk not yet configured)

### Exercise PT-4: Configure Trunking Between Switches

**On Switch1:**
```
configure terminal
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
 exit
```

**On Switch2:**
```
configure terminal
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 10,20
 exit
```

**Verify the trunk:**
```
show interfaces trunk
```

**Expected output:**
```
Port      Mode     Encapsulation  Status    Native vlan
Gig0/1    on       802.1q         trunking  1

Port      Vlans allowed on trunk
Gig0/1    10,20
```

### Exercise PT-5: Verify Cross-Switch VLANs

Now test connectivity:

1. **PC0 (VLAN 10, Switch1) → PC2 (VLAN 10, Switch2):** ✅ **Should WORK**
2. **PC1 (VLAN 20, Switch1) → PC3 (VLAN 20, Switch2):** ✅ **Should WORK**
3. **PC0 (VLAN 10) → PC1 (VLAN 20):** ❌ **Should FAIL** (different VLANs, no router)
4. **PC0 (VLAN 10) → PC3 (VLAN 20):** ❌ **Should FAIL**

**Use Simulation Mode** to watch the 802.1Q tag being added when the frame crosses the trunk link, and removed when it exits to the access port.

### Exercise PT-6: Change Native VLAN

**On both switches:**
```
configure terminal
interface GigabitEthernet0/1
 switchport trunk native vlan 99
 exit
```

**Verify:**
```
show interfaces trunk
```

The native VLAN should now show `99`.

**Test:** Intentionally set Switch1 native VLAN to 99 and Switch2 to 88. Observe the error message:
```
%CDP-4-NATIVE_VLAN_MISMATCH: Native VLAN mismatch discovered on GigabitEthernet0/1
```

Then fix both to match.

---

## Verification Checklist

- [ ] I can explain how a switch learns MAC addresses (source MAC → ingress port)
- [ ] I understand flood vs. forward behavior
- [ ] I can create VLANs and assign access ports (`vlan 10`, `switchport access vlan 10`)
- [ ] I can configure trunk links (`switchport mode trunk`, `switchport trunk allowed vlan`)
- [ ] I verified same-VLAN communication works across trunk links
- [ ] I verified different-VLAN communication fails without a router
- [ ] I can change the native VLAN and understand why it matters
- [ ] I can read `show vlan brief` and `show interfaces trunk` output

---

**Next:** [Challenges →](challenges.md)
