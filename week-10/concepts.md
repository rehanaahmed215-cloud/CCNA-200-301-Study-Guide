# Week 10 — Concepts: Network Automation & Programmability

## Table of Contents
- [1. Why Network Automation?](#1-why-network-automation)
- [2. Traditional vs. Controller-Based Networking](#2-traditional-vs-controller-based-networking)
- [3. Software-Defined Networking (SDN)](#3-software-defined-networking-sdn)
- [4. Cisco DNA Center](#4-cisco-dna-center)
- [5. Cisco SD-WAN](#5-cisco-sd-wan)
- [6. REST APIs](#6-rest-apis)
- [7. HTTP Methods](#7-http-methods)
- [8. HTTP Status Codes](#8-http-status-codes)
- [9. Data Formats — JSON](#9-data-formats--json)
- [10. Data Formats — XML and YAML](#10-data-formats--xml-and-yaml)
- [11. Configuration Management Tools](#11-configuration-management-tools)
- [12. Basic Python for Networking](#12-basic-python-for-networking)
- [Quiz — 10 Questions](#quiz--10-questions)

---

## 1. Why Network Automation?

| Manual CLI | Automation |
|-----------|-----------|
| Slow (one device at a time) | Fast (100s of devices at once) |
| Error-prone (typos, inconsistency) | Consistent (same config every time) |
| Doesn't scale | Scales to thousands of devices |
| No audit trail | Version-controlled changes |
| Reactive (fix after break) | Proactive (detect and prevent) |

**Key drivers:**
- Networks are larger and more complex
- Speed of business requires faster changes
- Compliance (prove what was changed, when, by whom)
- Reduce OPEX (operational expenditure)

---

## 2. Traditional vs. Controller-Based Networking

**Traditional:**
- Each device configured independently via CLI
- Device-by-device management
- No centralized view of the network
- Changes are imperative: "do this, then this, then this"

**Controller-Based:**
- Centralized controller manages all devices
- Single pane of glass (dashboard)
- Declarative: "I want this outcome" → controller figures out the how
- APIs for integration with other systems

**Network planes:**
| Plane | Function | Traditional | SDN |
|-------|----------|------------|-----|
| **Data (Forwarding)** | Actually moves packets | On device | On device |
| **Control** | Decides where packets go (routing, switching) | On device | Centralized controller |
| **Management** | Configure and monitor | On device (CLI) | Centralized controller (API/GUI) |

---

## 3. Software-Defined Networking (SDN)

SDN separates the **control plane** from the **data plane** and centralizes it.

**SDN architecture:**
```
┌─────────────────────────────┐
│      SDN Application        │  ← Business apps, automation
├─────────── NBI ─────────────┤  ← Northbound Interface (REST API)
│      SDN Controller         │  ← Central brain
├─────────── SBI ─────────────┤  ← Southbound Interface (OpenFlow, NETCONF)
│  Network Devices            │  ← Switches, routers (data plane only)
└─────────────────────────────┘
```

**Key interfaces:**
- **Northbound Interface (NBI):** How apps talk TO the controller (typically REST API)
- **Southbound Interface (SBI):** How the controller talks TO network devices (OpenFlow, NETCONF, RESTCONF, CLI)

---

## 4. Cisco DNA Center

Cisco's SDN controller for enterprise campus networks.

**Key features:**
- **Design:** Network hierarchy (sites, buildings, floors), device profiles
- **Policy:** Group-Based Access Control (SGACL), application policies
- **Provision:** Zero-touch provisioning, template-based config
- **Assurance:** AI/ML-driven network health, issue detection, client experience scoring

**DNA Center APIs:**
- RESTful APIs for integration
- Intent-based networking: "I want VLAN 10 on all access switches in Building A" → DNA Center pushes the config

**Cisco SD-Access (SDA):** Fabric-based campus built on DNA Center. Uses VXLAN overlays and LISP for scalable policy enforcement.

---

## 5. Cisco SD-WAN

Software-Defined WAN for branch office connectivity.

**Components:**
| Component | Role |
|-----------|------|
| **vManage** | Central management dashboard and API |
| **vSmart** | Control plane (routing policy, topology) |
| **vBond** | Orchestrator (authenticates and connects components) |
| **vEdge / cEdge** | Data plane routers at branch sites |

**Benefits over traditional WAN:**
- Centralized policy management
- Transport-independent (MPLS, internet, LTE — all usable)
- Application-aware routing (route Zoom over MPLS, web browsing over internet)
- Zero-touch provisioning for branches

---

## 6. REST APIs

REST (Representational State Transfer) is the most common API architecture.

**REST principles:**
1. **Client-Server:** Client sends requests, server responds
2. **Stateless:** Each request contains all needed information (no session state)
3. **Resource-based:** Everything is a resource identified by a URI
4. **Uniform interface:** Standard HTTP methods

**API structure:**
```
https://sandboxdnac.cisco.com/dna/intent/api/v1/network-device
└──── base URL ──────────────┘└──── resource path ───────────┘
```

**Authentication:** Typically token-based:
1. POST credentials to login endpoint → receive token
2. Include token in subsequent requests: `X-Auth-Token: <token>`

---

## 7. HTTP Methods

| Method | CRUD Operation | Description | Example |
|--------|---------------|-------------|---------|
| **GET** | Read | Retrieve data | Get list of all devices |
| **POST** | Create | Create new resource | Add a new VLAN |
| **PUT** | Update (full) | Replace entire resource | Update device config |
| **PATCH** | Update (partial) | Modify specific fields | Change hostname only |
| **DELETE** | Delete | Remove a resource | Delete a VLAN |

**Example GET request:**
```
GET /api/v1/network-device HTTP/1.1
Host: sandboxdnac.cisco.com
X-Auth-Token: abc123xyz
Accept: application/json
```

**Example POST request:**
```
POST /api/v1/vlan HTTP/1.1
Host: switch.company.com
Content-Type: application/json

{
  "vlanId": 100,
  "name": "Engineering"
}
```

---

## 8. HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| **200** | OK | Request succeeded (GET) |
| **201** | Created | Resource created (POST) |
| **204** | No Content | Success, no body returned (DELETE) |
| **400** | Bad Request | Malformed request (syntax error) |
| **401** | Unauthorized | Authentication failed |
| **403** | Forbidden | Authenticated but no permission |
| **404** | Not Found | Resource doesn't exist |
| **500** | Internal Server Error | Server-side failure |

> CCNA: Memorize the meaning of 200, 201, 400, 401, 403, 404.

---

## 9. Data Formats — JSON

**JSON (JavaScript Object Notation)** is the most common data format for REST APIs.

**Structure:**
```json
{
  "hostname": "R1-Edge",
  "managementIp": "10.0.0.1",
  "interfaces": [
    {
      "name": "GigabitEthernet0/0",
      "ipAddress": "192.168.1.1",
      "status": "up"
    },
    {
      "name": "GigabitEthernet0/1",
      "ipAddress": "10.0.0.1",
      "status": "up"
    }
  ],
  "ospfEnabled": true,
  "vlans": [10, 20, 30]
}
```

**JSON data types:**
| Type | Example |
|------|---------|
| String | `"hostname": "R1"` |
| Number | `"vlanId": 10` |
| Boolean | `"enabled": true` |
| Array | `"vlans": [10, 20, 30]` |
| Object | `"interface": { "name": "Gig0/0" }` |
| Null | `"description": null` |

**Key rules:**
- Keys are always **strings in double quotes**
- No trailing commas
- No comments allowed

---

## 10. Data Formats — XML and YAML

### XML (eXtensible Markup Language)
```xml
<device>
  <hostname>R1-Edge</hostname>
  <managementIp>10.0.0.1</managementIp>
  <interfaces>
    <interface>
      <name>GigabitEthernet0/0</name>
      <ipAddress>192.168.1.1</ipAddress>
      <status>up</status>
    </interface>
  </interfaces>
</device>
```
- Uses opening and closing tags
- More verbose than JSON
- Used by NETCONF (network configuration protocol)

### YAML (YAML Ain't Markup Language)
```yaml
hostname: R1-Edge
managementIp: 10.0.0.1
interfaces:
  - name: GigabitEthernet0/0
    ipAddress: 192.168.1.1
    status: up
  - name: GigabitEthernet0/1
    ipAddress: 10.0.0.1
    status: up
ospfEnabled: true
vlans:
  - 10
  - 20
  - 30
```
- Indentation-based (like Python)
- Most human-readable
- Used by Ansible, Docker Compose, Containerlab, Kubernetes
- **Our topology.yml files are YAML!**

---

## 11. Configuration Management Tools

| Tool | Language | Push/Pull | Agent? | Config Format |
|------|----------|-----------|--------|---------------|
| **Ansible** | Python | Push (SSH) | **Agentless** | YAML playbooks |
| **Puppet** | Ruby | Pull | Agent required | Puppet DSL |
| **Chef** | Ruby | Pull | Agent required | Ruby DSL |
| **SaltStack** | Python | Both | Optional | YAML |

> **CCNA focus:** Know Ansible basics. It's agentless (uses SSH), uses YAML playbooks, and is the most popular for network automation.

**Sample Ansible playbook (YAML):**
```yaml
---
- name: Configure VLANs on switches
  hosts: access_switches
  gather_facts: no
  tasks:
    - name: Create VLAN 10
      cisco.ios.ios_vlans:
        config:
          - vlan_id: 10
            name: Sales
            state: active
        state: merged

    - name: Create VLAN 20
      cisco.ios.ios_vlans:
        config:
          - vlan_id: 20
            name: Engineering
            state: active
        state: merged
```

This playbook configures VLAN 10 and 20 on all switches in the `access_switches` group — no need to SSH into each switch individually.

---

## 12. Basic Python for Networking

Python is widely used for network automation. CCNA doesn't test Python coding deeply, but understanding basic scripts is important.

**Reading JSON in Python:**
```python
import json

# Parse JSON string
data = json.loads('{"hostname": "R1", "ip": "10.0.0.1"}')
print(data["hostname"])  # Output: R1

# Read JSON from file
with open("devices.json") as f:
    devices = json.load(f)
```

**Making API calls with requests:**
```python
import requests

# GET device list from DNA Center
url = "https://sandboxdnac.cisco.com/dna/intent/api/v1/network-device"
headers = {
    "X-Auth-Token": "your-token-here",
    "Accept": "application/json"
}

response = requests.get(url, headers=headers, verify=False)
devices = response.json()

for device in devices["response"]:
    print(f"Hostname: {device['hostname']}, IP: {device['managementIpAddress']}")
```

**Simple ping script:**
```python
import subprocess

hosts = ["192.168.1.1", "192.168.2.1", "192.168.3.1"]

for host in hosts:
    result = subprocess.run(["ping", "-c", "1", "-W", "1", host], 
                          capture_output=True)
    status = "UP" if result.returncode == 0 else "DOWN"
    print(f"{host}: {status}")
```

---

## Quiz — 10 Questions

**1.** What is the Northbound Interface in SDN?

<details><summary>Answer</summary>The interface between the SDN controller and applications/users. Typically a REST API. It's how applications communicate WITH the controller.</details>

**2.** What is the Southbound Interface in SDN?

<details><summary>Answer</summary>The interface between the SDN controller and network devices. Protocols include OpenFlow, NETCONF, RESTCONF, and SSH/CLI. It's how the controller communicates WITH devices.</details>

**3.** What HTTP method is used to create a new resource?

<details><summary>Answer</summary>POST</details>

**4.** What does HTTP status code 401 mean?

<details><summary>Answer</summary>Unauthorized — authentication failed (invalid or missing credentials/token)</details>

**5.** In JSON, what data type is this: `[10, 20, 30]`?

<details><summary>Answer</summary>Array (a list of values)</details>

**6.** What makes Ansible different from Puppet and Chef?

<details><summary>Answer</summary>Ansible is **agentless** — it connects via SSH (no software agent needed on managed devices). It uses a push model and YAML playbooks. Puppet and Chef require agents installed on targets.</details>

**7.** What is Cisco DNA Center?

<details><summary>Answer</summary>Cisco's enterprise SDN controller for campus networks. Provides intent-based networking with design, policy, provisioning, and assurance capabilities. Uses REST APIs for automation.</details>

**8.** What data format does NETCONF use?

<details><summary>Answer</summary>XML</details>

**9.** What is the purpose of the REST API `Accept: application/json` header?

<details><summary>Answer</summary>Tells the server that the client wants the response in JSON format</details>

**10.** Name the three network planes and which is centralized in SDN.

<details><summary>Answer</summary>Data (Forwarding) plane, Control plane, Management plane. In SDN, the **Control plane** is centralized on the SDN controller. The data plane remains on the devices.</details>

---

**Next → [Week 10 Exercises](exercises.md)**
