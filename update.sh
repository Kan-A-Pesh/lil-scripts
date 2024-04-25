#!/bin/sh
set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR

# Check if lil-scripts is already installed
if ! command -v lil-help >/dev/null 2>&1
then
    echo "\033[92mINFO: lil-scripts is not installed\033[0m"
    echo "\033[93mWARN: Install lil-scripts first before updating\033[0m"
    exit 1
fi

git pull
./install.sh --skip-installed

echo "\033[92mINFO: Update complete\033[0m"
