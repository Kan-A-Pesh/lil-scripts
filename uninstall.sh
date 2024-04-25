#!/bin/sh
set -e
BASEDIR=$(dirname "$0")

# Prompt function
prompt() {
    while true; do
        read -p "[y/n]: " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check if lil-scripts is already installed
if ! command -v lil-help >/dev/null 2>&1
then
    echo "\033[92mINFO: lil-scripts is not installed\033[0m"
    exit 1
fi

# Ask for confirmation
echo "\033[93mWARN: Do you want to uninstall lil-scripts?\033[0m"
if ! prompt
then
    echo "\033[93mWARN: Uninstallation cancelled\033[0m"
    exit 1
fi

# Remove lil-scripts from PATH
sed -i '/lil-scripts/d' ~/.bashrc
echo "\033[92mINFO: lil-scripts has been removed from the PATH\033[0m"

# Remove lil-scripts from the system
rm -rf $BASEDIR

echo "\033[92mINFO: Uninstallation complete\033[0m"
echo "\033[37mINFO: You may need to restart your terminal for changes to take effect\033[0m"
