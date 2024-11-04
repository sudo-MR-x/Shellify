#!/bin/bash
# requirements.sh - Install required packages for running the script

# Define color variables
RESET="\033[0m"
GREEN="\033[1;32m"
RED="\033[1;31m"

echo -e "${GREEN}Installing required packages...${RESET}"

# Install net-tools for ifconfig
if pkg install -y net-tools; then
    echo -e "${GREEN}net-tools installed successfully.${RESET}"
else
    echo -e "${RED}Failed to install net-tools.${RESET}"
fi

# Install GNU bc
if pkg install -y bc; then
    echo -e "${GREEN}bc installed successfully.${RESET}"
else
    echo -e "${RED}Failed to install bc.${RESET}"
fi

# Optional: Install SVN
if pkg install -y subversion; then
    echo -e "${GREEN}SVN installed successfully.${RESET}"
else
    echo -e "${RED}Failed to install SVN.${RESET}"
fi

echo -e "${GREEN}Requirements check complete.${RESET}"
sleep 1
clear
