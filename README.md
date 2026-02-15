# CCNA 200-301 — Complete Lab & Study Materials

## Overview

**Exam:** Cisco Certified Network Associate (200-301)  
**Timeline:** 12 weeks (Feb 15 – May 15, 2026)  
**Simulation:** Containerlab (Docker) + Cisco Packet Tracer  

This repository contains everything you need to study for the CCNA 200-301 exam:
- **Concept Notes** with embedded quizzes and answers
- **Hands-on Lab Exercises** you can run locally in Docker via Containerlab
- **Challenge Problems** to test yourself independently

---

## Directory Structure

```
CCNA/
├── README.md                    ← You are here
├── CCNA-200-301-Learning-Plan.md ← Original 12-week plan
├── setup/
│   ├── ENVIRONMENT-SETUP.md     ← How to install everything
│   ├── docker-compose.yml       ← Base Docker services
│   └── install.sh               ← One-click install script (macOS)
│
├── week-01/                     ← Network Fundamentals: OSI & TCP/IP
│   ├── concepts.md              ← Theory + Quiz + Answers
│   ├── exercises.md             ← Step-by-step hands-on labs
│   ├── challenges.md            ← Independent practice problems
│   └── lab/
│       ├── topology.yml         ← Containerlab topology file
│       └── configs/             ← Device configurations
│
├── week-02/ ... week-12/        ← Same structure for each week
```

---

## Simulation Environment

### Two Environments (Use Both)

| Tool | Purpose | Cost |
|------|---------|------|
| **Containerlab + FRRouting** | Docker-based network simulation (routing, services) | Free |
| **Cisco Packet Tracer** | Cisco-specific features (VLANs, STP, port security, wireless) | Free (NetAcad account required) |

### Why Two Environments?

- **Containerlab** runs real Linux networking stacks in Docker — you get actual routing daemons (FRR supports OSPF, BGP, static routes), real DHCP/DNS/NAT via Linux, and everything runs on your Mac locally.
- **Cisco Packet Tracer** is needed for Cisco IOS-specific CLI syntax, switch features (VLANs, STP, port security), and wireless simulation — these can't be fully replicated in open-source tools.

**For the actual CCNA exam:** Cisco uses **Cisco Modeling Labs (CML)** for their simlet questions. Packet Tracer uses the same IOS command syntax, making it the best free practice tool for exam-style questions.

---

## Quick Start

```bash
# 1. Run the install script
cd setup/
chmod +x install.sh
./install.sh

# 2. Start your first lab (Week 1)
cd ../week-01/lab/
sudo containerlab deploy -t topology.yml

# 3. Connect to a node
docker exec -it clab-week01-pc1 bash

# 4. When done, tear down the lab
sudo containerlab destroy -t topology.yml
```

---

## Weekly Schedule

| Week | Topic | Domain | Weight |
|------|-------|--------|--------|
| 1 | OSI & TCP/IP Models | Network Fundamentals | 20% |
| 2 | IPv4 Addressing & Subnetting | Network Fundamentals | 20% |
| 3 | IPv6 & Dual Stack | Network Fundamentals | 20% |
| 4 | Ethernet, Switching & VLANs | Network Access | 20% |
| 5 | STP, EtherChannel & Inter-VLAN | Network Access | 20% |
| 6 | Static & Dynamic Routing (OSPF) | IP Connectivity | 25% |
| 7 | DHCP, DNS, NAT/PAT, NTP, SNMP | IP Services | 10% |
| 8 | Security Fundamentals | Security Fundamentals | 15% |
| 9 | Wireless Networking (WLAN) | Security Fundamentals | 15% |
| 10 | Automation & Programmability | Automation | 10% |
| 11 | Review & Practice Exams | All | — |
| 12 | Final Review & Exam Readiness | All | — |

---

## How to Use These Materials

### For Each Week:

1. **Read `concepts.md`** — Study the theory, then take the quiz at the bottom (answers are in a collapsible section)
2. **Work through `exercises.md`** — Follow step-by-step. Deploy the Containerlab topology and/or open Packet Tracer
3. **Attempt `challenges.md`** — Try these without looking at notes. They're designed to push you beyond the exercises

### Study Tips:
- Spend **~10-13 hours/week** (4-5 reading, 4-5 labs, 2-3 challenges)
- Always type commands yourself — don't copy-paste
- If you get stuck, re-read the concept section before searching online
- Keep a personal "mistakes" journal for exam review

---

> **Good luck on your CCNA journey! Start with [setup/ENVIRONMENT-SETUP.md](setup/ENVIRONMENT-SETUP.md) to get your lab environment ready.**
