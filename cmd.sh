#!/bin/sh
# This script uses absolute paths for commands (/bin/..., /usr/bin/...)
# because the execution environment likely has a broken or empty $PATH.

echo "========================================="
echo "===            SYSTEM INFO            ==="
echo "========================================="
echo "[*] whoami & id:"
# These are often shell built-ins, but using paths is safer.
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
echo "\n[*] 4. Checking capabilities (getpcaps for BusyBox):"
# The path for getpcaps might be in /sbin
if /sbin/getpcaps $$ &>/dev/null; then
  /sbin/getpcaps $$
else
  echo "    -> getpcaps command not found or not in /sbin."
fi
echo "\n[*] 5. Checking mounts:"
/bin/mount
echo ""

echo "========================================="
echo "===         NETWORK & SECRETS         ==="
echo "========================================="
echo "[*] 1. Network interfaces:"
/bin/ip a
echo "\n[*] 2. Routing table:"
/bin/ip route
echo "\n[*] 3. DNS config:"
/bin/cat /etc/hosts
/bin/cat /etc/resolv.conf
echo "\n[*] 4. Active connections (ss, since netstat might be missing):"
/usr/bin/ss -tulnp 2>/dev/null || echo "ss command not found"
echo "\n[*] 5. Environment Variables:"
/usr/bin/env | /usr/bin/sort
echo "\n[*] 6. Searching for common config files in /app:"
/usr/bin/find /app -name "*config*" -o -name ".env*" 2>/dev/null
