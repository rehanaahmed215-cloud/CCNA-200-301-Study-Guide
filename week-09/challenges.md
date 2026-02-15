# Week 9 — Challenges: Wireless Networking (WLAN)

## Table of Contents
- [Challenge 1: Wireless Design for a 2-Floor Office](#challenge-1-wireless-design-for-a-2-floor-office)
- [Challenge 2: WPA2-Enterprise Authentication Flow](#challenge-2-wpa2-enterprise-authentication-flow)
- [Challenge 3: Autonomous vs. Controller — Decision Matrix](#challenge-3-autonomous-vs-controller--decision-matrix)
- [Challenge 4: Wireless Troubleshooting Scenarios](#challenge-4-wireless-troubleshooting-scenarios)
- [Challenge 5: Complete Wireless Network Build](#challenge-5-complete-wireless-network-build)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Wireless Design for a 2-Floor Office

**Task:** Design a wireless plan for:
- **2 floors**, 8 rooms per floor (4×2 grid)
- Each room ~600 sq ft
- Expected: 15 users per room
- Requirements: corporate SSID + guest SSID
- Budget: Cisco Catalyst 9100 APs + 9800 WLC

**Deliverables:**
1. How many APs total? Justify the number
2. Channel plan for all APs (2.4 GHz and 5 GHz)
3. Which channels for 2.4 GHz? Which for 5 GHz?
4. AP placement map (draw on paper or describe)
5. SSID/VLAN design
6. Security recommendations

<details>
<summary><strong>Sample design</strong></summary>

**1. AP Count:** 16 APs (1 per room). With 15 users per room, 1 AP per room is sufficient (APs can handle 25-50 clients). For high-density rooms, consider 2 APs.

**2. Channel Plan (2.4 GHz) — per floor:**
```
Floor 1:                    Floor 2:
┌──┬──┬──┬──┐             ┌──┬──┬──┬──┐
│ 1│ 6│11│ 1│             │ 6│ 1│ 6│11│
├──┼──┼──┼──┤             ├──┼──┼──┼──┤
│ 6│11│ 1│ 6│             │11│ 6│11│ 1│
└──┴──┴──┴──┘             └──┴──┴──┴──┘
```

**3. 5 GHz channels:** 36, 40, 44, 48, 52, 56, 60, 64, 149, 153, 157, 161, 165 — enough for all 16 APs without reuse.

**4. AP Placement:** Center of each room, ceiling-mounted for best coverage.

**5. SSID/VLAN Design:**
- SSID: `Corporate` → VLAN 10 (192.168.10.0/24) → WPA2-Enterprise
- SSID: `Guest-WiFi` → VLAN 20 (192.168.20.0/24) → WPA2-PSK with captive portal
- Management: VLAN 99

**6. Security:**
- Corporate: WPA2-Enterprise with RADIUS + Active Directory
- Guest: Captive portal with terms acceptance, bandwidth throttled
- Enable band steering (push 5 GHz-capable devices to 5 GHz)
- Enable 802.11w (Protected Management Frames)

</details>

---

## Challenge 2: WPA2-Enterprise Authentication Flow

**Task:** Draw a detailed diagram showing the WPA2-Enterprise (802.1X) authentication flow between:
- Wireless client (Supplicant)
- Access Point
- WLC (Authenticator)
- RADIUS Server (Authentication Server)

Include:
1. All message exchanges (EAP)
2. What happens on success
3. What happens on failure
4. Where encryption keys are generated

<details>
<summary><strong>Authentication flow</strong></summary>

```
[Client]           [AP]           [WLC]          [RADIUS]
    |                |               |                |
    |--- Associate →  |               |                |
    |                |--- CAPWAP →    |                |
    |                |               |                |
    |←── EAP Request/Identity ──────|                |
    |                |               |                |
    |── EAP Response/Identity ──────→|                |
    |                |               |── RADIUS Access-Request →|
    |                |               |                |
    |                |               |←─ RADIUS Access-Challenge|
    |←── EAP Challenge ─────────────|                |
    |                |               |                |
    |── EAP Response ───────────────→|                |
    |                |               |── RADIUS Access-Request →|
    |                |               |                |
    |                |               |←─ RADIUS Access-Accept ──|
    |                |               |    (with session key)     |
    |←── EAP Success ───────────────|                |
    |                |               |                |
    |── 4-Way Handshake ────────────→|                |
    |  (derives per-session keys)    |                |
    |                |               |                |
    |←── Encrypted data traffic ────→|                |
```

**On success:** RADIUS sends Access-Accept with a master session key. The 4-way handshake derives per-session encryption keys. Client connects.

**On failure:** RADIUS sends Access-Reject. WLC sends EAP-Failure to client. Client is denied association.

**Key generation:** Each successful authentication creates unique per-user, per-session keys — so even users on the same SSID can't decrypt each other's traffic.

</details>

---

## Challenge 3: Autonomous vs. Controller — Decision Matrix

**Task:** Create a decision matrix comparing these architectures for 5 scenarios:

| Scenario | Autonomous | Controller (WLC) | Cloud (Meraki) |
|----------|-----------|-------------------|-----------------|
| Home office (2 APs) | | | |
| Branch office (10 APs, no local IT) | | | |
| Corporate HQ (100 APs, IT team) | | | |
| Outdoor event (temporary, 20 APs) | | | |
| University campus (500 APs) | | | |

For each, rate: **Best** / **Acceptable** / **Poor** and explain why.

<details>
<summary><strong>Completed matrix</strong></summary>

| Scenario | Autonomous | Controller (WLC) | Cloud (Meraki) |
|----------|-----------|-------------------|-----------------|
| Home office (2 APs) | **Best** — simple, no WLC needed | Poor — overkill cost | Acceptable — works but subscription cost |
| Branch (10 APs, no IT) | Poor — hard to manage remotely | Acceptable — needs WLC somewhere | **Best** — cloud dashboard, no on-site IT |
| Corporate HQ (100 APs) | Poor — unmanageable at scale | **Best** — centralized control, RF mgmt | Acceptable — but ongoing subscription |
| Outdoor event (temp) | Poor — need quick deploy | **Best** — fast SSID/policy push | Acceptable — needs internet |
| University (500 APs) | Poor — impossible to manage | **Best** — HA WLC, full features | Acceptable — cost at scale |

**Key insight:** Autonomous scales poorly beyond ~5 APs. WLC is the enterprise standard. Cloud is excellent for distributed sites with no local IT.

</details>

---

## Challenge 4: Wireless Troubleshooting Scenarios

**Task:** For each scenario, identify the likely cause and solution:

**Scenario A:** Users near the AP (10 feet) get excellent speed. Users 80 feet away get very slow speeds and frequent disconnects.
- Environment: open office, 2.4 GHz only, walls between sections

**Scenario B:** All users connect but intermittently lose connection for 2-3 seconds every few minutes.
- Environment: 3 APs all on channel 1

**Scenario C:** Users can connect to the SSID but cannot get an IP address.
- Environment: WLC-based, DHCP server on a different VLAN

**Scenario D:** 5 GHz clients work perfectly, but 2.4 GHz clients experience extreme slowness.
- Environment: office above a large kitchen/cafeteria

<details>
<summary><strong>Answers</strong></summary>

**A: Coverage gap / insufficient AP density**
- 80 feet with walls is near the edge of 2.4 GHz range
- **Solution:** Add more APs to cover the distant area, or increase AP power (though this can cause asymmetric connectivity — the AP hears the client but the client's reply is too weak)

**B: Co-channel interference**
- All 3 APs on channel 1 means every transmission from one AP is heard by others → constant collisions
- **Solution:** Use channels 1, 6, 11 (non-overlapping). Enable auto-channel assignment on the WLC.

**C: DHCP issue — likely missing VLAN trunk or ip helper-address**
- Client associates but DHCP Discover can't reach the server
- **Solution:** Verify trunk between switch and WLC carries the client VLAN. Verify `ip helper-address` on the router/SVI for the client VLAN pointing to the DHCP server.

**D: 2.4 GHz interference from kitchen equipment**
- Microwaves operate at 2.4 GHz and create massive interference
- **Solution:** Use 5 GHz for that area (band steering), or move 2.4 GHz APs away from the kitchen. Consider Wi-Fi 6E (6 GHz) for interference-free operation.

</details>

---

## Challenge 5: Complete Wireless Network Build

**Task:** In Packet Tracer, build a complete wireless network:

**Components:**
- 1 WLC
- 2 Lightweight APs
- 1 L3 Switch (core)
- 1 Router (gateway/DHCP)
- 3 wireless laptops
- 1 wired server

**Requirements:**
- SSID 1: `Corporate` → VLAN 10 → WPA2-PSK
- SSID 2: `Guest` → VLAN 20 → WPA2-PSK (different key)  
- Both VLANs get DHCP
- Guest VLAN can reach the internet but NOT the corporate VLAN (use ACL)
- Corporate can reach both the server and internet

**Time target:** 45 minutes.

<details>
<summary><strong>Verification checklist</strong></summary>

- [ ] Both SSIDs visible on wireless laptops
- [ ] Corporate laptop gets 192.168.10.x IP
- [ ] Guest laptop gets 192.168.20.x IP
- [ ] Corporate laptop can ping server (wired)
- [ ] Guest laptop CANNOT ping server
- [ ] Both laptops can reach the internet (simulated ISP)
- [ ] WLC shows both APs registered
- [ ] `show ip dhcp binding` shows leases from both VLANs

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. Wireless office design | ⭐⭐⭐ Hard | 30 minutes |
| 2. 802.1X authentication flow | ⭐⭐ Medium | 20 minutes |
| 3. Architecture decision matrix | ⭐⭐ Medium | 15 minutes |
| 4. Troubleshooting scenarios | ⭐⭐ Medium | 15 minutes |
| 5. Complete wireless build | ⭐⭐⭐ Hard | 45 minutes |

---

**Week 9 complete! → [Start Week 10](../week-10/concepts.md)**
