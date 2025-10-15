#!/bin/bash
# This script checks for the presence of required dependencies for a project.
# It verifies if specific commands are available in the system's PATH.
# If any dependencies are missing, it lists them and exits with a non-zero status.
# Usage: ./deps-check.sh
# Make sure to give execute permission: chmod +x deps-check.sh
# Dependencies to check
DEPENDENCIES=("devbox")
MISSING_DEPS=()
EXISTING_DEPS=()
DEVBOX_VERSION_REQUIRED="0.16.0"
DEVBOX_VERSION_INSTALLED=$(devbox version | awk '{print $1}')

# Check each dependency
# Iterate over the list of dependencies
# Check if each dependency is available in the system's PATH

for DEP in "${DEPENDENCIES[@]}"; do
    if ! command -v "$DEP" &> /dev/null; then
        MISSING_DEPS+=("$DEP")
    else
        EXISTING_DEPS+=("$DEP")
    fi
done

for DEP in "${EXISTING_DEPS[@]}"; do
    echo "✅ Found dependency: $DEP"
done

for DEP in "${MISSING_DEPS[@]}"; do
    echo "🛑 Missing dependency: $DEP"
    if [ "$DEP" == "devbox" ]; then
        echo "   Please install Devbox version $DEVBOX_VERSION_REQUIRED or higher."
        echo "   Visit https://www.jetify.com/docs/devbox/installing-devbox for installation instructions."
    fi
done
# If a dependency is missing, add it to the MISSING_DEPS array
# After checking all dependencies, if any are missing, print them and exit with status 1
