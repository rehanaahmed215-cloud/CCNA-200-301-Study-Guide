# Week 10 — Challenges: Network Automation & Programmability

## Table of Contents
- [Challenge 1: Parse a Routing Table from JSON](#challenge-1-parse-a-routing-table-from-json)
- [Challenge 2: Ping Sweep Script](#challenge-2-ping-sweep-script)
- [Challenge 3: CLI vs. Controller Comparison](#challenge-3-cli-vs-controller-comparison)
- [Challenge 4: API Request Analysis](#challenge-4-api-request-analysis)
- [Challenge 5: Ansible Playbook Design](#challenge-5-ansible-playbook-design)
- [Scoring Guide](#scoring-guide)

---

## Challenge 1: Parse a Routing Table from JSON

**Task:** Given this JSON routing table, manually answer the questions below (then verify with Python if you want).

```json
{
  "router": "R1-Edge",
  "routes": [
    {
      "protocol": "connected",
      "network": "192.168.1.0/24",
      "nextHop": null,
      "interface": "GigabitEthernet0/0",
      "ad": 0,
      "metric": 0
    },
    {
      "protocol": "ospf",
      "network": "10.0.0.0/8",
      "nextHop": "192.168.1.2",
      "interface": "GigabitEthernet0/0",
      "ad": 110,
      "metric": 20
    },
    {
      "protocol": "static",
      "network": "0.0.0.0/0",
      "nextHop": "203.0.113.1",
      "interface": "GigabitEthernet0/1",
      "ad": 1,
      "metric": 0
    },
    {
      "protocol": "ospf",
      "network": "172.16.0.0/16",
      "nextHop": "192.168.1.3",
      "interface": "GigabitEthernet0/0",
      "ad": 110,
      "metric": 30
    },
    {
      "protocol": "ospf",
      "network": "10.1.1.0/24",
      "nextHop": "192.168.1.2",
      "interface": "GigabitEthernet0/0",
      "ad": 110,
      "metric": 10
    }
  ]
}
```

**Questions:**
1. How many total routes are in the table?
2. List all routes to networks starting with `10.`
3. What is the next-hop for the default route?
4. Which route has the highest OSPF metric?
5. If a packet is destined for `10.1.1.50`, which route is used and why?

<details>
<summary><strong>Answers</strong></summary>

1. **5 routes**
2. Routes starting with 10:
   - `10.0.0.0/8` via 192.168.1.2 (metric 20)
   - `10.1.1.0/24` via 192.168.1.2 (metric 10)
3. Default route next-hop: **203.0.113.1**
4. `172.16.0.0/16` with metric **30**
5. **`10.1.1.0/24`** via 192.168.1.2 — **longest prefix match** (/24 is more specific than /8). Even though 10.0.0.0/8 also matches, the /24 is preferred.

**Python verification:**
```python
import json

with open("routing_table.json") as f:
    data = json.load(f)

# Q2: Routes starting with 10.
ten_routes = [r for r in data["routes"] if r["network"].startswith("10.")]
for r in ten_routes:
    print(f"{r['network']} via {r['nextHop']} (metric {r['metric']})")
```

</details>

---

## Challenge 2: Ping Sweep Script

**Task:** Write a Python script that:
1. Reads a CSV file of hostnames and IPs
2. Pings each one
3. Reports UP/DOWN status
4. Saves results to a JSON file

**Input file (`hosts.csv`):**
```csv
hostname,ip
R1-Edge,192.168.1.1
SW1-Core,192.168.1.2
R2-Branch,192.168.2.1
Server1,192.168.3.100
Printer1,192.168.3.200
```

**Expected output:**
```
R1-Edge (192.168.1.1): UP
SW1-Core (192.168.1.2): UP
R2-Branch (192.168.2.1): DOWN
Server1 (192.168.3.100): UP
Printer1 (192.168.3.200): DOWN

Results saved to ping_results.json
```

<details>
<summary><strong>Solution</strong></summary>

```python
import csv
import subprocess
import json
import sys
import platform

def ping_host(ip):
    """Ping a host and return True if reachable."""
    # Use -c for Linux/Mac, -n for Windows
    param = "-n" if platform.system().lower() == "windows" else "-c"
    timeout = "-W" if platform.system().lower() != "windows" else "-w"
    
    try:
        result = subprocess.run(
            ["ping", param, "1", timeout, "1", ip],
            capture_output=True,
            timeout=5
        )
        return result.returncode == 0
    except subprocess.TimeoutExpired:
        return False

def main():
    results = []
    
    with open("hosts.csv") as f:
        reader = csv.DictReader(f)
        for row in reader:
            hostname = row["hostname"]
            ip = row["ip"]
            is_up = ping_host(ip)
            status = "UP" if is_up else "DOWN"
            
            print(f"{hostname} ({ip}): {status}")
            results.append({
                "hostname": hostname,
                "ip": ip,
                "status": status
            })
    
    # Save to JSON
    with open("ping_results.json", "w") as f:
        json.dump({"results": results, "total": len(results)}, f, indent=2)
    
    print(f"\nResults saved to ping_results.json")

if __name__ == "__main__":
    main()
```

</details>

---

## Challenge 3: CLI vs. Controller Comparison

**Task:** Compare traditional CLI management vs. DNA Center (controller-based) for a **200-switch campus network**.

Write a comparison covering:

| Factor | CLI (Traditional) | DNA Center (Controller) |
|--------|-------------------|------------------------|
| Initial VLAN deployment (200 switches) | | |
| Day-to-day changes (1 VLAN) | | |
| Compliance check | | |
| Troubleshooting a user issue | | |
| Software upgrade | | |
| Total cost of operations | | |

<details>
<summary><strong>Answer</strong></summary>

| Factor | CLI (Traditional) | DNA Center (Controller) |
|--------|-------------------|------------------------|
| Initial VLAN deployment | SSH into 200 switches, paste config on each. ~2 min × 200 = **6+ hours**. Risk of typos. | Create template, define group, push to all 200. **~15 minutes**. Consistent. |
| Day-to-day VLAN change | SSH to affected switches. Must know which ones. | Policy-based push. Automatic device selection. |
| Compliance check | Write custom scripts or manually check each device. | Built-in compliance dashboard. Auto-detect drift. |
| Troubleshooting | SSH to each device, run show commands, correlate manually. | Assurance dashboard: client 360 view, path trace, AI insights. |
| Software upgrade | Manual: stage, verify, schedule per device. Very slow. | Image management: stage, verify compatibility, schedule across all at once. |
| Total cost | Lower hardware cost, **much higher** OPEX (time, staff) | Higher initial cost (WLC license), **much lower** OPEX |

**Conclusion:** CLI works for small networks (<20 devices). Beyond that, controller-based management is dramatically more efficient. The break-even point is typically around 50-100 devices, after which controller ROI is clear.

</details>

---

## Challenge 4: API Request Analysis

**Task:** For each API request below, identify the HTTP method, what it does, and what response code you'd expect on success.

**Request A:**
```http
GET /api/v1/network-device HTTP/1.1
Host: dnac.company.com
X-Auth-Token: abc123
Accept: application/json
```

**Request B:**
```http
POST /api/v1/vlan HTTP/1.1
Host: switch-api.company.com
Content-Type: application/json
Authorization: Bearer abc123

{
  "vlanId": 100,
  "name": "Engineering",
  "state": "active"
}
```

**Request C:**
```http
DELETE /api/v1/network-device/3e4f5a6b-7c8d HTTP/1.1
Host: dnac.company.com
X-Auth-Token: abc123
```

**Request D:**
```http
PUT /api/v1/network-device/3e4f5a6b-7c8d HTTP/1.1
Host: dnac.company.com
Content-Type: application/json
X-Auth-Token: abc123

{
  "hostname": "R1-EDGE-NEW",
  "location": "Building A, Floor 2"
}
```

<details>
<summary><strong>Answers</strong></summary>

| Request | Method | Action | Expected Success Code |
|---------|--------|--------|----------------------|
| A | GET | Retrieve list of all network devices | **200 OK** |
| B | POST | Create a new VLAN (ID 100, Engineering) | **201 Created** |
| C | DELETE | Remove a specific network device by ID | **204 No Content** |
| D | PUT | Update (replace) device info: new hostname and location | **200 OK** |

</details>

---

## Challenge 5: Ansible Playbook Design

**Task:** Design (write) an Ansible playbook that performs these tasks on all routers:

1. Set the hostname to match the inventory name
2. Configure `enable secret Cisco$ecure1`
3. Configure SSH (domain name, RSA keys, SSH version 2)
4. Create a local user: `admin` / `AdminPass1`
5. Set VTY lines to SSH only with local authentication
6. Configure NTP server: 10.0.0.1
7. Configure a banner MOTD
8. Save the configuration

<details>
<summary><strong>Solution</strong></summary>

```yaml
---
- name: Harden all routers
  hosts: routers
  gather_facts: no
  connection: network_cli

  vars:
    ntp_server: 10.0.0.1
    domain_name: company.local
    admin_user: admin
    admin_pass: AdminPass1
    enable_secret: Cisco$ecure1
    banner_text: "WARNING: Authorized access only. All activity is monitored."

  tasks:
    - name: Set hostname
      cisco.ios.ios_config:
        lines:
          - hostname {{ inventory_hostname }}

    - name: Configure enable secret
      cisco.ios.ios_config:
        lines:
          - enable secret {{ enable_secret }}

    - name: Configure domain and SSH
      cisco.ios.ios_config:
        lines:
          - ip domain-name {{ domain_name }}
          - ip ssh version 2
          - crypto key generate rsa modulus 2048

    - name: Create local admin user
      cisco.ios.ios_config:
        lines:
          - username {{ admin_user }} privilege 15 secret {{ admin_pass }}

    - name: Configure VTY lines
      cisco.ios.ios_config:
        parents: line vty 0 15
        lines:
          - transport input ssh
          - login local
          - exec-timeout 5 0

    - name: Configure NTP
      cisco.ios.ios_config:
        lines:
          - ntp server {{ ntp_server }}

    - name: Set banner
      cisco.ios.ios_config:
        lines:
          - banner motd ^{{ banner_text }}^

    - name: Save configuration
      cisco.ios.ios_config:
        save_when: modified
```

**Key points:**
- `connection: network_cli` = SSH-based, agentless
- `{{ inventory_hostname }}` = automatic variable from Ansible inventory
- `vars` section makes it easy to change values without modifying tasks
- `save_when: modified` only saves if changes were made

</details>

---

## Scoring Guide

| Challenge | Difficulty | Time Target |
|-----------|-----------|-------------|
| 1. JSON routing table | ⭐ Easy | 10 minutes |
| 2. Ping sweep script | ⭐⭐ Medium | 20 minutes |
| 3. CLI vs. controller | ⭐⭐ Medium | 15 minutes |
| 4. API request analysis | ⭐ Easy | 10 minutes |
| 5. Ansible playbook | ⭐⭐⭐ Hard | 25 minutes |

---

**Week 10 complete! → [Start Week 11](../week-11/concepts.md)**
