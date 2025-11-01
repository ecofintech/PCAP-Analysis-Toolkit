#!/bin/bash

# =============================================
# SCRIPT: ANALIZADOR DE CAPTURAS PCAP
# USO: ./analyze_pcap.sh archivo.pcap
# =============================================

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de ayuda
print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "   ANÁLISIS PCAP: $1"
    echo "=================================================="
    echo -e "${NC}"
}

print_section() {
    echo -e "${GREEN}"
    echo "=== $1 ==="
    echo -e "${NC}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# Verificar dependencias
check_dependencies() {
    local deps=("tshark" "capinfos")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            print_error "Falta dependencia: $dep"
            echo "Instalar con: sudo apt install wireshark"
            exit 1
        fi
    done
}

# Verificar archivo
check_file() {
    if [[ ! -f "$1" ]]; then
        print_error "Archivo no encontrado: $1"
        exit 1
    fi
    
    if [[ ! -r "$1" ]]; then
        print_error "Sin permisos de lectura: $1"
        exit 1
    fi
}

# Análisis básico del archivo
basic_analysis() {
    local pcap_file="$1"
    
    print_section "INFORMACIÓN BÁSICA DEL ARCHIVO"
    capinfos "$pcap_file" | grep -E "(File name|File type|File encapsulation|Packet size limit|Number of packets|File size|Data size)"
    
    echo
    print_section "ESTADÍSTICAS DE PROTOCOLOS"
    tshark -r "$pcap_file" -q -z io,phs
}

# Análisis de conexiones TCP
tcp_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS TCP"
    
    echo "--- CONVERSACIONES TCP ---"
    tshark -r "$pcap_file" -q -z conv,tcp 2>/dev/null | head -20
    
    echo
    echo "--- ESTADOS DE CONEXIÓN ---"
    local syn_count=$(tshark -r "$pcap_file" -Y "tcp.flags.syn==1" -q 2>/dev/null | wc -l)
    local fin_count=$(tshark -r "$pcap_file" -Y "tcp.flags.fin==1" -q 2>/dev/null | wc -l)
    local rst_count=$(tshark -r "$pcap_file" -Y "tcp.flags.reset==1" -q 2>/dev/null | wc -l)
    local syn_ack_count=$(tshark -r "$pcap_file" -Y "tcp.flags.syn==1 and tcp.flags.ack==1" -q 2>/dev/null | wc -l)
    
    echo "SYN (Inicios): $syn_count"
    echo "SYN-ACK (Respuestas): $syn_ack_count"
    echo "FIN (Cierres graceful): $fin_count"
    echo "RST (Cierres abruptos): $rst_count"
    
    # Detectar patrones problemáticos
    if [[ $syn_count -gt 0 && $syn_ack_count -eq 0 ]]; then
        print_warning "Posible escaneo o conexiones rechazadas - SYN sin respuestas"
    fi
    
    if [[ $rst_count -gt $syn_count ]]; then
        print_warning "Alto número de resets - Posibles problemas de conectividad"
    fi
}

# Análisis de conexiones UDP
udp_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS UDP"
    tshark -r "$pcap_file" -q -z conv,udp 2>/dev/null | head -15
}

# Análisis de direcciones IP
ip_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS DE DIRECCIONES IP"
    
    echo "--- TOP DESTINOS ---"
    tshark -r "$pcap_file" -T fields -e ip.dst 2>/dev/null | sort | uniq -c | sort -rn | head -10
    
    echo
    echo "--- TOP FUENTES ---"
    tshark -r "$pcap_file" -T fields -e ip.src 2>/dev/null | sort | uniq -c | sort -rn | head -10
}

# Análisis de puertos
port_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS DE PUERTOS"
    
    echo "--- PUERTOS DESTINO MÁS COMUNES ---"
    tshark -r "$pcap_file" -T fields -e tcp.dstport -e udp.dstport 2>/dev/null | sort -n | uniq -c | sort -rn | head -15
    
    echo
    echo "--- PUERTOS ORIGEN MÁS COMUNES ---"
    tshark -r "$pcap_file" -T fields -e tcp.srcport -e udp.srcport 2>/dev/null | sort -n | uniq -c | sort -rn | head -15
}

# Búsqueda de tráfico HTTP
http_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS HTTP/HTTPS"
    
    local http_count=$(tshark -r "$pcap_file" -Y "http" -q 2>/dev/null | wc -l)
    local https_count=$(tshark -r "$pcap_file" -Y "tls" -q 2>/dev/null | wc -l)
    
    echo "Paquetes HTTP: $http_count"
    echo "Paquetes HTTPS/TLS: $https_count"
    
    if [[ $http_count -gt 0 ]]; then
        echo
        echo "--- HOSTS HTTP ---"
        tshark -r "$pcap_file" -Y "http.host" -T fields -e http.host 2>/dev/null | sort | uniq -c | sort -rn
    fi
}

# Búsqueda de DNS
dns_analysis() {
    local pcap_file="$1"
    
    print_section "ANÁLISIS DNS"
    
    local dns_count=$(tshark -r "$pcap_file" -Y "dns" -q 2>/dev/null | wc -l)
    echo "Paquetes DNS: $dns_count"
    
    if [[ $dns_count -gt 0 ]]; then
        echo
        echo "--- CONSULTAS DNS ---"
        tshark -r "$pcap_file" -Y "dns.qry.name" -T fields -e dns.qry.name 2>/dev/null | sort | uniq -c | sort -rn | head -10
    fi
}

# Detección de anomalías
anomaly_detection() {
    local pcap_file="$1"
    
    print_section "DETECCIÓN DE ANOMALÍAS"
    
    # Retransmisiones TCP
    local retrans_count=$(tshark -r "$pcap_file" -Y "tcp.analysis.retransmission" -q 2>/dev/null | wc -l)
    if [[ $retrans_count -gt 0 ]]; then
        print_warning "Retransmisiones TCP detectadas: $retrans_count"
    fi
    
    # Paquetes duplicados
    local dup_ack_count=$(tshark -r "$pcap_file" -Y "tcp.analysis.duplicate_ack" -q 2>/dev/null | wc -l)
    if [[ $dup_ack_count -gt 0 ]]; then
        print_warning "ACKs duplicados detectados: $dup_ack_count"
    fi
    
    # Puertos inusuales
    local unusual_ports=$(tshark -r "$pcap_file" -Y "tcp.dstport > 49152" -T fields -e tcp.dstport 2>/dev/null | sort -u | wc -l)
    echo "Puertos efímeros destino únicos: $unusual_ports"
}

# Generar reporte
generate_report() {
    local pcap_file="$1"
    local report_file="${pcap_file%.*}_analysis_report.txt"
    
    print_section "GENERANDO REPORTE COMPLETO"
    {
        echo "REPORTE DE ANÁLISIS PCAP: $pcap_file"
        echo "Generado: $(date)"
        echo "=========================================="
        echo
        capinfos "$pcap_file"
        echo
        echo "ESTADÍSTICAS DE PROTOCOLOS:"
        tshark -r "$pcap_file" -q -z io,phs
        echo
        echo "CONVERSACIONES TCP:"
        tshark -r "$pcap_file" -q -z conv,tcp
        echo
        echo "CONVERSACIONES UDP:"
        tshark -r "$pcap_file" -q -z conv,udp
    } > "$report_file"
    
    echo "Reporte guardado en: $report_file"
}

# Función principal
main() {
    if [[ $# -eq 0 ]]; then
        echo "Uso: $0 <archivo.pcap>"
        echo "Ejemplo: $0 captura.pcap"
        exit 1
    fi
    
    local pcap_file="$1"
    
    print_header "$pcap_file"
    
    # Verificaciones
    check_dependencies
    check_file "$pcap_file"
    
    # Análisis
    basic_analysis "$pcap_file"
    tcp_analysis "$pcap_file"
    udp_analysis "$pcap_file"
    ip_analysis "$pcap_file"
    port_analysis "$pcap_file"
    http_analysis "$pcap_file"
    dns_analysis "$pcap_file"
    anomaly_detection "$pcap_file"
    
    # Reporte final
    generate_report "$pcap_file"
    
    echo
    print_section "ANÁLISIS COMPLETADO"
    echo "Para análisis avanzado:"
    echo "  tshark -r \"$pcap_file\" -Y \"filtro\" -T fields -e campo"
    echo "  wireshark \"$pcap_file\""
}

# Ejecutar script
main "$@"
