# Week 6 — Exercises: Static & Dynamic Routing (OSPF)

## Table of Contents
- [Part A — Containerlab: Static Routes and OSPF with FRR](#part-a--containerlab-static-routes-and-ospf-with-frr)
  - [Lab CL-1: Static Route Configuration](#lab-cl-1-static-route-configuration)
  - [Lab CL-2: Single-Area OSPF](#lab-cl-2-single-area-ospf)
  - [Lab CL-3: OSPF Cost Manipulation](#lab-cl-3-ospf-cost-manipulation)
- [Part B — Packet Tracer: Full OSPF Configuration](#part-b--packet-tracer-full-ospf-configuration)
  - [Lab PT-1: Static Routes Between 3 Routers](#lab-pt-1-static-routes-between-3-routers)
  - [Lab PT-2: Convert to OSPF](#lab-pt-2-convert-to-ospf)
  - [Lab PT-3: Default Route Redistribution](#lab-pt-3-default-route-redistribution)
  - [Lab PT-4: DR/BDR Election](#lab-pt-4-drbdr-election)
  - [Lab PT-5: Passive Interfaces](#lab-pt-5-passive-interfaces)

---

## Part A — Containerlab: Static Routes and OSPF with FRR

### Lab CL-1: Static Route Configuration

**Deploy the topology:**
```bash
cd week-06/lab
sudo containerlab deploy -t topology.yml
```

**Topology:** R1 — R2 — R3 (linear chain), each with a LAN host.

```
PC1 ── R1 ─── R2 ─── R3 ── PC3
       │             │
   10.0.12.0/30  10.0.23.0/30
LAN:192.168.1.0 LAN:192.168.2.0 LAN:192.168.3.0
```

**Step 1: Verify connected routes on R1**
```bash
docker exec -it clab-week06-router1 vtysh
```
```
show ip route
```
You should see `C` (connected) routes for 192.168.1.0/24 and 10.0.12.0/30.

**Step 2: Configure static routes on R1**
```
configure terminal
ip route 192.168.2.0/24 10.0.12.2
ip route 192.168.3.0/24 10.0.12.2
end
show ip route static
```

**Step 3: Configure static routes on R2**
```
configure terminal
ip route 192.168.1.0/24 10.0.12.1
ip route 192.168.3.0/24 10.0.23.2
end
```

**Step 4: Configure static routes on R3**
```
configure terminal
ip route 192.168.1.0/24 10.0.23.1
ip route 192.168.2.0/24 10.0.23.1
end
```

**Step 5: Test end-to-end connectivity**
```bash
docker exec -it clab-week06-pc1 ping -c 3 192.168.3.10
docker exec -it clab-week06-pc3 ping -c 3 192.168.1.10
```

**Step 6: Trace the path**
```bash
docker exec -it clab-week06-pc1 traceroute 192.168.3.10
```

---

### Lab CL-2: Single-Area OSPF

**Step 1: Remove static routes from all routers**

On each router (R1, R2, R3):
```
configure terminal
no ip route 192.168.2.0/24 10.0.12.2
no ip route 192.168.3.0/24 10.0.12.2
! (remove all static routes added previously)
end
```

**Step 2: Configure OSPF on R1**
```
configure terminal
router ospf
 ospf router-id 1.1.1.1
 network 192.168.1.0/24 area 0
 network 10.0.12.0/30 area 0
end
```

**Step 3: Configure OSPF on R2**
```
configure terminal
router ospf
 ospf router-id 2.2.2.2
 network 192.168.2.0/24 area 0
 network 10.0.12.0/30 area 0
 network 10.0.23.0/30 area 0
end
```

**Step 4: Configure OSPF on R3**
```
configure terminal
router ospf
 ospf router-id 3.3.3.3
 network 192.168.3.0/24 area 0
 network 10.0.23.0/30 area 0
end
```

**Step 5: Verify OSPF neighbors**
```
show ip ospf neighbor
```
Expected: R1 sees R2 as Full, R2 sees R1 and R3, R3 sees R2.

**Step 6: Verify OSPF routes**
```
show ip route ospf
```
R1 should show O routes for 192.168.2.0/24 and 192.168.3.0/24.

**Step 7: Test connectivity (same as before)**
```bash
docker exec -it clab-week06-pc1 ping -c 3 192.168.3.10
```

---

### Lab CL-3: OSPF Cost Manipulation

**Step 1: Check current OSPF cost on R1**
```
show ip ospf interface
```
Note the cost for each interface.

**Step 2: Manually change cost on R2's link to R3**
```
configure terminal
interface eth2
 ip ospf cost 100
end
```

**Step 3: On R1, check how routing changed**
```
show ip route ospf
```
If there's an alternate path, the cost increase should route traffic differently. In our linear topology, the path is the same but the metric (cost) should increase.

**Step 4: Verify the metric change**
```
show ip route 192.168.3.0/24
```
The total cost should now be higher (original cost + 100 instead of original cost).

**Cleanup:**
```bash
sudo containerlab destroy -t topology.yml
```

---

## Part B — Packet Tracer: Full OSPF Configuration

### Lab PT-1: Static Routes Between 3 Routers

**Topology:** 3 routers (R1, R2, R3) connected in a triangle. Each has a LAN.

```
      R1
     /  \
   R2 ── R3
   |      |
  LAN2   LAN3
```

**IP Addressing:**

| Link | Network | R1 IP | R2 IP | R3 IP |
|------|---------|-------|-------|-------|
| R1↔R2 | 10.0.12.0/30 | .1 | .2 | — |
| R1↔R3 | 10.0.13.0/30 | .1 | — | .2 |
| R2↔R3 | 10.0.23.0/30 | — | .1 | .2 |
| R1 LAN | 192.168.1.0/24 | .1 (GW) | — | — |
| R2 LAN | 192.168.2.0/24 | — | .1 (GW) | — |
| R3 LAN | 192.168.3.0/24 | — | — | .1 (GW) |

**Configure on each router:**
```
! R1
interface GigabitEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
interface Serial0/0/0
 ip address 10.0.12.1 255.255.255.252
 no shutdown
interface Serial0/0/1
 ip address 10.0.13.1 255.255.255.252
 no shutdown

ip route 192.168.2.0 255.255.255.0 10.0.12.2
ip route 192.168.3.0 255.255.255.0 10.0.13.2
```

Repeat similarly for R2 and R3.

**Verify:** `show ip route`, `ping` all LANs from each router.

---

### Lab PT-2: Convert to OSPF

**Step 1: Remove all static routes**
```
no ip route 192.168.2.0 255.255.255.0 10.0.12.2
no ip route 192.168.3.0 255.255.255.0 10.0.13.2
```

**Step 2: Configure OSPF on R1**
```
router ospf 1
 router-id 1.1.1.1
 network 192.168.1.0 0.0.0.255 area 0
 network 10.0.12.0 0.0.0.3 area 0
 network 10.0.13.0 0.0.0.3 area 0
```

**Step 3: Configure OSPF on R2**
```
router ospf 1
 router-id 2.2.2.2
 network 192.168.2.0 0.0.0.255 area 0
 network 10.0.12.0 0.0.0.3 area 0
 network 10.0.23.0 0.0.0.3 area 0
```

**Step 4: Configure OSPF on R3**
```
router ospf 1
 router-id 3.3.3.3
 network 192.168.3.0 0.0.0.255 area 0
 network 10.0.13.0 0.0.0.3 area 0
 network 10.0.23.0 0.0.0.3 area 0
```

**Step 5: Verify**
```
show ip ospf neighbor
show ip route ospf
show ip ospf interface brief
```

**Step 6: Test PC-to-PC pings across all LANs.**

---

### Lab PT-3: Default Route Redistribution

**Step 1: Add an "ISP" router connected to R1**
- ISP Gig0/0: 203.0.113.1/30, R1 new interface: 203.0.113.2/30

**Step 2: On R1, configure a default route**
```
ip route 0.0.0.0 0.0.0.0 203.0.113.1
```

**Step 3: Redistribute into OSPF**
```
router ospf 1
 default-information originate
```

**Step 4: On R2 and R3, verify**
```
show ip route
```
Look for: `O*E2 0.0.0.0/0 [110/1] via ...`

**Step 5: From R3, ping the ISP router**
```
ping 203.0.113.1
```
Should succeed — R3 follows the default route through OSPF to R1 to ISP.

---

### Lab PT-4: DR/BDR Election

**Step 1: Add a shared Ethernet segment**
Connect R1, R2, and R3's GigabitEthernet interfaces to the same switch (simulating a broadcast multi-access network).

Use subnet 10.0.123.0/24:
- R1: 10.0.123.1, R2: 10.0.123.2, R3: 10.0.123.3
- Add this network to OSPF: `network 10.0.123.0 0.0.0.255 area 0`

**Step 2: Check DR/BDR**
```
show ip ospf interface GigabitEthernet0/1
```
Look for: `DR`, `BDR`, or `DROTHER` state. Note which router won based on Router ID.

**Step 3: Change OSPF priority**
```
! On R2 — force it to be DR
interface GigabitEthernet0/1
 ip ospf priority 255
```

**Step 4: Clear OSPF to trigger re-election**
```
clear ip ospf process
```

**Step 5: Verify R2 is now DR**
```
show ip ospf neighbor
show ip ospf interface GigabitEthernet0/1
```

**Step 6: Observe non-preemptive behavior**
- Set R3 priority to 255 (higher than R2? same — use Router ID tiebreaker)
- Without clearing processes, does the DR change? **No — not preemptive.**

---

### Lab PT-5: Passive Interfaces

**Step 1: On all routers, make LAN interfaces passive**
```
router ospf 1
 passive-interface GigabitEthernet0/0
```

**Step 2: Verify no OSPF Hellos on LAN**
Use Simulation Mode → filter for OSPF → observe that Gig0/0 does NOT send Hellos.

**Step 3: Verify the LAN network is still advertised**
```
show ip route ospf     ← on a neighboring router
```
The 192.168.x.0/24 network should still appear as an OSPF route.

**Step 4: Try passive-interface default approach**
```
router ospf 1
 passive-interface default
 no passive-interface Serial0/0/0
 no passive-interface Serial0/0/1
```

Verify: Only serial interfaces form neighbors. LANs are advertised but passive.

---

**Next → [Week 6 Challenges](challenges.md)**
