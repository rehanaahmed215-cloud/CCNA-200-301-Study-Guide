# Week 2 — Challenges: IPv4 Addressing & Subnetting

Complete these challenges without looking at your notes.

---

## Challenge 1: VLSM Design

**Scenario:** Your company has been assigned `10.0.0.0/8`. Design a VLSM addressing scheme for:

| Location | Required Hosts |
|----------|---------------|
| HQ | 500 |
| Branch A | 120 |
| Branch B | 60 |
| WAN Link 1 (HQ ↔ Branch A) | 2 |
| WAN Link 2 (HQ ↔ Branch B) | 2 |

**Deliverables:**
1. For each subnet: network address, mask (CIDR and dotted decimal), usable range, broadcast
2. Confirm no subnets overlap
3. Calculate total addresses used vs. wasted

<details>
<summary><strong>Check your answer</strong></summary>

**Sort largest first:** HQ(500), BrA(120), BrB(60), WAN1(2), WAN2(2)

| Subnet | Hosts Needed | Mask | Network | Usable Range | Broadcast |
|--------|-------------|------|---------|-------------|-----------|
| HQ | 500 | /23 (255.255.254.0) | 10.0.0.0/23 | 10.0.0.1 – 10.0.1.254 | 10.0.1.255 |
| Branch A | 120 | /25 (255.255.255.128) | 10.0.2.0/25 | 10.0.2.1 – 10.0.2.126 | 10.0.2.127 |
| Branch B | 60 | /26 (255.255.255.192) | 10.0.2.128/26 | 10.0.2.129 – 10.0.2.190 | 10.0.2.191 |
| WAN 1 | 2 | /30 (255.255.255.252) | 10.0.2.192/30 | 10.0.2.193 – 10.0.2.194 | 10.0.2.195 |
| WAN 2 | 2 | /30 (255.255.255.252) | 10.0.2.196/30 | 10.0.2.197 – 10.0.2.198 | 10.0.2.199 |

**Overlap check:** Each subnet starts after the previous one's broadcast address. ✓
**Waste calculation:** 510 + 126 + 62 + 2 + 2 = 702 usable addresses allocated, 500+120+60+2+2 = 684 needed → 18 addresses wasted (excellent efficiency!)

</details>

---

## Challenge 2: Speed Subnetting Drill (20 Problems)

Set a timer. **Goal: Complete all 20 in under 10 minutes.**

For each, find: **Network address, broadcast address, usable hosts.**

| # | IP/Mask |
|---|---------|
| 1 | 10.1.1.100/24 |
| 2 | 192.168.5.200/28 |
| 3 | 172.16.30.45/22 |
| 4 | 10.10.10.10/30 |
| 5 | 192.168.1.1/25 |
| 6 | 172.20.100.200/27 |
| 7 | 10.0.50.130/21 |
| 8 | 192.168.200.99/26 |
| 9 | 172.16.0.1/12 |
| 10 | 10.255.255.254/8 |
| 11 | 192.168.10.33/28 |
| 12 | 172.16.55.100/23 |
| 13 | 10.1.1.1/29 |
| 14 | 192.168.100.100/25 |
| 15 | 172.16.10.200/20 |
| 16 | 10.0.0.1/16 |
| 17 | 192.168.50.50/27 |
| 18 | 172.16.128.1/17 |
| 19 | 10.10.100.100/19 |
| 20 | 192.168.1.130/26 |

<details>
<summary><strong>Check your answers</strong></summary>

| # | Network Address | Broadcast | Usable Hosts |
|---|----------------|-----------|-------------|
| 1 | 10.1.1.0/24 | 10.1.1.255 | 254 |
| 2 | 192.168.5.192/28 | 192.168.5.207 | 14 |
| 3 | 172.16.28.0/22 | 172.16.31.255 | 1022 |
| 4 | 10.10.10.8/30 | 10.10.10.11 | 2 |
| 5 | 192.168.1.0/25 | 192.168.1.127 | 126 |
| 6 | 172.20.100.192/27 | 172.20.100.223 | 30 |
| 7 | 10.0.48.0/21 | 10.0.55.255 | 2046 |
| 8 | 192.168.200.64/26 | 192.168.200.127 | 62 |
| 9 | 172.16.0.0/12 | 172.31.255.255 | 1,048,574 |
| 10 | 10.0.0.0/8 | 10.255.255.255 | 16,777,214 |
| 11 | 192.168.10.32/28 | 192.168.10.47 | 14 |
| 12 | 172.16.54.0/23 | 172.16.55.255 | 510 |
| 13 | 10.1.1.0/29 | 10.1.1.7 | 6 |
| 14 | 192.168.100.0/25 | 192.168.100.127 | 126 |
| 15 | 172.16.0.0/20 | 172.16.15.255 | 4094 |
| 16 | 10.0.0.0/16 | 10.0.255.255 | 65,534 |
| 17 | 192.168.50.32/27 | 192.168.50.63 | 30 |
| 18 | 172.16.128.0/17 | 172.16.255.255 | 32,766 |
| 19 | 10.10.96.0/19 | 10.10.127.255 | 8190 |
| 20 | 192.168.1.128/26 | 192.168.1.191 | 62 |

**Scoring:** 20/20 correct at <10 min = Exam ready. 15-19 = Keep practicing. <15 = Review the magic number method.

</details>

---

## Challenge 3: Explain Subnet Differences

**Task:** Write a clear explanation (as if teaching someone) of why `192.168.1.128/25` and `192.168.1.0/25` are different subnets.

Include:
- The binary representation of each network address
- Which host bits belong to each
- Why a host in one subnet cannot directly reach a host in the other without a router

<details>
<summary><strong>Check your answer</strong></summary>

**192.168.1.0/25:**
- Binary: `11000000.10101000.00000001.0 0000000`
- The `/25` means the first 25 bits are the network portion
- The last 7 bits are host bits → range: .0 to .127
- Network: 192.168.1.0, Broadcast: 192.168.1.127

**192.168.1.128/25:**
- Binary: `11000000.10101000.00000001.1 0000000`
- Same /25 mask, but the 25th bit is `1` instead of `0`
- Host range: .128 to .255
- Network: 192.168.1.128, Broadcast: 192.168.1.255

**Why they're different subnets:**
The 25th bit differentiates them. In 192.168.1.0/25, the 25th bit is 0. In 192.168.1.128/25, it's 1. Since this bit is part of the *network* portion (within the /25 mask), these are two separate networks.

**Why a router is needed:**
When a host (e.g., 192.168.1.10/25) wants to send to 192.168.1.200/25, it performs an AND operation:
- My network: 192.168.1.10 AND 255.255.255.128 = **192.168.1.0**
- Destination: 192.168.1.200 AND 255.255.255.128 = **192.168.1.128**
- 192.168.1.0 ≠ 192.168.1.128 → **different network** → send to default gateway (router)

</details>

---

## Challenge 4: Network Troubleshooting Scenario

**Scenario:** A user reports they can't reach the server at `192.168.10.100`. Here's the host's configuration:

```
IP Address:    192.168.10.50
Subnet Mask:   255.255.255.192
Default Gateway: 192.168.10.1
```

The server's configuration:
```
IP Address:    192.168.10.100
Subnet Mask:   255.255.255.192
Default Gateway: 192.168.10.65
```

**Tasks:**
1. What subnet is the host in?
2. What subnet is the server in?
3. Are they in the same subnet?
4. What's the problem, and how would you fix it?

<details>
<summary><strong>Check your answer</strong></summary>

**1. Host subnet:** /26, magic number = 64. 50 falls in 0–63 → **192.168.10.0/26**
**2. Server subnet:** /26, magic number = 64. 100 falls in 64–127 → **192.168.10.64/26**
**3. No** — they are in different subnets.
**4. The problem:** They're in different subnets but may be on the same physical network. The host sends traffic to its gateway (192.168.10.1), which is correct. The server's gateway is 192.168.10.65, also correct.

This should actually **work** if routing is properly configured between the two subnets. If it's NOT working, check:
- Is the router between them configured with both subnet interfaces?
- Is the router's interface in the .0/26 subnet actually 192.168.10.1?
- Is the router's interface in the .64/26 subnet actually 192.168.10.65?
- Are both router interfaces up? (`show ip interface brief`)
- Is IP routing enabled on the router?

If the intention was for them to be on the **same subnet**, change the server's IP to something in the .0/26 range (e.g., 192.168.10.40) and its gateway to 192.168.10.1.

</details>

---

## Challenge 5: Build the VLSM Network in ContainerLab

**Task:** Using the VLSM design from Challenge 1, build and configure the full topology:

1. Create a Containerlab topology with:
   - 3 FRR routers (HQ, BranchA, BranchB)
   - 3 hosts (one per site)
   - WAN links between HQ↔BranchA and HQ↔BranchB
2. Assign all IP addresses from your VLSM scheme
3. Configure static routes so all hosts can reach each other
4. Verify with ping and traceroute from every host to every other host

**Bonus:** After it works, deliberately misconfigure one static route (wrong next-hop). Use `traceroute` to identify where packets are being dropped, then fix it.

<details>
<summary><strong>Hint: Topology structure</strong></summary>

```yaml
name: week02-vlsm
topology:
  nodes:
    hq-router:
      kind: linux
      image: frrouting/frr:latest
    brancha-router:
      kind: linux
      image: frrouting/frr:latest
    branchb-router:
      kind: linux
      image: frrouting/frr:latest
    hq-host:
      kind: linux
      image: wbitt/network-multitool:latest
    brancha-host:
      kind: linux
      image: wbitt/network-multitool:latest
    branchb-host:
      kind: linux
      image: wbitt/network-multitool:latest
  links:
    # HQ LAN
    - endpoints: ["hq-router:eth1", "hq-host:eth1"]
    # Branch A LAN
    - endpoints: ["brancha-router:eth1", "brancha-host:eth1"]
    # Branch B LAN
    - endpoints: ["branchb-router:eth1", "branchb-host:eth1"]
    # WAN: HQ <-> Branch A
    - endpoints: ["hq-router:eth2", "brancha-router:eth2"]
    # WAN: HQ <-> Branch B
    - endpoints: ["hq-router:eth3", "branchb-router:eth2"]
```

Then use `docker exec` to configure IPs and routes on each device.

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. VLSM design | ⭐⭐ Medium | 15 minutes |
| 2. Speed drill | ⭐⭐ Medium | 10 minutes |
| 3. Subnet explanation | ⭐ Easy | 10 minutes |
| 4. Troubleshooting | ⭐⭐ Medium | 10 minutes |
| 5. Build VLSM lab | ⭐⭐⭐ Hard | 45 minutes |

**Target:** Challenges 1-4 in under 45 minutes. Challenge 5 is a stretch goal.

---

**Week 2 complete! → [Start Week 3](../week-03/concepts.md)**
