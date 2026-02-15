# Week 10 — Exercises: Network Automation & Programmability

## Table of Contents
- [Part A — Hands-On: REST API and Data Formats](#part-a--hands-on-rest-api-and-data-formats)
  - [Lab 1: Explore Cisco DevNet Sandbox](#lab-1-explore-cisco-devnet-sandbox)
  - [Lab 2: REST API with curl](#lab-2-rest-api-with-curl)
  - [Lab 3: Parse JSON Data](#lab-3-parse-json-data)
  - [Lab 4: Python API Script](#lab-4-python-api-script)
- [Part B — Configuration Management](#part-b--configuration-management)
  - [Lab 5: Read an Ansible Playbook](#lab-5-read-an-ansible-playbook)
  - [Lab 6: Compare Data Formats](#lab-6-compare-data-formats)
- [Part C — Packet Tracer: Controller Concepts](#part-c--packet-tracer-controller-concepts)
  - [Lab PT-1: Exploring Network Devices Programmatically](#lab-pt-1-exploring-network-devices-programmatically)

---

## Part A — Hands-On: REST API and Data Formats

### Lab 1: Explore Cisco DevNet Sandbox

**Step 1: Sign up for Cisco DevNet**
- Go to [https://developer.cisco.com](https://developer.cisco.com)
- Create a free account
- Navigate to **Sandbox** → search for "DNA Center"
- Use the **Always-On** DNA Center sandbox (no reservation needed)

**Step 2: Access the sandbox**
```
URL: https://sandboxdnac.cisco.com
Username: devnetuser
Password: Cisco123!
```

**Step 3: Explore the API documentation**
- Navigate to: `https://sandboxdnac.cisco.com/dna/platform/app/consumer-portal/developer-toolkit/apis`
- Browse available APIs: devices, interfaces, VLANs, clients

---

### Lab 2: REST API with curl

**Step 1: Authenticate and get a token**
```bash
curl -X POST "https://sandboxdnac.cisco.com/dna/system/api/v1/auth/token" \
  -H "Content-Type: application/json" \
  -u "devnetuser:Cisco123!" \
  --insecure \
  | python3 -m json.tool
```

Save the token from the response.

**Step 2: GET all network devices**
```bash
TOKEN="your-token-here"

curl -X GET "https://sandboxdnac.cisco.com/dna/intent/api/v1/network-device" \
  -H "X-Auth-Token: $TOKEN" \
  -H "Accept: application/json" \
  --insecure \
  | python3 -m json.tool
```

**Step 3: Study the response**
- How many devices are returned?
- What fields are available? (hostname, managementIpAddress, platformId, softwareVersion)
- What is the structure? (object with "response" array)

**Step 4: GET device by ID**
Pick a device ID from the previous response:
```bash
DEVICE_ID="some-uuid-here"

curl -X GET "https://sandboxdnac.cisco.com/dna/intent/api/v1/network-device/$DEVICE_ID" \
  -H "X-Auth-Token: $TOKEN" \
  -H "Accept: application/json" \
  --insecure \
  | python3 -m json.tool
```

---

### Lab 3: Parse JSON Data

**Step 1: Create a sample JSON file**
Create `devices.json`:
```json
{
  "response": [
    {
      "hostname": "R1-Edge",
      "managementIpAddress": "10.0.0.1",
      "platformId": "ISR4331",
      "softwareVersion": "17.3.4",
      "role": "ACCESS"
    },
    {
      "hostname": "SW1-Core",
      "managementIpAddress": "10.0.0.2",
      "platformId": "C9300-48P",
      "softwareVersion": "17.6.1",
      "role": "DISTRIBUTION"
    },
    {
      "hostname": "R2-Branch",
      "managementIpAddress": "10.0.1.1",
      "platformId": "ISR4221",
      "softwareVersion": "17.3.4",
      "role": "ACCESS"
    }
  ]
}
```

**Step 2: Parse with Python**
```python
import json

with open("devices.json") as f:
    data = json.load(f)

print(f"Total devices: {len(data['response'])}")
print()

for device in data["response"]:
    print(f"Hostname: {device['hostname']}")
    print(f"  IP: {device['managementIpAddress']}")
    print(f"  Platform: {device['platformId']}")
    print(f"  Version: {device['softwareVersion']}")
    print(f"  Role: {device['role']}")
    print()
```

**Step 3: Answer these questions by reading the JSON:**
- What is the management IP of SW1-Core?
- Which devices are running software version 17.3.4?
- What role does R1-Edge have?

---

### Lab 4: Python API Script

**Step 1: Create `get_devices.py`**
```python
import requests
import json

# Disable SSL warnings (sandbox uses self-signed cert)
requests.packages.urllib3.disable_warnings()

BASE_URL = "https://sandboxdnac.cisco.com"
USERNAME = "devnetuser"
PASSWORD = "Cisco123!"

# Step 1: Authenticate
auth_url = f"{BASE_URL}/dna/system/api/v1/auth/token"
response = requests.post(auth_url, auth=(USERNAME, PASSWORD), verify=False)
token = response.json()["Token"]
print(f"Token acquired: {token[:20]}...")

# Step 2: Get devices
headers = {
    "X-Auth-Token": token,
    "Accept": "application/json"
}
devices_url = f"{BASE_URL}/dna/intent/api/v1/network-device"
response = requests.get(devices_url, headers=headers, verify=False)
devices = response.json()["response"]

# Step 3: Display results
print(f"\n{'Hostname':<20} {'IP Address':<18} {'Platform':<15} {'Version'}")
print("-" * 70)
for device in devices:
    print(f"{device.get('hostname', 'N/A'):<20} "
          f"{device.get('managementIpAddress', 'N/A'):<18} "
          f"{device.get('platformId', 'N/A'):<15} "
          f"{device.get('softwareVersion', 'N/A')}")
```

**Step 2: Run it**
```bash
pip3 install requests
python3 get_devices.py
```

**Step 3: Modify the script to also show interface count for each device (hint: use `/dna/intent/api/v1/interface` endpoint)**

---

## Part B — Configuration Management

### Lab 5: Read an Ansible Playbook

**Task:** Read this Ansible playbook and answer the questions below.

```yaml
---
- name: Configure access switches
  hosts: access_switches
  gather_facts: no
  connection: network_cli

  vars:
    vlans:
      - id: 10
        name: Sales
      - id: 20
        name: Engineering
      - id: 30
        name: Guest

  tasks:
    - name: Create VLANs
      cisco.ios.ios_vlans:
        config: "{{ vlans | map(attribute='id') | list | map('community.general.dict_kw', vlan_id) }}"
        state: merged

    - name: Set hostname
      cisco.ios.ios_config:
        lines:
          - hostname {{ inventory_hostname }}

    - name: Configure NTP
      cisco.ios.ios_config:
        lines:
          - ntp server 10.0.0.1

    - name: Save configuration
      cisco.ios.ios_config:
        save_when: modified
```

**Questions:**
1. What devices does this playbook target?
2. How many VLANs will be created?
3. Does the playbook require an agent on the switches?
4. What format is the playbook written in?
5. What would you change to add VLAN 40 (Management)?

<details>
<summary><strong>Answers</strong></summary>

1. All devices in the `access_switches` group (defined in Ansible inventory)
2. 3 VLANs: 10 (Sales), 20 (Engineering), 30 (Guest)
3. No — Ansible is agentless, uses `network_cli` connection (SSH)
4. YAML
5. Add to the `vlans` list:
   ```yaml
   - id: 40
     name: Management
   ```

</details>

---

### Lab 6: Compare Data Formats

**Task:** Convert this network device information between all three formats.

**Given (English):**
- Router hostname: R1
- Management IP: 10.0.0.1
- OSPF enabled: yes
- Interfaces: Gig0/0 (192.168.1.1, up), Gig0/1 (10.0.0.1, up)

**Write the same data in JSON, XML, and YAML:**

<details>
<summary><strong>Answers</strong></summary>

**JSON:**
```json
{
  "hostname": "R1",
  "managementIp": "10.0.0.1",
  "ospfEnabled": true,
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
  ]
}
```

**XML:**
```xml
<device>
  <hostname>R1</hostname>
  <managementIp>10.0.0.1</managementIp>
  <ospfEnabled>true</ospfEnabled>
  <interfaces>
    <interface>
      <name>GigabitEthernet0/0</name>
      <ipAddress>192.168.1.1</ipAddress>
      <status>up</status>
    </interface>
    <interface>
      <name>GigabitEthernet0/1</name>
      <ipAddress>10.0.0.1</ipAddress>
      <status>up</status>
    </interface>
  </interfaces>
</device>
```

**YAML:**
```yaml
hostname: R1
managementIp: 10.0.0.1
ospfEnabled: true
interfaces:
  - name: GigabitEthernet0/0
    ipAddress: 192.168.1.1
    status: up
  - name: GigabitEthernet0/1
    ipAddress: 10.0.0.1
    status: up
```

</details>

---

## Part C — Packet Tracer: Controller Concepts

### Lab PT-1: Exploring Network Devices Programmatically

> Packet Tracer has limited API support, but you can practice the conceptual flow.

**Step 1: Build a simple network in Packet Tracer**
- 3 routers, 2 switches, 4 PCs — any topology from previous weeks

**Step 2: Gather device information manually**
On each device, run:
```
show version
show ip interface brief
show vlan brief           ← switches only
show ip route             ← routers only
```

**Step 3: Create a JSON inventory file**
Based on your `show` command output, create a `network-inventory.json` file on your PC:

```json
{
  "devices": [
    {
      "hostname": "R1",
      "type": "router",
      "managementIp": "...",
      "interfaces": [...],
      "routes": [...]
    }
  ]
}
```

**Step 4: Reflect**
- How long did it take to gather all this info manually?
- How would an API make this faster?
- What if you had 200 devices instead of 5?

This exercise demonstrates WHY automation matters — the manual process doesn't scale.

---

**Next → [Week 10 Challenges](challenges.md)**
