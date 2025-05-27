





# Wayback URL Scanner for Subdomains

This script is a lightweight reconnaissance tool designed for security researchers and bug bounty hunters. It automates the discovery of subdomains using `subfinder`, fetches archived URLs from the Wayback Machine using `waybackpy`, and tests which URLs are currently live using `curl`.

---

## 🚀 Features

- 🧠 **Subdomain Enumeration** using [subfinder](https://github.com/projectdiscovery/subfinder)
- 🕰️ **Historical URL Extraction** from the Wayback Machine via [waybackpy](https://github.com/akamhy/waybackpy)
- 🌐 **Live URL Checking** using customizable `curl` requests
- 🐌 **Delay Control** between HTTP requests to avoid rate-limiting
- 🧾 **Custom Output** and User-Agent headers
- 🔧 **Simple CLI Interface** with flags for customization

---

## 🛠️ Requirements

- `subfinder`
- `waybackpy`
- `curl`
- `bash`

Ensure these tools are installed and available in your `PATH`.

---

## 📦 Installation

Clone this repository:

```bash
git clone https://github.com/basilbenaziz/Wayback-URL-Scanner-for-Subdomains.git
cd wayback-url-scanner
chmod +x scanner.sh
