#!/bin/bash

# Creates pods from YAML files in the specified directory or the current directory.
#
# Parameters:
# - yaml_directory: The directory containing the YAML files. Defaults to the current directory if not provided.
#
# Returns:
# - None
create_pods() {
    local yaml_directory=${1:-.}
    for yaml_file in "$yaml_directory"/*.yaml; do
        if [ -f "$yaml_file" ]; then
            echo "Creating directories for pods..."
            echo "Creating directories from $yaml_file"
            create_directories_from_yaml "$yaml_file"
            echo "Creating pods for podman..."
            echo "Creating pod from $yaml_file"
            podman play kube --network host "$yaml_file"
        fi
    done
}

# Creates directories specified in a YAML file.
#
# Parameters:
# - yaml_file: The path to the YAML file.
#
# Returns:
# - None
create_directories_from_yaml() {
    local yaml_file=$1
    local paths=$(grep -E 'hostPath:\s*path:\s*' "$yaml_file" | awk '{print $3}' | sed 's/^"//' | sed 's/"$//')
    for path in $paths; do
        if [ ! -d "$path" ]; then
            mkdir -p "$path"
            echo "Created directory: $path"
        fi
    done
}

# Updates the paths in YAML files.
#
# This function prompts the user to enter the directory containing the YAML files,
# the path to search for, and the path to replace with. It then iterates over all
# YAML files in the specified directory, uses sed to replace the search path with the
# replace path, and prints a message for each updated file. Finally, it prints a message
# indicating that all files have been updated.
#
# Parameters:
# - None
#
# Returns:
# - None
update_paths() {
    # Verzeichnis, in dem die .yaml Dateien gespeichert sind
    read -p "Please enter the directory containing the YAML files: " yaml_directory

    # Suchpath
    read -p "Please enter the path to search for: " search_path

    # Ersetzungs-path
    read -p "Please enter the path to replace with: " replace_path

    # Durchlaufe alle .yaml Dateien im angegebenen Verzeichnis
    for file in "$yaml_directory"/*.yaml; do
        if [[ -f "$file" ]]; then
            # Verwende sed, um den Pfad zu ändern
            sed -i "s|$search_path|$replace_path|g" "$file"
            echo "Updated $file"
        fi
    done

    echo "All files updated."
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
    echo "1. Update paths in YAML files"
    echo "2. Create directories from YAML files"
    echo "3. Create pods and its directories from YAML files"
    echo "4. Exit"
    read -p "Enter your choices: " choices

    IFS=',' read -ra choice_array <<<"$choices"

    for choice in "${choice_array[@]}"; do
        case $choice in
        1) update_paths ;;
        2) create_all_directories ;;
        3) create_pods ;;
        4) exit 0 ;;
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
