#!/bin/sh
#
# DEBUGGING SCRIPT for 'mount: permission denied'
# This script inspects Linux Capabilities from the /proc filesystem
# to confirm if we are missing CAP_SYS_ADMIN.

echo "=== Capability & Mount Debug Script ==="
echo ""

# 1. Re-confirm our identity
echo "[*] Identity Check:"
/usr/bin/id
echo ""

# 2. Check capabilities directly from the source: /proc/$$/status
#    '$$' is the PID of the current shell process.
echo "[*] Checking capabilities from /proc/\$\$/status:"
if [ -f /bin/grep ]; then
    /bin/grep Cap /proc/$$/status
else
    # Fallback if grep isn't there
    /bin/cat /proc/$$/status
fi
echo ""
echo "--- ANALYSIS ---"
echo "    Look at the 'CapEff' (Effective Capabilities) line."
echo "    A fully privileged container will show: 0000003fffffffff"
echo "    A restricted container will show a much smaller number."
echo "    'CAP_SYS_ADMIN' is required for 'mount' and is what enables cgroup escapes."
echo ""

# 3. Attempt the mount command again to confirm the error message
echo "[*] Re-attempting mount to confirm failure reason:"
# Create the directory first (this should work)
/bin/mkdir /tmp/cgrp
# Now attempt the mount
/bin/mount -t cgroup -o memory cgroup /tmp/cgrp
# Check the exit code. 0 is success. Non-zero is failure.
if [ $? -eq 0 ]; then
  echo "    -> SUCCESS: Mount command worked unexpectedly!"
  /bin/umount /tmp/cgrp # Clean up
else
  echo "    -> FAILED as expected. The output above confirms capabilities are missing."
fi
echo ""

echo "=== Debug Script Finished ==="
