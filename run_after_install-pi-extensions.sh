#!/bin/bash
# Install npm dependencies for any pi extension that has a package.json.
# No-op if no extensions have dependencies yet.

for dir in ~/.pi/agent/extensions/*/; do
    if [ -f "$dir/package.json" ]; then
        echo "Installing dependencies for pi extension: $(basename "$dir")"
        (cd "$dir" && npm install --no-audit --no-fund --silent)
    fi
done
