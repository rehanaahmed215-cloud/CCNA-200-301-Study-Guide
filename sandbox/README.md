# Sandbox Lab

A free-form environment for experimenting with networking commands — no weekly objectives, just a playground.

## Topology

```
                 10.0.1.0/24                          10.0.2.0/24
  ┌──────┐      ┌──────────┐      ┌──────────┐      ┌──────┐
  │  h1  ├──eth1┤          │      │          ├eth2──┤  h3  │
  │.10   │      │   sw1    ├eth3──┤    r1    │      │.10   │
  │      │      │ (bridge) │  eth1│ (FRR)    │      │      │
  ├──────┤      │          │      │ .1    .1 │      └──────┘
  │  h2  ├──eth1┤          │      └──────────┘
  │.20   │      └──────────┘
  └──────┘
```

| Node | IP             | Subnet       | Role                        |
|------|----------------|--------------|-----------------------------|
| h1   | 10.0.1.10/24   | 10.0.1.0/24  | Host on LAN 1               |
| h2   | 10.0.1.20/24   | 10.0.1.0/24  | Host on LAN 1               |
| r1   | 10.0.1.1/24 (eth1), 10.0.2.1/24 (eth2) | — | FRR router between subnets |
| h3   | 10.0.2.10/24   | 10.0.2.0/24  | Host on LAN 2               |
| sw1  | —              | 10.0.1.0/24  | Linux bridge (L2)           |

## Quick Start

```bash
# Deploy
sudo containerlab deploy -t sandbox/topology.yml

# Connect to nodes
docker exec -it clab-play-h1  bash      # host shell
docker exec -it clab-play-h2  bash      # host shell
docker exec -it clab-play-h3  bash      # host shell
docker exec -it clab-play-r1  vtysh     # Cisco-style CLI
docker exec -it clab-play-sw1 bash      # bridge/switch shell

# Tear down when done
sudo containerlab destroy -t sandbox/topology.yml
```

## Things to Try

### Basic Connectivity
```bash
# From h1 — ping h2 (same subnet)
ping 10.0.1.20

# From h1 — ping h3 (across the router)
ping 10.0.2.10

# Check your own addresses
ip addr show
ip route
```

### Router (FRR / vtysh)
```
show ip route
show interface brief
configure terminal
  ip route 0.0.0.0/0 10.0.1.1      # add a static route
  router ospf                        # start playing with OSPF
end
write memory
```

### Switch / Bridge
```bash
bridge link show          # see ports attached to the bridge
bridge fdb show           # MAC address table (CAM table equivalent)
ip link show master br0   # interfaces in the bridge
```

### Useful Host Commands
```bash
traceroute 10.0.2.10          # trace the path across the router
arp -a                         # view the ARP cache
tcpdump -i eth1 -n             # capture packets
curl ifconfig.me               # test internet access (if routed)
nslookup google.com            # DNS lookup
ss -tulnp                      # listening sockets
```
