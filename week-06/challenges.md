# Week 6 — Challenges: Static & Dynamic Routing (OSPF)

## Table of Contents
- [Challenge 1: OSPF Equal-Cost Multi-Path](#challenge-1-ospf-equal-cost-multi-path)
- [Challenge 2: Passive Interface Best Practices](#challenge-2-passive-interface-best-practices)
- [Challenge 3: Link Failure Convergence](#challenge-3-link-failure-convergence)
- [Challenge 4: Floating Static Route with OSPF](#challenge-4-floating-static-route-with-ospf)
- [Challenge 5: Full Routing Design](#challenge-5-full-routing-design)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: OSPF Equal-Cost Multi-Path

**Task:** Build a 4-router topology where R1 has **two equal-cost OSPF paths** to reach R4's LAN.

```
R1 ──── R2 ──── R4
 \              /
  \──── R3 ───/
```

- R1↔R2, R2↔R4, R1↔R3, R3↔R4 all use /30 WAN links
- All link speeds are the same (so costs are equal)
- Configure OSPF area 0 on all routers
- R4 has a LAN: 192.168.4.0/24

**Verify:**
1. `show ip route 192.168.4.0` on R1 — do you see **two next-hops**?
2. Do a traceroute from R1 to R4's LAN — does traffic load-balance?
3. Shut down R1↔R2 link — does R1 automatically use the R1→R3→R4 path?

<details>
<summary><strong>Answer</strong></summary>

OSPF supports **ECMP (Equal-Cost Multi-Path)** by default. When two paths have the same total cost, both appear in the routing table:

```
O    192.168.4.0/24 [110/X] via 10.0.12.2, Serial0/0/0
                    [110/X] via 10.0.13.2, Serial0/0/1
```

Traffic is load-balanced across both paths (per-destination by default on Cisco).

When R1↔R2 goes down:
1. OSPF detects the neighbor is down (Dead timer expires at 40 seconds, or faster with BFD)
2. R1 removes the R2 path from the routing table
3. Only the R1→R3→R4 path remains
4. Convergence time ≈ 30-40 seconds (classic OSPF)

</details>

---

## Challenge 2: Passive Interface Best Practices

**Task:** Starting from the Lab PT-2 topology (3 routers with OSPF):

1. Configure `passive-interface default` on ALL routers
2. Selectively enable OSPF on only WAN-facing interfaces
3. Verify that:
   - LAN networks are still advertised in OSPF
   - Only WAN interfaces form OSPF neighbor adjacencies
   - PCs can still reach all LANs

**Questions to answer:**
- Why is passive-interface default considered best practice?
- What would happen if you forgot to `no passive-interface` on a WAN link?

<details>
<summary><strong>Answer</strong></summary>

**Configuration for R1:**
```
router ospf 1
 passive-interface default
 no passive-interface Serial0/0/0     ← toward R2
 no passive-interface Serial0/0/1     ← toward R3
```

**Why best practice:**
1. **Security:** Prevents rogue OSPF routers on LAN segments from forming adjacencies
2. **Efficiency:** Reduces unnecessary Hello packets on access segments (no routers to discover)
3. **Scalability:** As you add LAN interfaces, they're passive by default — no need to remember

**If you forget `no passive-interface` on a WAN link:**
- That WAN interface won't send Hellos
- No OSPF neighbor adjacency forms on that link
- Routes via that link disappear from the routing table
- Connectivity through that path is lost

</details>

---

## Challenge 3: Link Failure Convergence

**Task:** Using the 3-router triangle topology with OSPF:

1. From R1, start a continuous ping to R3's LAN: `ping 192.168.3.1 repeat 1000`
2. While ping is running, **shut down the direct R1↔R3 link**
3. Document:
   - How many pings are lost during convergence?
   - How long (in seconds) for traffic to re-route via R1→R2→R3?
   - What do `show ip ospf neighbor` and `show ip route` show during convergence?

4. Reduce the OSPF Hello/Dead timers on the direct link to 1/4 seconds:
   ```
   interface Serial0/0/1
    ip ospf hello-interval 1
    ip ospf dead-interval 4
   ```
5. Repeat the test — is convergence faster?

<details>
<summary><strong>Answer</strong></summary>

**Default timers:** Hello = 10 sec, Dead = 40 sec.
- After link goes down, the router may take up to **40 seconds** to declare neighbor dead (unless the interface goes down instantly, which triggers immediate reconvergence)
- If interface physically goes down → **immediate detection**, OSPF reconverges within a few seconds
- If interface stays up but neighbor stops responding → wait for Dead timer (40 seconds)

**With 1/4 timers:**
- Dead timer = 4 seconds → much faster detection
- Convergence improves dramatically but CPU overhead increases (Hello every 1 second)

**Typical ping loss:**
- Physical interface down: 1-3 pings lost (fast OSPF reconvergence)
- Neighbor timeout: 30-40+ pings lost (waiting for Dead timer)

**During convergence:**
```
show ip ospf neighbor      ← neighbor state goes from FULL to DOWN
show ip route              ← route to 192.168.3.0 temporarily disappears, then reappears via R2
```

</details>

---

## Challenge 4: Floating Static Route with OSPF

**Task:** Configure a backup path using a floating static route:

1. R1 learns 192.168.3.0/24 via OSPF (through R2 or R3)
2. Add a floating static route on R1 as backup:
   ```
   ip route 192.168.3.0 255.255.255.0 10.0.13.2 200
   ```
   (AD 200, higher than OSPF's 110)
3. Verify the static route does NOT appear in the routing table (OSPF route wins)
4. Shut down OSPF on R3 (`router ospf 1` → `shutdown`)
5. Verify the floating static route now appears in R1's routing table
6. Re-enable OSPF on R3 — verify the OSPF route takes over again

<details>
<summary><strong>Answer</strong></summary>

**Before shutdown:**
```
show ip route 192.168.3.0
O    192.168.3.0/24 [110/X] via ...    ← OSPF route (AD 110)
```
The floating static (AD 200) is in the config but NOT in the routing table.

**After R3 OSPF shutdown:**
```
show ip route 192.168.3.0
S    192.168.3.0/24 [200/0] via 10.0.13.2    ← Floating static activates
```

**After R3 OSPF re-enabled:**
OSPF re-establishes adjacency, route returns to OSPF, floating static is suppressed again.

This is commonly used for **WAN backup** — primary = MPLS/OSPF, backup = internet VPN (static).

</details>

---

## Challenge 5: Full Routing Design

**Task:** Design and implement from scratch:

**Scenario:** A company has 4 sites:
- **HQ:** 192.168.10.0/24 (200 hosts)
- **Branch A:** 192.168.20.0/24 (50 hosts)
- **Branch B:** 192.168.30.0/24 (30 hosts)
- **ISP connection** at HQ (203.0.113.0/30)

**Requirements:**
1. OSPF area 0 on all internal routers
2. HQ router connects to ISP with a static default route
3. Default route redistributed into OSPF
4. Passive interfaces on all LAN-facing interfaces
5. Custom Router IDs on all routers
6. Reference bandwidth set to 10000 on all routers
7. PCs in every site can reach every other site AND the internet (ISP)

**Time Target:** 30 minutes from scratch.

<details>
<summary><strong>Verification checklist</strong></summary>

- [ ] `show ip ospf neighbor` — all adjacencies are FULL
- [ ] `show ip route ospf` — all remote LANs visible on every router
- [ ] `show ip route` — default route (O*E2) on all non-HQ routers
- [ ] `show ip ospf interface` — LAN interfaces show passive
- [ ] `show ip ospf interface` — reference bandwidth shows 10000
- [ ] `ping` from Branch B PC to ISP (203.0.113.1) — should work
- [ ] `traceroute` from Branch A to Branch B — shows expected path

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. ECMP load balancing | ⭐⭐ Medium | 20 minutes |
| 2. Passive interfaces | ⭐⭐ Medium | 15 minutes |
| 3. Convergence testing | ⭐⭐ Medium | 20 minutes |
| 4. Floating static + OSPF | ⭐⭐ Medium | 15 minutes |
| 5. Full routing design | ⭐⭐⭐ Hard | 30 minutes |

---

**Week 6 complete! → [Start Week 7](../week-07/concepts.md)**
