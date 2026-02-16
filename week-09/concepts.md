# Week 9 — Concepts: Wireless Networking (WLAN)

## Table of Contents
- [1. Wireless Standards (802.11)](#1-wireless-standards-80211)
- [2. Frequency Bands and Channels](#2-frequency-bands-and-channels)
- [3. RF Fundamentals](#3-rf-fundamentals)
- [4. Wireless Architecture](#4-wireless-architecture)
- [5. SSID, BSS, ESS](#5-ssid-bss-ess)
- [6. Wireless Security](#6-wireless-security)
- [7. WPA2-Personal vs. WPA2-Enterprise](#7-wpa2-personal-vs-wpa2-enterprise)
- [8. WPA3](#8-wpa3)
- [9. Wireless LAN Controller (WLC)](#9-wireless-lan-controller-wlc)
- [10. CAPWAP](#10-capwap)
- [11. AP Modes](#11-ap-modes)
- [12. Wireless Design Considerations](#12-wireless-design-considerations)
- [Quiz — 10 Questions](#quiz--10-questions)

---

## 1. Wireless Standards (802.11)

| Standard | Wi-Fi Name | Frequency | Max Speed | Channel Width |
|----------|-----------|-----------|-----------|---------------|
| 802.11b | — | 2.4 GHz | 11 Mbps | 22 MHz |
| 802.11a | — | 5 GHz | 54 Mbps | 20 MHz |
| 802.11g | — | 2.4 GHz | 54 Mbps | 20 MHz |
| 802.11n | Wi-Fi 4 | 2.4 / 5 GHz | 600 Mbps | 20/40 MHz |
| 802.11ac | Wi-Fi 5 | 5 GHz only | 6.9 Gbps | 20/40/80/160 MHz |
| **802.11ax** | **Wi-Fi 6/6E** | **2.4 / 5 / 6 GHz** | **9.6 Gbps** | **20/40/80/160 MHz** |

**Key points for CCNA:**
- 802.11n was the first to support **MIMO** (Multiple Input, Multiple Output) and both bands
- 802.11ac introduced **MU-MIMO** (Multi-User MIMO) — downlink only
- 802.11ax added **OFDMA** (Orthogonal Frequency Division Multiple Access) for efficient multi-user access, and full **MU-MIMO** (up and down)
- Wi-Fi 6E extends into the **6 GHz** band (more non-overlapping channels)

---

## 2. Frequency Bands and Channels

### 2.4 GHz Band
- 14 channels total (only 1-11 usable in USA)
- Each channel is ~22 MHz wide
- Only **3 non-overlapping channels: 1, 6, 11**
- More prone to interference (microwaves, Bluetooth, baby monitors)
- Better range (lower frequency penetrates walls better)

### 5 GHz Band
- Many more channels (over 20 non-overlapping)
- Less interference
- Shorter range (higher frequency)
- Higher throughput

### 6 GHz Band (Wi-Fi 6E)
- 59 additional channels (20 MHz each)
- Least interference (new spectrum, only Wi-Fi 6E devices)
- Shortest range

> **CCNA tip:** Remember that 2.4 GHz has only 3 non-overlapping channels (1, 6, 11). This is frequently tested.

---

## 3. RF Fundamentals

**Key RF concepts:**

| Term | Description |
|------|-------------|
| **RSSI** | Received Signal Strength Indicator — signal power (measured in dBm) |
| **SNR** | Signal-to-Noise Ratio — higher is better |
| **Interference** | Co-channel (same channel) or adjacent-channel (overlapping channels) |
| **Absorption** | Signal weakened by passing through materials |
| **Reflection** | Signal bounced off surfaces (metal, glass) |
| **CSMA/CA** | Carrier Sense Multiple Access / Collision Avoidance — wireless MAC method |

**CSMA/CA process:**
1. Listen for the medium to be clear
2. Wait a random backoff time
3. Send an RTS (Request to Send)
4. Receive CTS (Clear to Send) from the AP
5. Transmit the frame
6. Receive ACK from the AP

> Unlike Ethernet's CSMA/CD (Collision Detection), wireless uses **Collision Avoidance** because wireless devices can't detect collisions while transmitting (half-duplex).

---

## 4. Wireless Architecture

| Architecture | Description | Use Case |
|-------------|-------------|----------|
| **Autonomous AP** | Each AP is independently configured and managed | Very small deployments (1-3 APs) |
| **Controller-Based (WLC)** | Centralized WLC manages all lightweight APs | Enterprise (10+ APs) |
| **Cloud-Managed** | APs managed via cloud dashboard (e.g., Cisco Meraki) | Distributed sites, MSPs |

**Autonomous AP:**
- Full IOS on each AP
- Each AP configured individually (SSID, security, VLAN, channels)
- No centralized management → doesn't scale

**Controller-Based (CCNA focus):**
- **Lightweight APs (LAPs)** — minimal config, controlled by WLC
- WLC handles: SSID config, security policies, roaming, RF management, firmware
- LAPs communicate with WLC via **CAPWAP** tunnel
- Split-MAC architecture: management plane on WLC, data plane can be local or centralized

---

## 5. SSID, BSS, ESS

| Term | Definition |
|------|-----------|
| **SSID** | Service Set Identifier — the wireless network name |
| **BSSID** | Basic Service Set ID — the AP's radio MAC address |
| **BSS** | Basic Service Set — one AP + its clients |
| **ESS** | Extended Service Set — multiple APs with the same SSID |
| **IBSS** | Independent BSS — ad-hoc (peer-to-peer, no AP) |

**Roaming:** When a client moves from one AP to another within the same ESS, the WLC handles seamless handoff so the client keeps its IP and session.

---

## 6. Wireless Security

| Protocol | Encryption | Authentication | Status |
|----------|-----------|----------------|--------|
| WEP | RC4 (broken) | Shared key | **Deprecated — do not use** |
| WPA | TKIP | PSK or 802.1X | Legacy |
| **WPA2** | **AES-CCMP** | **PSK or 802.1X** | **Current standard** |
| **WPA3** | **AES-GCMP** | **SAE or 802.1X** | **Latest standard** |

**Key terms:**
- **PSK (Pre-Shared Key):** Everyone uses the same password (home/small office)
- **802.1X:** Each user authenticates individually via RADIUS server (enterprise)
- **TKIP:** Temporal Key Integrity Protocol (WPA1, legacy)
- **AES-CCMP:** Advanced Encryption Standard — Counter Mode with CBC-MAC Protocol
- **SAE:** Simultaneous Authentication of Equals (WPA3 replacement for PSK)

---

## 7. WPA2-Personal vs. WPA2-Enterprise

| Feature | WPA2-Personal | WPA2-Enterprise |
|---------|---------------|-----------------|
| Authentication | Pre-Shared Key (PSK) | 802.1X / RADIUS |
| Key management | Same key for everyone | Per-user/per-session keys |
| Scalability | Small environments | Large enterprises |
| User tracking | Not possible | Per-user logging/accounting |
| Security risk | Key shared = hard to revoke | Individual credentials |

**WPA2-Enterprise authentication flow:**
```
Wireless Client → AP → WLC → RADIUS Server
     (Supplicant)  (Authenticator)  (Auth Server)
```

1. Client associates with SSID
2. AP/WLC sends authentication request to RADIUS
3. RADIUS checks credentials (user/pass, certificate)
4. RADIUS responds: Accept or Reject
5. If accepted → unique encryption keys generated for that session

---

## 8. WPA3

Improvements over WPA2:
- **SAE (Simultaneous Authentication of Equals):** Replaces PSK. Resistant to offline dictionary attacks.
- **Forward Secrecy:** Even if the password is later compromised, previously captured traffic can't be decrypted.
- **Protected Management Frames (PMF):** Mandatory — prevents deauthentication attacks.
- **192-bit security suite:** For enterprise (WPA3-Enterprise).
- **Enhanced Open (OWE):** Encrypts open networks (coffee shops, airports) — each user gets unique encryption even without a password.

---

## 9. Wireless LAN Controller (WLC)

The WLC is the centralized brain of the wireless network.

**WLC functions:**
- AP management (firmware, config, monitoring)
- RF management (channel, power, load balancing)
- Security policy enforcement
- Client authentication and roaming
- Guest access management
- QoS (Quality of Service) for wireless

**WLC interfaces:**
| Interface | Purpose |
|-----------|---------|
| Management | WLC management access (SSH, HTTPS, GUI) |
| AP-Manager | CAPWAP tunnel termination (AP communication) |
| Virtual | Used for guest web authentication redirect |
| Dynamic | Maps to VLANs for client data traffic |

**Accessing WLC:**
- HTTPS to the management IP (web GUI)
- SSH to the management IP (CLI)
- Console port (initial setup)

---

## 10. CAPWAP

**Control And Provisioning of Wireless Access Points**

CAPWAP is the tunnel protocol between lightweight APs and the WLC.

| CAPWAP Channel | Purpose | UDP Port |
|----------------|---------|----------|
| **Control** | Management traffic (config, firmware, RF) | UDP 5246 |
| **Data** | Client data frames (optional — local switching avoids this) | UDP 5247 |

**Discovery process (how APs find the WLC):**
1. DHCP option 43 (WLC IP in DHCP response)
2. DNS resolution (`CISCO-CAPWAP-CONTROLLER.domain`)
3. Local broadcast
4. Previously known WLC IP (cached)

**Split-MAC architecture:**
- **AP handles:** Real-time functions (frame transmission, encryption/decryption, beacons, probe responses)
- **WLC handles:** Non-real-time functions (authentication, security policies, roaming decisions, RF management)

---

## 11. AP Modes

| Mode | Description |
|------|-------------|
| **Local** | Default. Serves clients AND scans channels periodically |
| **FlexConnect** | Serves clients locally even if WLC connection is lost |
| **Monitor** | Does NOT serve clients. Dedicated to scanning for rogues, interference |
| **Sniffer** | Captures wireless frames and sends to a packet analyzer |
| **Bridge** | Point-to-point or point-to-multipoint bridge between buildings |
| **SE-Connect** | Spectrum analysis for RF troubleshooting |

> CCNA focus: Know **Local** and **FlexConnect** modes.

**FlexConnect:** Used at remote branch offices. If the CAPWAP tunnel to WLC goes down, the AP continues serving clients by switching traffic locally.

---

## 12. Wireless Design Considerations

| Factor | Consideration |
|--------|--------------|
| **Coverage** | AP placement for signal coverage without dead zones |
| **Capacity** | Number of clients per AP (typically 25-50 recommended) |
| **Channel planning** | Non-overlapping channels to minimize co-channel interference |
| **Power levels** | Adjust to minimize overlap between APs |
| **Band steering** | Push capable clients to 5 GHz (less congested) |
| **VLAN mapping** | Different SSIDs → different VLANs (corporate, guest, IoT) |
| **Security** | WPA2/3-Enterprise for corporate; guest portal for visitors |

**Channel planning example (2.4 GHz floor plan):**
```
  [AP-1: Ch 1]    [AP-2: Ch 6]    [AP-3: Ch 11]
  
  [AP-4: Ch 6]    [AP-5: Ch 11]   [AP-6: Ch 1]
```
Use a honeycomb pattern to ensure no adjacent APs share the same channel.

---

## Quiz — 10 Questions

**1.** How many non-overlapping channels exist in the 2.4 GHz band?

<details><summary>Answer</summary>3 — channels 1, 6, and 11</details>

**2.** What Wi-Fi standard is known as Wi-Fi 6?

<details><summary>Answer</summary>802.11ax</details>

**3.** What tunnel protocol do lightweight APs use to communicate with a WLC?

<details><summary>Answer</summary>CAPWAP (Control And Provisioning of Wireless Access Points) — UDP ports 5246 (control) and 5247 (data)</details>

**4.** What is the difference between WPA2-Personal and WPA2-Enterprise?

<details><summary>Answer</summary>WPA2-Personal uses a Pre-Shared Key (same password for everyone). WPA2-Enterprise uses 802.1X/RADIUS for individual user authentication with per-user encryption keys.</details>

**5.** What does SAE stand for and what does it replace?

<details><summary>Answer</summary>Simultaneous Authentication of Equals. It replaces PSK in WPA3 and is resistant to offline dictionary attacks.</details>

**6.** What wireless access method replaces CSMA/CD in wired Ethernet?

<details><summary>Answer</summary>CSMA/CA (Carrier Sense Multiple Access / Collision Avoidance) — wireless can't detect collisions during transmission, so it avoids them instead.</details>

**7.** What AP mode allows a branch office AP to continue serving clients if the WLC connection fails?

<details><summary>Answer</summary>FlexConnect mode — the AP switches client traffic locally when the CAPWAP tunnel is down.</details>

**8.** What encryption does WPA2 use?

<details><summary>Answer</summary>AES-CCMP (Advanced Encryption Standard — Counter Mode with CBC-MAC Protocol)</details>

**9.** In the WPA2-Enterprise authentication flow, what role does the RADIUS server play?

<details><summary>Answer</summary>The RADIUS server is the Authentication Server. It verifies user credentials and sends Accept/Reject to the WLC (which acts as the Authenticator). The wireless client is the Supplicant.</details>

**10.** Why is the 5 GHz band generally preferred over 2.4 GHz in enterprise?

<details><summary>Answer</summary>5 GHz has many more non-overlapping channels, less interference, and higher throughput. 2.4 GHz only has 3 non-overlapping channels and is crowded with non-Wi-Fi devices.</details>

---

## Sources & Further Reading

- [IEEE 802.11 — Wireless LAN Standard](https://standards.ieee.org/ieee/802.11/7028/) — Official Wi-Fi specification
- [Wi-Fi Alliance](https://www.wi-fi.org/) — Wi-Fi 4/5/6/6E naming and certification
- [Cisco — Wireless LAN Controller Configuration Guide](https://www.cisco.com/c/en/us/td/docs/wireless/controller/9800/config-guide/b_wl_16_10_cg.html) — Cisco WLC setup
- [Cisco — Wireless LAN Design Guide](https://www.cisco.com/c/en/us/solutions/enterprise-networks/802-11ax-solution/nb-06-702cq-wireless-design-guide-cte-en.html) — WLAN design best practices
- [Cisco — Understanding WPA/WPA2/WPA3](https://www.cisco.com/c/en/us/support/docs/wireless-mobility/wlan-security/213232-wpa-wpa2-wpa3.html) — Wireless security standards
- [Jeremy's IT Lab — Wireless (YouTube)](https://www.youtube.com/watch?v=nMFhKRqJZjY&list=PLxbwE86jKRgMpuZuLBivzlM8s2Dk5lXBQ) — Video walkthrough

---

**Next → [Week 9 Exercises](exercises.md)**
