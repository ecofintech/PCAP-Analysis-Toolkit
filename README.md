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

<a name="-overview"></a>
##  Overview


The PCAP Analysis Toolkit is a collection of Bash scripts that automate the analysis of network packet captures. It leverages industry-standard tools like `tshark` and `capinfos` to provide deep insights into network traffic patterns, security incidents, and performance issues.
<a name="-features"></a>
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
<a name="-installation"></a>
##  Installation

### Prerequisites

```bash
# Install dependencies on Kali Linux/Ubuntu/Debian
sudo apt update
sudo apt install wireshark tshark

# Or on RHEL/CentOS/Fedora
sudo yum install wireshark tshark
```

# Clone the repository
```
git clone https://github.com/your-username/pcap-analysis-toolkit.git
cd pcap-analysis-toolkit

# Make scripts executable
chmod +x analyze_pcap.sh quick_pcap_analysis.sh
```

<a name="-usage"></a>
# Usage
```
# Comprehensive analysis with full report
./analyze_pcap.sh capture.pcap

# Quick analysis for initial assessment
./quick_pcap_analysis.sh capture.pcap
```
# Advanced Usage
```
# Analyze multiple captures
for cap in *.pcap; do
    echo "Analyzing: $cap"
    ./analyze_pcap.sh "$cap"
done

# Integrate with tcpdump for live analysis
sudo tcpdump -i eth0 -w live_capture.pcap -c 1000
./analyze_pcap.sh live_capture.pcap
```
<a name="-scripts-documentation"></a>
# Scripts Documentation
analyze_pcap.sh - Comprehensive Analysis Tool

Description: Full-featured PCAP analysis with detailed reporting and anomaly detection.

Features:

    Complete protocol hierarchy analysis

    TCP state machine analysis

    UDP conversation tracking

    IP address analysis

    Port usage statistics

    HTTP/HTTPS traffic examination

    DNS query analysis

    Anomaly detection

    Professional report generation

Output:

    Terminal output with color-coded sections

    Detailed text report: {filename}_analysis_report.txt

quick_pcap_analysis.sh - Rapid Assessment Tool

Description: Fast analysis for time-sensitive situations and initial triage.

Features:

    Basic file information

    Protocol distribution

    Essential TCP statistics

    Top IP addresses

    Quick anomaly assessment

Output: Concise terminal output for rapid decision-making.
# Use Cases
### Security Incident Response
```
# Analyze suspected compromise
./analyze_pcap.sh incident_capture.pcap

# Look for specific indicators
tshark -r incident_capture.pcap -Y "ip.addr == 192.168.1.100"
```

### Network Troubleshooting
```
# Capture and analyze network issues
sudo tcpdump -i any -w problem.pcap host 10.0.1.50
./analyze_pcap.sh problem.pcap
```
### Performance Analysis
```
# Monitor service performance
sudo tcpdump -i eth0 -w service_traffic.pcap port 80 or port 443
./analyze_pcap.sh service_traffic.pcap
```

### Forensic Investigations
Comprehensive traffic analysis
```
./analyze_pcap.sh forensic_capture.pcap
```
### Generate evidence report
```
cat forensic_capture_analysis_report.txt
```

# Output Examples

```
==================================================
   PCAP ANALYSIS: investigation.pcap
==================================================

=== BASIC FILE INFORMATION ===
File name:           investigation.pcap
File type:           Wireshark/... - pcap
Number of packets:   1,247
File size:           642 kB
Data size:           598 kB

=== PROTOCOL STATISTICS ===
eth:     100% | ip: 100% | tcp: 85% | http: 45% | dns: 15%

=== TCP ANALYSIS ===
SYN (Starts): 45
SYN-ACK (Responses): 43
FIN (Graceful closures): 38
RST (Abrupt closures): 2

=== ANOMALY DETECTION ===
[!] TCP retransmissions detected: 23
[!] Possible port scanning activity
[!] High number of incomplete conversations
```
