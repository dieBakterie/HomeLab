#!/bin/bash

# Downloads the AdGuardHome installation script, and executes the install_adguard.sh script, if the install_adguard.sh script is not found. If the script is found in the current directory, it executes it.
#
# Parameters:
# - None
#
# Returns:
# - None
install_adguard() {
    if ! command -v AdGuardHome &> /dev/null; then
        if [ ! -f "install_adguard.sh" ]; then
            curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
        else
            echo "install_adguard.sh found, executing!"
            sh install_adguard.sh
        fi
    else
        echo "AdGuard Home is already installed"
    fi
}

# Downloads the Jellyfin installation script If it is not found in the current directory.
# If the script is found, it executes it with sudo privileges.
#
# Parameters:
# - None
#
# Returns:
# - None
install_jellyfin() {
    if ! command -v jellyfin &> /dev/null; then
        if [ ! -f "install-debuntu.sh" ]; then
            curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash
        else
            echo "install-debuntu.sh found, executing!"
            sudo bash install-debuntu.sh
        fi
    else
        echo "Jellyfin is already installed"
    fi
}

# Downloads the Jellyfin installation script If it is not found in the current directory.
# If the script is found, it executes it with sudo privileges.
#
# Parameters:
# - None
#
# Returns:
# - None
install_coolify() {
    if ! command -v coolify &> /dev/null; then
        if [ ! -f "install.sh" ]; then
            curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
        else
            echo "install.sh found, executing!"
            bash install-debuntu.sh
        fi
    else
        echo "Coolify is already installed"
    fi
}

setup_podman() {
    if [ ! -f "podman_setup.sh" ]; then
        curl -s https://raw.githubusercontent.com/Bakaterie/homeLab/main/homelab/Skripte/podman_setup.sh | bash
    else
        echo "podman_setup.sh found, executing!"
        bash podman_setup.sh
}

# Docker
setup_docker() {
    if [ ! -f "docker_setup.sh" ]; then
        curl -s https://raw.githubusercontent.com/Bakaterie/homeLab/main/homelab/Skripte/docker_setup.sh | bash
    else
        echo "docker_setup.sh found, executing with sudo privileges!"
        bash docker_setup.sh
    fi
}

# This function presents a main menu to the user with various options.
# The user is prompted to enter their choices, which are then processed.
# Parameters:
# - None
#
# Returns:
# - None
main_menu() {
    echo "Select options (e.g., 1,2,4):"
    echo "1. Install AdguardHome standalone"
    echo "2. Install Jellyfin Server standalone"
    echo "3. Install Coolify standalone"
    echo "4. Setup Podman"
    echo "5. Setup Docker"
    echo "6. Exit"
    read -p "Enter your choices: " choices

    IFS=',' read -ra choice_array <<<"$choices"

    for choice in "${choice_array[@]}"; do
        case $choice in
        1) install_adguard ;;
        2) install_jellyfin ;;
        3) install_coolify ;;
        4) setup_podman ;;
        5) setup_docker ;;
        6) exit 0 ;;
        *) echo "Invalid choice: $choice" ;;
        esac
    done
}

# This function calls the main menu function.
# Parameters:
# - None
#
# Returns:
# - None
main_menu