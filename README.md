# PCAP-Analysis-Toolkit

![Bash](https://img.shields.io/badge/Bash-Scripting-green)
![Network Analysis](https://img.shields.io/badge/Network-Analysis-blue)
![Security Forensics](https://img.shields.io/badge/Security-Forensics-orange)
![Automation](https://img.shields.io/badge/Automation-Tools-purple)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)

A professional network traffic analysis suite designed for security analysts, system administrators, and network professionals. This toolkit provides comprehensive PCAP analysis capabilities for forensic investigations and network troubleshooting.

## Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Installation](#-installation)
- [Usage](#-usage)
- [Scripts Documentation](#-scripts-documentation)
- [Use Cases](#-use-cases)
- [Output Examples](#-output-examples)
- [Professional Applications](#-professional-applications)
- [Contributing](#-contributing)
- [License](#-license)

##  Overview (#-overview)

The PCAP Analysis Toolkit is a collection of Bash scripts that automate the analysis of network packet captures. It leverages industry-standard tools like `tshark` and `capinfos` to provide deep insights into network traffic patterns, security incidents, and performance issues.

##  Features

###  **Comprehensive Protocol Analysis**
- Hierarchical protocol statistics
- Traffic distribution by layer
- Service and application identification
- Encapsulation analysis

###  **Advanced TCP Analysis**
- Connection state tracking (SYN, FIN, RST)
- Complete vs incomplete handshakes
- Retransmission detection
- Duplicate ACK analysis
- Window size and sequence analysis

###  **Conversation Analysis**
- Top TCP/UDP conversations
- Communication patterns
- Host identification
- Active ports and services

###  **Anomaly Detection**
- Port scanning detection
- Rejected connections
- Suspicious network behavior
- Performance issues identification

###  **Reporting Capabilities**
- Professional text reports
- Color-coded terminal output
- Statistical summaries
- Executive summaries

##  Installation

### Prerequisites

```bash
# Install dependencies on Kali Linux/Ubuntu/Debian
sudo apt update
sudo apt install wireshark tshark

# Or on RHEL/CentOS/Fedora
sudo yum install wireshark tshark
