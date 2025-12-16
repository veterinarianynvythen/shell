#!/bin/sh

echo "========================================="
echo "===            SYSTEM INFO            ==="
echo "========================================="
echo "[*] whoami & id:"
whoami
id
echo "\n[*] Hostname:"
hostname
echo "\n[*] Linux Version:"
uname -a
echo "\n[*] Filesystem Root:"
ls -la /
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
cat /proc/1/cgroup
echo "\n[*] 3. Searching for docker.sock:"
# Use `find -ls` to get details like permissions
find / -name "docker.sock" -ls 2>/dev/null
echo "\n[*] 4. Checking capabilities (getpcaps for BusyBox):"
# capsh is probably not present, getpcaps is more common
if command -v getpcaps >/dev/null; then
  getpcaps $$
else
  echo "    -> getpcaps command not found."
fi
echo "\n[*] 5. Checking mounts:"
mount
echo ""

echo "========================================="
echo "===         NETWORK & SECRETS         ==="
echo "========================================="
echo "[*] 1. Network interfaces:"
ip a
echo "\n[*] 2. Routing table:"
ip route
echo "\n[*] 3. DNS config:"
# We know DNS might be limited, but let's check the files anyway
cat /etc/hosts
cat /etc/resolv.conf
echo "\n[*] 4. Active connections (ss, since netstat might be missing):"
ss -tulnp
echo "\n[*] 5. Environment Variables:"
env | sort
echo "\n[*] 6. Searching for common config files in /app:"
find /app -name "*config*" -o -name ".env*" 2>/dev/null
