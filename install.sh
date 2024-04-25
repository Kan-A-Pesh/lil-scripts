#!/bin/sh
set -e
BASEDIR=$(dirname "$0")
cd $BASEDIR
SKIP_INSTALLED=false

# Parse arguments
while [ "$1" != "" ]; do
    case $1 in
        --skip-installed )     SKIP_INSTALLED=true
                                ;;
        * )                     echo "Invalid argument: $1"
                                exit 1
    esac
    shift
done

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
if ! $SKIP_INSTALLED
then

if ! command -v lil-help >/dev/null 2>&1
then
    echo "\033[92mINFO: lil-scripts is not installed\033[0m"
else
    echo "\033[93mWARN: lil-scripts is already installed\033[0m"
    echo "\033[93mWARN: Do you want to reinstall it?\033[0m"

    if prompt
    then
        # Remove lil-scripts from PATH
        sed -i '/lil-scripts/d' ~/.bashrc
        echo "\033[92mINFO: lil-scripts has been removed from the PATH\033[0m"
    else
        echo "\033[93mWARN: lil-scripts will not be reinstalled\033[0m"
        exit 1
    fi
fi

fi

# Check if the user is root
ISROOT=$(id -u)
if [ $ISROOT -ne 0 ]
then
    echo "\033[93mWARN: You are running this script as a non-root user. Some dependencies may not be installed\033[0m"
    echo "\033[93mWARN: Do you want to continue? (Not recommended)\033[0m"

    if ! prompt 
    then
        exit 1
    fi

    echo "\033[94mINFO: Continuing installation as a non-root user\033[0m"
    echo "\033[94mINFO: If you encounter any issues, re-run this script as root\033[0m"
fi

# Install dependencies
if [ $ISROOT -eq 0 ]
then
    apt-get update
fi

# Python
if ! command -v python3 >/dev/null 2>&1
then
    
    echo "\033[93mWARN: Python3 is not installed, do you want to install it?\033[0m"

    if [ $ISROOT -ne 0 ]
    then
        echo "\033[93mWARN: sudo is required to install it\033[0m"
    fi

    if prompt 
    then
        apt-get install python3
        echo "\033[92mINFO: Python3 has been installed\033[0m"
    else
        echo "\033[93mWARN: Some scripts may not work without Python3\033[0m"
        exit 1
    fi
else
    echo "\033[37mINFO: Python3 is already installed, skipping...\033[0m"
fi


# Add the script to the PATH
if ! $SKIP_INSTALLED
then

echo "\033[92mINFO: Do you want lil-scripts to be added to the PATH?\033[0m"
if prompt
then
    # Add lil-scripts to the PATH
    echo "export PATH=\"$(pwd):\$PATH\"" >> ~/.bashrc
    echo "\033[92mINFO: lil-scripts has been added to the PATH\033[0m"
else
    echo "\033[93mWARN: You will need to run the scripts with ./lil-scripts/<script>\033[0m"
fi

echo "\033[92mINFO: Installation complete\033[0m"
echo "\033[37mINFO: You may need to restart your terminal for changes to take effect\033[0m"
echo "\033[37mINFO: You can also run \033[96msource ~/.bashrc\033[0m to apply changes immediately\033[0m"
echo ""
echo "\033[37mINFO: Get started by running \033[96mlil-help\033[0m command to see all available scripts\033[0m"

fi
