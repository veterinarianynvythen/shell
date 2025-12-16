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
