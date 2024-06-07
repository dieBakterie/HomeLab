#!/bin/bash

# Downloads the install_adguard.sh script and AdGuardHome installation script, and executes the install_adguard.sh script, if the install_adguard.sh script is not found. If the script is found in the current directory, it executes it.
#
# Parameters:
# - None
#
# Returns:
# - None
install_adguard() {
    if [ ! -f "install_adguard.sh" ]; then
        curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
    else
        echo "install_adguard.sh found, executing!"
        sh install_adguard.sh
    fi
}

# Installs Jellyfin if the "install_jellyfin.sh" script is not found in the current directory.
# If the script is found, it executes it with sudo privileges.
#
# Parameters:
# - None
#
# Returns:
# - None
install_jellyfin() {
    if [ ! -f "install-debuntu.sh" ]; then
        curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash
    else
        echo "install-debuntu.sh found, executing!"
        sudo bash install-debuntu.sh
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