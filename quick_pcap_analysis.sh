#!/bin/bash
# ANÁLISIS RÁPIDO DE PCAP

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 archivo.pcap"
    exit 1
fi

PCAP_FILE="$1"

echo "=== ANÁLISIS RÁPIDO: $PCAP_FILE ==="

# Info básica
echo "1. INFORMACIÓN BÁSICA:"
capinfos "$PCAP_FILE" | grep -E "(File name|Number of packets|Data size)"

# Protocolos
echo -e "\n2. PROTOCOLOS:"
tshark -r "$PCAP_FILE" -q -z io,phs

# Conexiones TCP
echo -e "\n3. ESTADOS TCP:"
echo "SYN: $(tshark -r "$PCAP_FILE" -Y "tcp.flags.syn==1" -q 2>/dev/null | wc -l)"
echo "FIN: $(tshark -r "$PCAP_FILE" -Y "tcp.flags.fin==1" -q 2>/dev/null | wc -l)" 
echo "RST: $(tshark -r "$PCAP_FILE" -Y "tcp.flags.reset==1" -q 2>/dev/null | wc -l)"

# Top direcciones
echo -e "\n4. TOP DIRECCIONES:"
tshark -r "$PCAP_FILE" -T fields -e ip.dst 2>/dev/null | sort | uniq -c | sort -rn | head -5
