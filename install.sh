#!/usr/bin/env bash

# Define colors for output
RED="\033[1;31m"
GREEN="\033[1;32m"
RESET="\033[0m"

echo -e "${GREEN}                                                                    ${RESET}"
echo -e "${GREEN}            __                  __  __  __   ______                 ${RESET}"
echo -e "${GREEN}           /  |                /  |/  |/  | /      \                ${RESET}"
echo -e "${GREEN}   _______ $$ |____    ______  $$ |$$ |$$/ /$$$$$$  | __    __      ${RESET}"
echo -e "${GREEN}  /       |$$      \  /      \ $$ |$$ |/  |$$ |_ $$/ /  |  /  |     ${RESET}"
echo -e "${GREEN} /$$$$$$$/ $$$$$$$  |/$$$$$$  |$$ |$$ |$$ |$$   |    $$ |  $$ |     ${RESET}"
echo -e "${GREEN} $$      \ $$ |  $$ |$$    $$ |$$ |$$ |$$ |$$$$/     $$ |  $$ |     ${RESET}"
echo -e "${GREEN}  $$$$$$  |$$ |  $$ |$$$$$$$$/ $$ |$$ |$$ |$$ |      $$ \__$$ |     ${RESET}"
echo -e "${GREEN} /     $$/ $$ |  $$ |$$       |$$ |$$ |$$ |$$ |      $$    $$ |     ${RESET}"
echo -e "${GREEN} $$$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/ $$/ $$/        $$$$$$$ |     ${RESET}"
echo -e "${GREEN}                                                    /  \__$$ |      ${RESET}"
echo -e "${GREEN}                                                    $$    $$/       ${RESET}"
echo -e "${GREEN}                                                     $$$$$$/        ${RESET}"
echo -e "${GREEN}                                                                    ${RESET}"

# Print contact information
echo -e "${GREEN}Created by: mayank singh${RESET}"
echo -e "${GREEN}GitHub: https://github.com/sudo-MR_x${RESET}"
echo ""
chmod +x *

echo -e "[*] Installing requirements..."
if ./requirements.sh; then
    echo -e "${GREEN}Requirements installed successfully.${RESET}"
else
    echo -e "${RED}Failed to install requirements.${RESET}"
    exit 1
fi

echo -e "[*] Updating bash.bashrc file..."
# Move the custom bash.bashrc to the correct path
if mv .bash/bash.bashrc /data/data/com.termux/files/usr/etc/bash.bashrc; then
    echo -e "${GREEN}bash.bashrc updated successfully.${RESET}"
else
    echo -e "${RED}Failed to update bash.bashrc.${RESET}"
    exit 1
fi
