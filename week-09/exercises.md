# Week 9 — Exercises: Wireless Networking (WLAN)

## Table of Contents
- [Part A — Conceptual Exercises (No Lab Required)](#part-a--conceptual-exercises-no-lab-required)
  - [Exercise 1: Wireless Standards Comparison](#exercise-1-wireless-standards-comparison)
  - [Exercise 2: Channel Planning Drawing](#exercise-2-channel-planning-drawing)
  - [Exercise 3: Security Protocol Analysis](#exercise-3-security-protocol-analysis)
- [Part B — Packet Tracer: WLC and Wireless Labs](#part-b--packet-tracer-wlc-and-wireless-labs)
  - [Lab PT-1: Basic Wireless Setup with WLC](#lab-pt-1-basic-wireless-setup-with-wlc)
  - [Lab PT-2: Guest WLAN on Separate VLAN](#lab-pt-2-guest-wlan-on-separate-vlan)
  - [Lab PT-3: Wireless Client Connectivity](#lab-pt-3-wireless-client-connectivity)
  - [Lab PT-4: WPA2 Security Configuration](#lab-pt-4-wpa2-security-configuration)

---

> **Note:** Wireless labs are primarily done in Packet Tracer since Containerlab cannot simulate wireless. The conceptual exercises reinforce theory without a simulator.

---

## Part A — Conceptual Exercises (No Lab Required)

### Exercise 1: Wireless Standards Comparison

Fill in this table from memory, then check your answers against the concepts.md:

| Standard | Wi-Fi Name | Frequency | Max Speed | Key Feature |
|----------|-----------|-----------|-----------|-------------|
| 802.11b | | | | |
| 802.11a | | | | |
| 802.11g | | | | |
| 802.11n | | | | |
| 802.11ac | | | | |
| 802.11ax | | | | |

<details>
<summary><strong>Check your answers</strong></summary>

| Standard | Wi-Fi Name | Frequency | Max Speed | Key Feature |
|----------|-----------|-----------|-----------|-------------|
| 802.11b | — | 2.4 GHz | 11 Mbps | First popular standard |
| 802.11a | — | 5 GHz | 54 Mbps | 5 GHz, less interference |
| 802.11g | — | 2.4 GHz | 54 Mbps | Backwards compatible with b |
| 802.11n | Wi-Fi 4 | 2.4/5 GHz | 600 Mbps | MIMO, dual-band |
| 802.11ac | Wi-Fi 5 | 5 GHz | 6.9 Gbps | MU-MIMO (downlink), wider channels |
| 802.11ax | Wi-Fi 6 | 2.4/5/6 GHz | 9.6 Gbps | OFDMA, MU-MIMO (up+down) |

</details>

---

### Exercise 2: Channel Planning Drawing

**Task:** Draw a channel plan for a 2-floor office:
- Floor 1: 4 rooms in a 2×2 grid
- Floor 2: 4 rooms in a 2×2 grid
- Each room gets one 2.4 GHz AP

**Rules:**
- Only use channels 1, 6, and 11
- No two adjacent APs (horizontal, vertical, or same spot between floors) should share a channel

Draw your plan on paper, then check:

<details>
<summary><strong>Sample plan</strong></summary>

```
Floor 1:              Floor 2:
┌─────┬─────┐        ┌─────┬─────┐
│ Ch1 │ Ch6 │        │ Ch6 │ Ch1 │
├─────┼─────┤        ├─────┼─────┤
│Ch11 │ Ch1 │        │ Ch1 │Ch11 │
└─────┴─────┘        └─────┴─────┘
```

- No horizontal neighbors share a channel ✓
- No vertical neighbors share a channel ✓
- Same position across floors don't share a channel ✓

</details>

---

### Exercise 3: Security Protocol Analysis

**Task:** A company asks you to recommend wireless security. For each scenario, choose the appropriate protocol and explain why:

1. **Home office, 2 users, no IT staff**
2. **Corporate HQ, 500 employees, has Active Directory and RADIUS**
3. **Coffee shop offering free Wi-Fi**
4. **Hospital with IoT medical devices (legacy 802.11n)**

<details>
<summary><strong>Recommendations</strong></summary>

1. **Home office:** WPA3-Personal (SAE). If devices don't support WPA3, WPA2-Personal (PSK) with a strong passphrase. Simple to manage, no server needed.

2. **Corporate HQ:** WPA2-Enterprise or WPA3-Enterprise with 802.1X/RADIUS. Per-user authentication, logging, credential revocation when employees leave. Integrates with Active Directory.

3. **Coffee shop:** WPA3 Enhanced Open (OWE) if possible — encrypts traffic even without a password. If not, open network with a captive portal. Never WEP or no encryption.

4. **Hospital IoT:** WPA2-Personal on a dedicated SSID/VLAN isolated from the corporate network. Legacy 802.11n devices may not support WPA3. Segment IoT traffic with ACLs.

</details>

---

## Part B — Packet Tracer: WLC and Wireless Labs

### Lab PT-1: Basic Wireless Setup with WLC

**Topology:**
```
[Switch] ── trunk ── [WLC] 
   │
   ├── [Lightweight AP]
   │
   └── [DHCP Server / Router]
```

**Step 1: Place devices**
- 1 × 3560 Switch (or 2960)
- 1 × WLC (Wireless LAN Controller — search "WLC" in Packet Tracer)
- 1 × Lightweight AP (search "AP" → choose a lightweight model)
- 1 × Router (for DHCP and gateway)

**Step 2: Connect WLC to switch (trunk)**
```
! On the switch:
interface GigabitEthernet0/1
 switchport mode trunk
 switchport trunk allowed vlan 1,10,20
```

**Step 3: Configure the WLC via browser**
- Assign management IP to WLC (e.g., 192.168.1.2/24)
- Open a PC browser → navigate to `https://192.168.1.2`
- Log in to the WLC web interface

**Step 4: Create a WLAN**
- WLC GUI → WLANs → Create New
- SSID: `Corporate`
- Security: WPA2-PSK
- Passphrase: `Cisco12345`
- Interface: management (or a dynamic interface mapped to VLAN 10)

**Step 5: AP discovery**
The lightweight AP should automatically discover the WLC via CAPWAP. Check the AP list in WLC GUI → Wireless → Access Points.

**Step 6: Test**
- Place a wireless laptop near the AP
- Connect to SSID "Corporate" with the PSK
- Verify IP assignment and connectivity

---

### Lab PT-2: Guest WLAN on Separate VLAN

**Step 1: Create VLAN 20 for guests on the switch**
```
vlan 20
 name Guest
```

**Step 2: On the WLC, create a dynamic interface**
- Controller → Interfaces → New
- Name: `guest-vlan`
- VLAN ID: 20
- IP: 192.168.20.2/24, Gateway: 192.168.20.1

**Step 3: Configure DHCP for VLAN 20**
On the router:
```
ip dhcp pool GUEST
 network 192.168.20.0 255.255.255.0
 default-router 192.168.20.1
 dns-server 8.8.8.8
```

**Step 4: Create a Guest WLAN on the WLC**
- WLC GUI → WLANs → Create New
- SSID: `Guest-WiFi`
- Security: WPA2-PSK (or open with web auth)
- Interface: `guest-vlan` (VLAN 20)

**Step 5: Test**
- Connect a wireless device to "Guest-WiFi"
- Verify it gets a 192.168.20.x address
- Verify it CANNOT reach the corporate VLAN (192.168.10.0/24) — use ACLs if needed

---

### Lab PT-3: Wireless Client Connectivity

**Step 1: Place 3 wireless laptops at varying distances from the AP**

**Step 2: Connect each to the Corporate SSID**

**Step 3: Check signal strength**
On each laptop: Desktop → PC Wireless → Link Information
- Note the signal strength and link speed for each

**Step 4: Move a laptop out of range → observe disconnection**

**Step 5: Add a second AP (same SSID "Corporate")**
- The ESS now covers a larger area
- Move a laptop between the two APs → roaming should be seamless

---

### Lab PT-4: WPA2 Security Configuration

**Step 1: Configure WPA2-PSK on WLAN**
- WLC → WLANs → Edit "Corporate"
- Security tab → Layer 2 → WPA2 Policy
- Auth Key Management: PSK
- PSK Format: ASCII
- Passphrase: `CorpSecure2024!`

**Step 2: Test with correct passphrase**
Connect a laptop → enter `CorpSecure2024!` → should connect.

**Step 3: Test with wrong passphrase**
On a different laptop → enter wrong password → should fail.

**Step 4: Switch to WPA2-Enterprise (if RADIUS available)**
- Security tab → Auth Key Management: 802.1X
- Add RADIUS server: IP, shared secret, port 1812
- Test with username/password

---

**Next → [Week 9 Challenges](challenges.md)**
