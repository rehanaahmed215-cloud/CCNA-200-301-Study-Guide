# Week 1 — Exercises: OSI & TCP/IP in Action

## Lab Overview

In this lab, you will:
1. Deploy a simple 2-host network using Containerlab
2. Capture and analyze traffic at each OSI layer
3. Observe ARP, ICMP, and TCP in action
4. Also practice in Cisco Packet Tracer for IOS-specific experience

---

## Part A: Containerlab Lab — Observing Network Layers

### Exercise 1: Deploy the Topology

Our topology: **PC1** ↔ **Switch (Linux bridge)** ↔ **PC2**

```
┌──────┐       ┌────────┐       ┌──────┐
│ PC1  │──eth1─│ Switch │─eth2──│ PC2  │
│.10   │       │(bridge)│       │  .20 │
└──────┘       └────────┘       └──────┘
         192.168.1.0/24
```

**Step 1:** Navigate to the lab directory
```bash
cd ~/Desktop/CCNA/week-01/lab/
```

**Step 2:** Deploy the topology
```bash
sudo containerlab deploy -t topology.yml
```

**Step 3:** Verify containers are running
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
```

You should see three containers: `clab-week01-pc1`, `clab-week01-switch`, `clab-week01-pc2`.

---

### Exercise 2: Configure IP Addresses

**Step 1:** Assign IP to PC1
```bash
docker exec -it clab-week01-pc1 sh -c "
  ip addr add 192.168.1.10/24 dev eth1
  ip link set eth1 up
  echo 'PC1 configured:'
  ip addr show eth1
"
```

**Step 2:** Assign IP to PC2
```bash
docker exec -it clab-week01-pc2 sh -c "
  ip addr add 192.168.1.20/24 dev eth1
  ip link set eth1 up
  echo 'PC2 configured:'
  ip addr show eth1
"
```

**Step 3:** Verify configuration on both hosts
```bash
docker exec clab-week01-pc1 ip addr show eth1
docker exec clab-week01-pc2 ip addr show eth1
```

**What to observe:**
- Each interface has an IP address (Layer 3) and a MAC address (Layer 2)
- The `/24` subnet mask means both hosts are on the same network

---

### Exercise 3: Test Connectivity with Ping (ICMP — Layer 3)

**Step 1:** Ping PC2 from PC1
```bash
docker exec clab-week01-pc1 ping -c 4 192.168.1.20
```

**Expected output:**
```
PING 192.168.1.20 (192.168.1.20): 56 data bytes
64 bytes from 192.168.1.20: seq=0 ttl=64 time=0.123 ms
64 bytes from 192.168.1.20: seq=1 ttl=64 time=0.089 ms
...
```

**What to observe:**
- `64 bytes` — the size of the ICMP echo reply (Layer 3 packet)
- `ttl=64` — Time to Live, decremented by each router hop
- `time=0.123 ms` — round-trip time

**Step 2:** Ping in the other direction
```bash
docker exec clab-week01-pc2 ping -c 4 192.168.1.10
```

---

### Exercise 4: Observe ARP (Layer 2 ↔ Layer 3 Bridge)

ARP resolves IP addresses to MAC addresses. Let's watch it happen.

**Step 1:** Clear ARP caches on both hosts
```bash
docker exec clab-week01-pc1 ip neigh flush all
docker exec clab-week01-pc2 ip neigh flush all
```

**Step 2:** Start a packet capture on PC1 (run in a separate terminal)
```bash
docker exec clab-week01-pc1 tcpdump -i eth1 -n -c 10 arp or icmp
```

**Step 3:** In another terminal, ping from PC1 to PC2
```bash
docker exec clab-week01-pc1 ping -c 1 192.168.1.20
```

**What you should see in the tcpdump output:**
```
ARP, Request who-has 192.168.1.20 tell 192.168.1.10
ARP, Reply 192.168.1.20 is-at aa:bb:cc:dd:ee:ff
ICMP echo request
ICMP echo reply
```

**Layer-by-layer breakdown:**
1. PC1 knows the destination IP (192.168.1.20) — **Layer 3**
2. PC1 doesn't know the destination MAC → sends ARP broadcast — **Layer 2/3**
3. PC2 replies with its MAC address — **Layer 2**
4. PC1 now has both IP and MAC, creates the ICMP echo request — **Layer 3**
5. The ICMP packet is encapsulated in an Ethernet frame — **Layer 2**
6. The frame is sent as bits on the wire — **Layer 1**

**Step 4:** View the ARP table
```bash
docker exec clab-week01-pc1 ip neigh show
```
You should see `192.168.1.20` mapped to PC2's MAC address.

---

### Exercise 5: Observe TCP Three-Way Handshake (Layer 4)

**Step 1:** Start a simple TCP server on PC2 (listening on port 8080)
```bash
docker exec -d clab-week01-pc2 sh -c "while true; do echo 'HTTP/1.1 200 OK\n\nHello from PC2' | nc -l -p 8080; done"
```

**Step 2:** Capture TCP packets on PC2
```bash
docker exec clab-week01-pc2 tcpdump -i eth1 -n -c 20 port 8080 &
```

**Step 3:** Connect from PC1 using TCP
```bash
docker exec clab-week01-pc1 sh -c "echo 'GET / HTTP/1.0\n\n' | nc -w 2 192.168.1.20 8080"
```

**What to observe in tcpdump:**
```
Flags [S]      ← SYN (PC1 → PC2: "I want to connect")
Flags [S.]     ← SYN-ACK (PC2 → PC1: "OK, I acknowledge")
Flags [.]      ← ACK (PC1 → PC2: "Connection established")
Flags [P.]     ← PSH-ACK (Data transfer)
Flags [F.]     ← FIN (Connection teardown)
```

**This is the TCP three-way handshake at Layer 4!**

---

### Exercise 6: Examine Encapsulation with tcpdump

**Step 1:** Do a detailed capture showing all layers
```bash
docker exec clab-week01-pc1 tcpdump -i eth1 -n -c 5 -XX icmp &
docker exec clab-week01-pc1 ping -c 2 192.168.1.20
```

**Step 2:** Analyze the output

The `-XX` flag shows the raw hex and ASCII of each packet. You'll see:
- **Bytes 0-13:** Ethernet header (Destination MAC, Source MAC, EtherType 0x0800 = IPv4) — **Layer 2**
- **Bytes 14-33:** IP header (Version, TTL, Source IP, Destination IP) — **Layer 3**
- **Bytes 34+:** ICMP data (Type 8 = Echo Request, Type 0 = Echo Reply) — **Layer 3**

This is encapsulation in action: `[Ethernet Frame [IP Packet [ICMP Data]]]`

---

### Exercise 7: Clean Up

```bash
cd ~/Desktop/CCNA/week-01/lab/
sudo containerlab destroy -t topology.yml
```

---

## Part B: Cisco Packet Tracer Lab

Perform these exercises in Packet Tracer to practice with Cisco's interface.

### Exercise PT-1: Build the Topology

1. Open Packet Tracer
2. Place **2 PCs** (PC0, PC1) and **1 Switch** (2960)
3. Connect PC0 to Switch Fa0/1, PC1 to Switch Fa0/2 using straight-through cables
4. Click on PC0 → Desktop → IP Configuration:
   - IP: `192.168.1.10`
   - Subnet: `255.255.255.0`
5. Click on PC1 → Desktop → IP Configuration:
   - IP: `192.168.1.20`
   - Subnet: `255.255.255.0`

### Exercise PT-2: Simulation Mode — Watch Encapsulation

1. Switch to **Simulation Mode** (bottom-right toggle)
2. On PC0, go to Desktop → Command Prompt → type `ping 192.168.1.20`
3. Click **Capture/Forward** button slowly
4. Watch the ARP request go out as a broadcast (yellow envelope)
5. Watch the ARP reply come back
6. Watch the ICMP Echo Request/Reply
7. **Click on any envelope** mid-transit → select "Inbound PDU Details" or "Outbound PDU Details"
8. You'll see the headers at each layer — this is the exam-style view of encapsulation

### Exercise PT-3: View MAC and ARP Tables

1. On PC0 Command Prompt:
   ```
   ipconfig
   arp -a
   ```
2. On the Switch CLI (click Switch → CLI):
   ```
   enable
   show mac address-table
   ```
3. **Observe:** The switch has learned which MAC address is on which port

### Exercise PT-4: Hub vs. Switch Comparison

1. Replace the switch with a **Hub** (from Network Devices → Hubs)
2. Add a third PC (PC2: 192.168.1.30)
3. Ping from PC0 to PC1 in Simulation Mode
4. **Observe:** The hub sends the frame to ALL ports (including PC2) — **Layer 1 behavior**
5. Now replace the hub back with a switch and repeat — the switch only sends to the correct port — **Layer 2 behavior**

---

## Verification Checklist

After completing all exercises, confirm you can:

- [ ] Deploy and destroy a Containerlab topology
- [ ] Assign IP addresses to containers
- [ ] Ping between hosts and explain what happens at each layer
- [ ] Capture and identify ARP requests/replies
- [ ] Capture and identify the TCP three-way handshake
- [ ] Read raw packet captures and identify L2/L3/L4 headers
- [ ] Use Packet Tracer Simulation Mode to visualize encapsulation
- [ ] Explain the difference between how a hub and switch handle frames

---

**Next:** [Challenges →](challenges.md)
