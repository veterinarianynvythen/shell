#!/bin/sh
echo "=== Binary Path Checker Starting ==="

# List of all binaries we want to use, with their assumed paths
BINS_TO_CHECK="/usr/bin/whoami /usr/bin/id /bin/hostname /bin/uname /bin/ls /bin/cat /usr/bin/find /sbin/getpcaps /bin/mount /bin/ip /usr/bin/ss /usr/bin/env /usr/bin/sort"

for bin_path in $BINS_TO_CHECK; do
  # The `test` command ([ -f ... ]) check if a file exists. It's very portable.
  if [ -f "$bin_path" ]; then
    echo "[  OK   ] Found binary at: $bin_path"
  else
    echo "[ FAILED] MISSING binary at: $bin_path"
  fi
done

echo "=== Binary Path Checker Finished ==="
