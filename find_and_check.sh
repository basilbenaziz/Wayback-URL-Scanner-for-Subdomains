#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -d <domain> [-p <http|https>] [-o <output_file>] [-t <delay>] [-u <user-agent>]"
    echo "  -d: Domain to scan (required)"
    echo "  -p: Protocol (http or https, default: https)"
    echo "  -o: Output file for live URLs (default: live_urls.txt)"
    echo "  -t: Delay in seconds between requests (default: 1)"
    echo "  -u: Custom User-Agent (default: MySecurityScanner/1.0)"
    echo "  --help or -h: Show this help message"
    exit 1
}

# Check for --help or -h before processing other arguments
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    usage
fi

# Parse command-line arguments
while getopts ":d:p:o:t:u:" opt; do
    case "${opt}" in
        d) DOMAIN=${OPTARG} ;;
        p) PROTOCOL=${OPTARG} ;;
        o) OUTPUT_FILE=${OPTARG} ;;
        t) DELAY=${OPTARG} ;;
        u) USER_AGENT=${OPTARG} ;;
        *) usage ;;
    esac
done

# Check if domain is provided
if [ -z "$DOMAIN" ]; then
    usage
fi

# Set defaults
PROTOCOL=${PROTOCOL:-"https"}
OUTPUT_FILE=${OUTPUT_FILE:-"live_urls.txt"}
DELAY=${DELAY:-1}  # Default delay of 1 second
USER_AGENT=${USER_AGENT:-"Mozilla/5.0 (compatible; MySecurityScanner/1.0; +https://yourwebsite.com)"}

echo "[-] subfinder"
subfinder -d "$DOMAIN" -o subdomains.txt &>/dev/null

if [ ! -s "subdomains.txt" ]; then
    echo "[-] No subdomains found."
    exit 1
fi

echo "[-] wayback"
> wayback_urls.txt
while IFS= read -r subdomain; do
    waybackpy --url "$subdomain" --oldest >> wayback_urls.txt 2>/dev/null
    sleep "$DELAY"  # Delay between requests
done < subdomains.txt

if [ ! -s "wayback_urls.txt" ]; then
    echo "[-] No historical URLs found."
    exit 1
fi

echo "[-] status"
> "$OUTPUT_FILE"
while IFS= read -r url; do
    [[ ! "$url" =~ ^http ]] && url="$PROTOCOL://$url"

    status_code=$(curl -A "$USER_AGENT" -o /dev/null -s -w "%{http_code}" "$url")
    
    if [ "$status_code" -eq 200 ]; then
        echo "[+] $url"
        echo "$url" >> "$OUTPUT_FILE"
    fi

    sleep "$DELAY"  # Delay between requests
done < wayback_urls.txt
