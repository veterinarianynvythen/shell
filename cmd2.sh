#!/bin/sh
#
# STRATEGY PIVOT: From Container Escape to Application Analysis
# The cgroup escape failed due to missing CAP_SYS_ADMIN.
# We now focus on exploiting secrets and logic found inside the container.

echo "=== Application & Secret Analysis Script ==="

# 1. Remind ourselves of the juicy environment variables.
echo "\n[*] Leaked Environment Variables:"
/usr/bin/env | /bin/grep NEXT_PUBLIC_

# 2. Search the entire application directory for where the TOKEN's NAME is used.
# This will show us the code that calls this specific variable.
echo "\n[*] Searching for where 'NEXT_PUBLIC_TOKEN' is used in the code (excluding node_modules):"
/bin/grep -r "NEXT_PUBLIC_TOKEN" /app 2>/dev/null | /bin/grep -v "node_modules"

# 3. Search for where the TOKEN's VALUE is hardcoded or mentioned.
# Sometimes secrets are copied elsewhere.
echo "\n[*] Searching for where the token's VALUE is hardcoded (excluding node_modules):"
/bin/grep -r "iYOWeBBRiQXcDHMGWehRBKVqAGLeLT2E2q5fJ7tA" /app 2>/dev/null | /bin/grep -v "node_modules"

# 4. Search for other common secret/key patterns to find more secrets.
echo "\n[*] Grepping for other keywords (API_KEY, SECRET, PASSWORD, AWS) (excluding node_modules):"
/bin/grep -r -i -E "API_KEY|SECRET|PASSWORD|AWS" /app 2>/dev/null | /bin/grep -v "node_modules"

# 5. Let's look at the main package file to see dependencies (e.g., aws-sdk, database clients).
echo "\n[*] Contents of package.json:"
/bin/cat /app/package.json 2>/dev/null || echo "package.json not found"

# 6. List the direct contents of the application's root.
echo "\n[*] Listing contents of /app:"
/bin/ls -la /app

echo "\n=== Analysis Finished ==="
