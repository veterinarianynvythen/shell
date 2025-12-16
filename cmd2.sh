#!/bin/sh

echo "========================================="
echo "===            SYSTEM INFO            ==="
echo "========================================="
echo "[*] whoami & id:"
/usr/bin/whoami
/usr/bin/id
echo "\n[*] Hostname:"
/bin/hostname
echo "\n[*] Linux Version:"
/bin/uname -a
echo "\n[*] Filesystem Root:"
/bin/ls -la /
echo ""

echo "========================================="
echo "===       CONTAINER ESCAPE CHECKS     ==="
echo "========================================="
echo "[*] 1. Checking for Docker environment:"
if [ -f /.dockerenv ]; then
  echo "    -> /.dockerenv FOUND. We are in Docker."
else
  echo "    -> /.dockerenv NOT FOUND."
fi
echo "\n[*] 2. Checking cgroups:"
/bin/cat /proc/1/cgroup
echo "\n[*] 3. Searching for docker.sock:"
/usr/bin/find / -name "docker.sock" -ls 2>/dev/null
echo "\n[*] 4. Checking capabilities:"
echo "    -> SKIPPED (getpcaps command not found)."
echo "\n[*] 5. Checking mounts:"
/bin/mount
echo ""

echo "========================================="
echo "===         NETWORK & SECRETS         ==="
echo "========================================="
echo "[*] 1. Network interfaces:"
echo "    -> SKIPPED (ip command not found)."
echo "\n[*] 2. Routing table:"
echo "    -> SKIPPED (ip command not found)."
echo "\n[*] 3. DNS config:"
/bin/cat /etc/hosts
/bin/cat /etc/resolv.conf
echo "\n[*] 4. Active connections:"
echo "    -> SKIPPED (ss command not found)."
echo "\n[*] 5. Environment Variables:"
/usr/bin/env | /usr/bin/sort
echo "\n[*] 6. Searching for common config files in /app:"
/usr/bin/find /app -name "*config*" -o -name ".env*" 2>/dev/null
