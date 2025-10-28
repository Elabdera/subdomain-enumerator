# Subdomain Enumerator - DNS Subdomain Discovery Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

**Autor**: Manuel Sánchez Gutiérrez  
**Fecha**: Octubre 2024  
**Propósito**: Herramienta educativa de OSINT para enumeración de subdominios

---

## 📋 Descripción

**Subdomain Enumerator** es una herramienta de línea de comandos escrita en Bash para descubrir subdominios de un dominio objetivo mediante fuerza bruta DNS. Desarrollada como parte de mi formación en **Administración de Sistemas Informáticos en Red (ASIR)** y mi especialización en **ciberseguridad**.

Esta herramienta es esencial en la fase de reconocimiento (OSINT) de un pentesting, permitiendo mapear la superficie de ataque de una organización.

---

## ✨ Características

- ✅ **Enumeración por fuerza bruta DNS** usando el comando `host`
- ✅ **Wordlist personalizable** o wordlist por defecto incluido
- ✅ **Detección de registros CNAME** (alias de dominio)
- ✅ **Resolución de IPs** para cada subdominio encontrado
- ✅ **Procesamiento concurrente** (hasta 20 hilos simultáneos)
- ✅ **Exportación de resultados** a formato CSV
- ✅ **Interfaz colorida** para mejor visualización
- ✅ **Validación de dominio** antes de iniciar el escaneo
- ✅ **Wordlist por defecto** con 50+ subdominios comunes

---

## 🚀 Instalación

### Requisitos

- Sistema operativo: Linux (Ubuntu, Debian, Kali Linux, etc.)
- Bash 4.0 o superior
- Paquete `dnsutils` (comando `host`)

### Pasos

1. Clonar el repositorio:
```bash
git clone https://github.com/tuusuario/subdomain-enumerator.git
cd subdomain-enumerator
```

2. Instalar dependencias:
```bash
sudo apt-get update
sudo apt-get install dnsutils
```

3. Dar permisos de ejecución:
```bash
chmod +x subdomain_enum.sh
```

4. ¡Listo para usar!

---

## 💻 Uso

### Sintaxis Básica

```bash
./subdomain_enum.sh -d <dominio>
```

### Opciones

| Opción | Descripción | Ejemplo |
|--------|-------------|---------|
| `-d, --domain DOMINIO` | Dominio objetivo (obligatorio) | `-d ejemplo.com` |
| `-w, --wordlist ARCHIVO` | Archivo wordlist personalizado | `-w subdominios.txt` |
| `-o, --output ARCHIVO` | Guardar resultados en CSV | `-o resultados.csv` |
| `-t, --threads NUM` | Número de hilos (default: 20) | `-t 50` |
| `-h, --help` | Mostrar ayuda | `-h` |

### Ejemplos de Uso

**Enumeración básica con wordlist por defecto:**
```bash
./subdomain_enum.sh -d ejemplo.com
```

**Enumeración con wordlist personalizado:**
```bash
./subdomain_enum.sh -d ejemplo.com -w mi_wordlist.txt
```

**Enumeración y guardar resultados:**
```bash
./subdomain_enum.sh -d ejemplo.com -o subdominios_encontrados.csv
```

**Enumeración rápida con más hilos:**
```bash
./subdomain_enum.sh -d ejemplo.com -t 50 -o resultados.csv
```

---

## 📊 Salida de Ejemplo

```
╔═══════════════════════════════════════════════════════════╗
║      SUBDOMAIN ENUMERATOR - Descubrimiento de Subdominios ║
║                   Uso Ético Únicamente                    ║
╚═══════════════════════════════════════════════════════════╝

[!] No se especificó wordlist, usando uno por defecto
[*] Dominio objetivo: ejemplo.com
[*] Wordlist: /tmp/subdomain_wordlist_12345.txt (52 palabras)
[*] Procesos concurrentes: 20
[*] Inicio: 2024-10-28 15:45:30
============================================================
[*] Verificando dominio principal...
[+] Dominio principal verificado

[*] Enumerando subdominios...

[+] www.ejemplo.com -> 93.184.216.34
[+] mail.ejemplo.com -> 93.184.216.35
    └─ CNAME: mail.hosting.ejemplo.net.
[+] ftp.ejemplo.com -> 93.184.216.36
[+] blog.ejemplo.com -> 93.184.216.37
[+] api.ejemplo.com -> 93.184.216.38
[+] dev.ejemplo.com -> 93.184.216.39

============================================================
[*] Enumeración completada en 8.45 segundos
[*] Subdominios encontrados: 6/52
[*] Resultados guardados en: subdominios_encontrados.csv

[!] Disclaimer: Esta herramienta es solo para uso educativo y ético.
[!] Obtén autorización antes de enumerar cualquier dominio.
```

---

## 🔧 Funcionamiento Técnico

### Método de Enumeración

El script utiliza el comando `host` para realizar consultas DNS:

```bash
host -W 2 "$full_domain" 2>/dev/null | grep "has address"
```

- `-W 2`: Timeout de 2 segundos por consulta
- `grep "has address"`: Filtra solo registros A (IPv4)

### Wordlist Por Defecto

Si no se especifica un wordlist, el script genera uno automáticamente con subdominios comunes:

```
www, mail, ftp, smtp, pop, imap, webmail, admin, blog, dev, test,
staging, api, app, mobile, secure, vpn, remote, cloud, portal,
dashboard, cpanel, ns1, ns2, dns, mx, shop, store, forum, support,
help, docs, wiki, cdn, static, assets, media, files, backup, ...
```

### Procesamiento Concurrente

Para acelerar la enumeración, el script ejecuta múltiples consultas DNS en paralelo:

```bash
check_subdomain "$subdomain" "$domain" &

if [ $(jobs -r | wc -l) -ge $threads ]; then
    wait -n
fi
```

---

## 📚 Casos de Uso

### 1. Reconocimiento en Pentesting (OSINT)

Mapear la superficie de ataque de un dominio objetivo:

```bash
./subdomain_enum.sh -d target.com -w /usr/share/wordlists/subdomains.txt -o recon.csv
```

### 2. Auditoría de Seguridad Corporativa

Identificar subdominios olvidados o no documentados en tu propia organización:

```bash
./subdomain_enum.sh -d miempresa.com -o auditoria_subdominios.csv
```

### 3. Bug Bounty

Descubrir subdominios no listados en el alcance de un programa de bug bounty:

```bash
./subdomain_enum.sh -d bugbounty-target.com -w wordlist_grande.txt
```

### 4. Investigación de Infraestructura

Analizar la infraestructura de una organización:

```bash
./subdomain_enum.sh -d universidad.edu -o infraestructura.csv
```

---

## ⚠️ Disclaimer Legal

**IMPORTANTE**: Esta herramienta es exclusivamente para fines educativos y de pentesting ético.

- ✅ **Permitido**: Usar en tus propios dominios, dominios con permiso explícito, plataformas de bug bounty autorizadas
- ❌ **Prohibido**: Enumerar dominios de terceros sin autorización

La enumeración de subdominios puede ser considerada reconocimiento hostil en algunas jurisdicciones. El autor **NO se hace responsable** del uso indebido de esta herramienta.

**Siempre obtén autorización por escrito antes de enumerar dominios que no sean de tu propiedad.**

---

## 🎓 Contexto Educativo

Este proyecto fue desarrollado como parte de mi formación en:

- **Grado Superior en Administración de Sistemas Informáticos en Red (ASIR)** - UNIR
- **Certificación eJPT v2** (Junior Penetration Tester) - INE Security
- **Formación en Pentesting Ético** - Hack4u

### Conocimientos Demostrados

- ✅ Scripting avanzado en Bash
- ✅ Comprensión del sistema DNS
- ✅ Técnicas de OSINT (Open Source Intelligence)
- ✅ Reconocimiento pasivo y activo
- ✅ Procesamiento concurrente en shell
- ✅ Metodologías de pentesting

---

## 🔄 Comparación con Otras Herramientas

| Característica | Subdomain Enum (Bash) | Sublist3r | Amass |
|----------------|----------------------|-----------|-------|
| Método | Fuerza bruta DNS | Múltiples fuentes | Múltiples técnicas |
| Velocidad | Media | Rápida | Muy completa |
| Fuentes | Solo DNS | OSINT + DNS | OSINT + DNS + Scraping |
| Dependencias | dnsutils | Python + libs | Go |
| Tamaño | ~7 KB | ~500 KB | ~50 MB |
| Propósito | Educativo | Profesional | Profesional avanzado |

**¿Cuándo usar este script?**
- Aprendizaje de conceptos de enumeración DNS
- Entornos con recursos limitados
- Scripts personalizados de automatización
- Cuando solo necesitas fuerza bruta DNS simple

---

## 🛠️ Mejoras Futuras

- [ ] Soporte para registros AAAA (IPv6)
- [ ] Integración con APIs de OSINT (VirusTotal, SecurityTrails)
- [ ] Detección de subdominios con wildcard DNS
- [ ] Exportación a formatos JSON y XML
- [ ] Verificación de certificados SSL/TLS (Certificate Transparency)
- [ ] Modo recursivo (enumerar subdominios de subdominios)
- [ ] Integración con herramientas de escaneo de puertos

---

## 📖 Recursos de Aprendizaje

Si quieres aprender más sobre enumeración de subdominios y OSINT:

- **Herramientas profesionales**: Sublist3r, Amass, Subfinder, Assetfinder
- **Plataformas de práctica**: HackTheBox, TryHackMe, PentesterLab
- **Wordlists**: SecLists (GitHub), DNSRecon wordlists
- **Libros**: "OSINT Techniques" de Michael Bazzell
- **Cursos**: Hack4u, TCM Security, Offensive Security

---

## 📝 Crear tu Propio Wordlist

Para crear un wordlist personalizado, crea un archivo de texto con un subdominio por línea:

```bash
cat > mi_wordlist.txt << EOF
www
mail
admin
test
dev
staging
api
EOF
```

Luego úsalo:
```bash
./subdomain_enum.sh -d ejemplo.com -w mi_wordlist.txt
```

---

## 🔍 Técnicas Complementarias

La enumeración de subdominios es solo una parte del reconocimiento. Combínala con:

1. **Google Dorking**: `site:ejemplo.com`
2. **Certificate Transparency**: crt.sh, censys.io
3. **Reverse DNS**: Enumerar rangos de IPs
4. **Web scraping**: Buscar enlaces en páginas públicas
5. **APIs públicas**: VirusTotal, SecurityTrails, Shodan

---

## 📧 Contacto

**Manuel Sánchez Gutiérrez**  
- Email: manoloadra2@gmail.com  
- LinkedIn: [linkedin.com/in/manuel-sanchez-gutierrez](https://www.linkedin.com/in/manuel-sánchez-gutiérrez-b534ab336/)  
- GitHub: [github.com/tuusuario](https://github.com/tuusuario)

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 🌟 Agradecimientos

- A la comunidad de OSINT por compartir conocimientos
- A los creadores de Sublist3r y Amass por inspirar esta herramienta
- A Hack4u por la formación en pentesting ético

---

**Recuerda**: La información es poder, pero la ética es responsabilidad. Usa esta herramienta de forma legal y responsable.

*"Information gathering is the foundation of a successful pentest."*
