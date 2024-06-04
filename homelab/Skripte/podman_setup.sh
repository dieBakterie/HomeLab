#!/bin/bash

# Funktion zum Erstellen von Verzeichnissen aus einer YAML-Datei
create_directories_from_yaml() {
    yaml_file=$1
    grep -E 'path: ' "$yaml_file" | awk '{print $2}' | while read -r path; do
        if [ ! -d "$path" ]; then
            mkdir -p "$path"
            echo "Created directory: $path"
        else
            echo "Directory already exists: $path"
        fi
    done
}

# Funktion zum Erstellen von Verzeichnissen für alle YAML-Dateien in einem Verzeichnis
create_all_directories() {
    read -p "Please enter the directory containing the YAML files: " yaml_directory
    if [ -d "$yaml_directory" ]; then
        for yaml_file in "$yaml_directory"/*.yaml; do
            if [ -f "$yaml_file" ]; then
                create_directories_from_yaml "$yaml_file"
            else
                echo "No YAML files found in directory: $yaml_directory"
            fi
        done
    else
        echo "Directory does not exist: $yaml_directory"
    fi
}

# Funktion zum Ausführen des Skripts install_adguard.sh
install_adguard() {
    if [ -f "install_adguard.sh" ]; then
        bash install_adguard.sh
    else
        echo "install_adguard.sh not found!"
    fi
}

# Funktion zum Ausführen des Skripts install_jellyfin.sh
install_jellyfin() {
    if [ -f "install_jellyfin.sh" ]; then
        bash install_jellyfin.sh
    else
        echo "install_jellyfin.sh not found!"
    fi
}

# Funktion zum Erstellen der Pods
create_pods() {
    if [ -f "create_pods.sh" ]; then
        bash create_pods.sh
    else
        echo "create_pods.sh not found!"
    fi
}

# Funktion zum Aktualisieren der Pfade in den YAML-Dateien
update_paths() {
    if [ -f "update_paths.sh" ]; then
        bash update_paths.sh
    else
        echo "update_paths.sh not found!"
    fi
}

# Hauptmenü
main_menu() {
    echo "Select options (e.g., 1,2,4):"
    echo "1. Create directories from YAML files"
    echo "2. Install AdGuard Home"
    echo "3. Install Jellyfin"
    echo "4. Create pods"
    echo "5. Update paths in YAML files"
    echo "6. Exit"
    read -p "Enter your choices: " choices

    IFS=',' read -ra choice_array <<< "$choices"

    for choice in "${choice_array[@]}"; do
        case $choice in
            1) create_all_directories ;;
            2) install_adguard ;;
            3) install_jellyfin ;;
            4) create_pods ;;
            5) update_paths ;;
            6) exit 0 ;;
            *) echo "Invalid choice: $choice" ;;
        esac
    done
}

# Skript ausführen
main_menu
