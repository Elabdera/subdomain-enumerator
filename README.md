# Subdomain Enumerator - DNS Subdomain Discovery Tool

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Bash-4.0%2B-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

**Author**: Manuel Sánchez Gutiérrez  
**Date**: October 2024  
**Purpose**: Educational OSINT tool for subdomain enumeration

---

## 📋 Description

**Subdomain Enumerator** is a command-line tool written in Bash to discover subdomains of a target domain through DNS brute-force. Developed as part of my training in **Network Systems Administration (ASIR)** and my specialization in **cybersecurity**.

This tool is essential in the reconnaissance (OSINT) phase of pentesting, allowing you to map an organization's attack surface.

---

## ✨ Features

- ✅ **DNS brute-force enumeration** using the `host` command
- ✅ **Customizable wordlist** or included default wordlist
- ✅ **CNAME record detection** (domain aliases)
- ✅ **IP resolution** for each subdomain found
- ✅ **Concurrent processing** (up to 20 simultaneous threads)
- ✅ **Results export** to CSV format
- ✅ **Colorful interface** for better visualization
- ✅ **Domain validation** before starting the scan
- ✅ **Default wordlist** with 50+ common subdomains

---

## 🚀 Installation

### Requirements

- Operating system: Linux (Ubuntu, Debian, Kali Linux, etc.)
- Bash 4.0 or higher
- `dnsutils` package (`host` command)

### Steps

1. Clone the repository:
```bash
git clone https://github.com/Elabdera/subdomain-enumerator.git
cd subdomain-enumerator
```

2. Install dependencies:
```bash
sudo apt-get update
sudo apt-get install dnsutils
```

3. Grant execution permissions:
```bash
chmod +x subdomain_enum.sh
```

4. Ready to use!

---

## 💻 Usage

### Basic Syntax

```bash
./subdomain_enum.sh -d <domain>
```

### Options

| Option | Description | Example |
|--------|-------------|---------|
| `-d, --domain DOMAIN` | Target domain (required) | `-d example.com` |
| `-w, --wordlist FILE` | Custom wordlist file | `-w subdomains.txt` |
| `-o, --output FILE` | Save results to CSV | `-o results.csv` |
| `-t, --threads NUM` | Number of threads (default: 20) | `-t 50` |
| `-h, --help` | Show help | `-h` |

### Usage Examples

**Basic enumeration with default wordlist:**
```bash
./subdomain_enum.sh -d example.com
```

**Enumeration with custom wordlist:**
```bash
./subdomain_enum.sh -d example.com -w my_wordlist.txt
```

**Enumeration and save results:**
```bash
./subdomain_enum.sh -d example.com -o subdomains_found.csv
```

**Fast enumeration with more threads:**
```bash
./subdomain_enum.sh -d example.com -t 50 -o results.csv
```

---

## 📊 Example Output

```
╔═══════════════════════════════════════════════════════════╗
║      SUBDOMAIN ENUMERATOR - Subdomain Discovery          ║
║                   Ethical Use Only                        ║
╚═══════════════════════════════════════════════════════════╝

[!] No wordlist specified, using default one
[*] Target domain: example.com
[*] Wordlist: /tmp/subdomain_wordlist_12345.txt (52 words)
[*] Concurrent processes: 20
[*] Start: 2024-10-28 15:45:30
============================================================
[*] Verifying main domain...
[+] Main domain verified

[*] Enumerating subdomains...

[+] www.example.com -> 93.184.216.34
[+] mail.example.com -> 93.184.216.35
    └─ CNAME: mail.hosting.example.net.
[+] ftp.example.com -> 93.184.216.36
[+] blog.example.com -> 93.184.216.37
[+] api.example.com -> 93.184.216.38
[+] dev.example.com -> 93.184.216.39

============================================================
[*] Enumeration completed in 8.45 seconds
[*] Subdomains found: 6/52
[*] Results saved to: subdomains_found.csv

[!] Disclaimer: This tool is for educational and ethical use only.
[!] Obtain authorization before enumerating any domain.
```

---

## 🔧 Technical Operation

### Enumeration Method

The script uses the `host` command to perform DNS queries:

```bash
host -W 2 "$full_domain" 2>/dev/null | grep "has address"
```

- `-W 2`: 2-second timeout per query
- `grep "has address"`: Filters only A records (IPv4)

### Default Wordlist

If no wordlist is specified, the script automatically generates one with common subdomains:

```
www, mail, ftp, smtp, pop, imap, webmail, admin, blog, dev, test,
staging, api, app, mobile, secure, vpn, remote, cloud, portal,
dashboard, cpanel, ns1, ns2, dns, mx, shop, store, forum, support,
help, docs, wiki, cdn, static, assets, media, files, backup, ...
```

### Concurrent Processing

To speed up enumeration, the script runs multiple DNS queries in parallel:

```bash
check_subdomain "$subdomain" "$domain" &

if [ $(jobs -r | wc -l) -ge $threads ]; then
    wait -n
fi
```

---

## 📚 Use Cases

### 1. Pentesting Reconnaissance (OSINT)

Map the attack surface of a target domain:

```bash
./subdomain_enum.sh -d target.com -w /usr/share/wordlists/subdomains.txt -o recon.csv
```

### 2. Corporate Security Audit

Identify forgotten or undocumented subdomains in your own organization:

```bash
./subdomain_enum.sh -d mycompany.com -o subdomain_audit.csv
```

### 3. Bug Bounty

Discover subdomains not listed in a bug bounty program's scope:

```bash
./subdomain_enum.sh -d bugbounty-target.com -w large_wordlist.txt
```

### 4. Infrastructure Research

Analyze an organization's infrastructure:

```bash
./subdomain_enum.sh -d university.edu -o infrastructure.csv
```

---

## ⚠️ Legal Disclaimer

**IMPORTANT**: This tool is exclusively for educational purposes and ethical pentesting.

- ✅ **Allowed**: Use on your own domains, domains with explicit permission, authorized bug bounty platforms
- ❌ **Prohibited**: Enumerate third-party domains without authorization

Subdomain enumeration may be considered hostile reconnaissance in some jurisdictions. The author is **NOT responsible** for misuse of this tool.

**Always obtain written authorization before enumerating domains you don't own.**

---

## 🎓 Educational Context

This project was developed as part of my training in:

- **Higher Degree in Network Systems Administration (ASIR)** - UNIR
- **eJPT v2 Certification** (Junior Penetration Tester) - INE Security
- **Ethical Pentesting Training** - Hack4u

### Demonstrated Skills

- ✅ Advanced Bash scripting
- ✅ Understanding of DNS system
- ✅ OSINT techniques (Open Source Intelligence)
- ✅ Passive and active reconnaissance
- ✅ Concurrent processing in shell
- ✅ Pentesting methodologies

---

## 🔄 Comparison with Other Tools

| Feature | Subdomain Enum (Bash) | Sublist3r | Amass |
|---------|----------------------|-----------|-------|
| Method | DNS brute-force | Multiple sources | Multiple techniques |
| Speed | Medium | Fast | Very comprehensive |
| Sources | DNS only | OSINT + DNS | OSINT + DNS + Scraping |
| Dependencies | dnsutils | Python + libs | Go |
| Size | ~7 KB | ~500 KB | ~50 MB |
| Purpose | Educational | Professional | Advanced professional |

**When to use this script?**
- Learning DNS enumeration concepts
- Resource-limited environments
- Custom automation scripts
- When you only need simple DNS brute-force

---

## 🛠️ Future Improvements

- [ ] AAAA record support (IPv6)
- [ ] Integration with OSINT APIs (VirusTotal, SecurityTrails)
- [ ] Wildcard DNS subdomain detection
- [ ] Export to JSON and XML formats
- [ ] SSL/TLS certificate verification (Certificate Transparency)
- [ ] Recursive mode (enumerate subdomains of subdomains)
- [ ] Integration with port scanning tools

---

## 📖 Learning Resources

If you want to learn more about subdomain enumeration and OSINT:

- **Professional tools**: Sublist3r, Amass, Subfinder, Assetfinder
- **Practice platforms**: HackTheBox, TryHackMe, PentesterLab
- **Wordlists**: SecLists (GitHub), DNSRecon wordlists
- **Books**: "OSINT Techniques" by Michael Bazzell
- **Courses**: Hack4u, TCM Security, Offensive Security

---

## 📝 Creating Your Own Wordlist

To create a custom wordlist, create a text file with one subdomain per line:

```bash
cat > my_wordlist.txt << EOF
www
mail
admin
test
dev
staging
api
EOF
```

Then use it:
```bash
./subdomain_enum.sh -d example.com -w my_wordlist.txt
```

---

## 🔍 Complementary Techniques

Subdomain enumeration is just one part of reconnaissance. Combine it with:

1. **Google Dorking**: `site:example.com`
2. **Certificate Transparency**: crt.sh, censys.io
3. **Reverse DNS**: Enumerate IP ranges
4. **Web scraping**: Search for links on public pages
5. **Public APIs**: VirusTotal, SecurityTrails, Shodan

---

## 📧 Contact

**Manuel Sánchez Gutiérrez**  
- Email: manoloadra2@gmail.com  
- LinkedIn: [linkedin.com/in/manuel-sanchez-gutierrez](https://www.linkedin.com/in/manuel-sanchez-gutierrez-b534ab336/)  
- GitHub: [github.com/Elabdera](https://github.com/Elabdera)

---

## 📄 License

This project is under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## 🌟 Acknowledgments

- To the OSINT community for sharing knowledge
- To the creators of Sublist3r and Amass for inspiring this tool
- To Hack4u for ethical pentesting training

---

**Remember**: Information is power, but ethics is responsibility. Use this tool legally and responsibly.

*"Information gathering is the foundation of a successful pentest."*
