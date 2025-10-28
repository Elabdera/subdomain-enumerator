#!/bin/bash

#####################################################################
# Subdomain Enumerator - Herramienta de Enumeración de Subdominios
# Autor: Manuel Sánchez Gutiérrez
# Fecha: Octubre 2024
# Descripción: Script para enumerar subdominios usando fuerza bruta DNS
# Uso: ./subdomain_enum.sh -d ejemplo.com -w wordlist.txt
# USO EDUCATIVO Y ÉTICO ÚNICAMENTE
#####################################################################

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
print_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║      SUBDOMAIN ENUMERATOR - Descubrimiento de Subdominios ║"
    echo "║                   Uso Ético Únicamente                    ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Función para crear wordlist por defecto
create_default_wordlist() {
    cat > "$1" << 'EOF'
www
mail
ftp
smtp
pop
imap
webmail
admin
administrator
blog
dev
development
test
testing
staging
api
app
mobile
m
secure
vpn
remote
cloud
portal
dashboard
cpanel
whm
ns1
ns2
dns
dns1
dns2
mx
mx1
mx2
shop
store
ecommerce
forum
support
help
docs
documentation
wiki
cdn
static
assets
media
images
img
files
download
uploads
backup
old
new
beta
alpha
demo
sandbox
EOF
}

# Función para verificar subdominio
check_subdomain() {
    local subdomain=$1
    local domain=$2
    local full_domain="${subdomain}.${domain}"
    
    # Intentar resolver el subdominio
    ip=$(host -W 2 "$full_domain" 2>/dev/null | grep "has address" | awk '{print $4}' | head -n1)
    
    if [ -n "$ip" ]; then
        echo -e "${GREEN}[+] $full_domain -> $ip${NC}"
        echo "$full_domain,$ip" >> "$output_file"
        ((found_subdomains++))
        
        # Intentar obtener información adicional (CNAME)
        cname=$(host -W 2 "$full_domain" 2>/dev/null | grep "is an alias" | awk '{print $6}')
        if [ -n "$cname" ]; then
            echo -e "${BLUE}    └─ CNAME: $cname${NC}"
        fi
    fi
}

# Función de ayuda
show_help() {
    echo "Uso: $0 [OPCIONES]"
    echo ""
    echo "Opciones:"
    echo "  -d, --domain DOMINIO   Dominio objetivo (obligatorio)"
    echo "  -w, --wordlist ARCHIVO Archivo wordlist (opcional, usa uno por defecto)"
    echo "  -o, --output ARCHIVO   Guardar resultados en archivo"
    echo "  -t, --threads NUM      Número de procesos concurrentes (default: 20)"
    echo "  -h, --help             Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -d ejemplo.com"
    echo "  $0 -d ejemplo.com -w subdominios.txt -o resultados.csv"
    exit 0
}

# Verificar dependencias
check_dependencies() {
    if ! command -v host &> /dev/null; then
        echo -e "${RED}[!] Error: 'host' no está instalado${NC}"
        echo -e "${YELLOW}[*] Instala con: sudo apt-get install dnsutils${NC}"
        exit 1
    fi
}

# Verificar argumentos
if [ $# -eq 0 ]; then
    show_help
fi

# Variables por defecto
domain=""
wordlist=""
output_file=""
threads=20
temp_wordlist="/tmp/subdomain_wordlist_$$.txt"

# Procesar argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--domain)
            domain="$2"
            shift 2
            ;;
        -w|--wordlist)
            wordlist="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -t|--threads)
            threads="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo -e "${RED}[!] Opción desconocida: $1${NC}"
            show_help
            ;;
    esac
done

# Validar dominio
if [ -z "$domain" ]; then
    echo -e "${RED}[!] Error: Debe especificar un dominio con -d${NC}"
    exit 1
fi

# Verificar dependencias
check_dependencies

# Imprimir banner
print_banner

# Preparar wordlist
if [ -z "$wordlist" ]; then
    echo -e "${YELLOW}[!] No se especificó wordlist, usando uno por defecto${NC}"
    create_default_wordlist "$temp_wordlist"
    wordlist="$temp_wordlist"
elif [ ! -f "$wordlist" ]; then
    echo -e "${RED}[!] Error: Archivo wordlist no encontrado: $wordlist${NC}"
    exit 1
fi

# Contar palabras en wordlist
word_count=$(wc -l < "$wordlist")

# Preparar archivo de salida
if [ -n "$output_file" ]; then
    echo "Subdominio,IP" > "$output_file"
fi

# Información del escaneo
echo -e "${CYAN}[*] Dominio objetivo: $domain${NC}"
echo -e "${CYAN}[*] Wordlist: $wordlist ($word_count palabras)${NC}"
echo -e "${CYAN}[*] Procesos concurrentes: $threads${NC}"
echo -e "${CYAN}[*] Inicio: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
echo "============================================================"

# Verificar que el dominio principal existe
echo -e "${BLUE}[*] Verificando dominio principal...${NC}"
if ! host -W 2 "$domain" &>/dev/null; then
    echo -e "${RED}[!] Error: No se pudo resolver el dominio $domain${NC}"
    exit 1
fi
echo -e "${GREEN}[+] Dominio principal verificado${NC}\n"

# Variables de estadísticas
found_subdomains=0
start_time=$(date +%s)

# Enumerar subdominios
echo -e "${BLUE}[*] Enumerando subdominios...${NC}\n"

while IFS= read -r subdomain; do
    # Saltar líneas vacías o comentarios
    [[ -z "$subdomain" || "$subdomain" =~ ^# ]] && continue
    
    check_subdomain "$subdomain" "$domain" &
    
    # Limitar procesos concurrentes
    if [ $(jobs -r | wc -l) -ge $threads ]; then
        wait -n
    fi
done < "$wordlist"

# Esperar a que terminen todos los procesos
wait

# Limpiar wordlist temporal
if [ -f "$temp_wordlist" ]; then
    rm -f "$temp_wordlist"
fi

# Calcular tiempo transcurrido
end_time=$(date +%s)
elapsed=$((end_time - start_time))

# Resumen
echo ""
echo "============================================================"
echo -e "${GREEN}[*] Enumeración completada en $elapsed segundos${NC}"
echo -e "${GREEN}[*] Subdominios encontrados: $found_subdomains/$word_count${NC}"

if [ -n "$output_file" ]; then
    echo -e "${BLUE}[*] Resultados guardados en: $output_file${NC}"
fi

echo ""
echo -e "${YELLOW}[!] Disclaimer: Esta herramienta es solo para uso educativo y ético.${NC}"
echo -e "${YELLOW}[!] Obtén autorización antes de enumerar cualquier dominio.${NC}"
echo ""
