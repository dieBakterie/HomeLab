#!/bin/bash

# Creates Docker containers from YAML files in the specified directory or the current directory.
#
# Parameters:
# - yaml_directory: The directory containing the YAML files. Defaults to the current directory if not provided.
#
# Returns:
# - None
create_docker_containers() {
    local yaml_directory=${1:-.}
    for yaml_file in "$yaml_directory"/*.y*ml; do
        if [ -f "$yaml_file" ]; then
            echo "Creating containers for docker..."
            echo "Creating container from $yaml_file"
            docker-compose -f "$yaml_file" up -d
            # Copy directories and files from current directory to locations defined in the file
            config_files=$(grep -oP 'command:\s+--config\.file=\K[^"]+' "$yaml_file" | tr -d '\r')
            for config_file in $config_files; do
                config_dir=$(dirname "$config_file")
                if [ ! -d "$config_dir" ]; then
                    mkdir -p "$config_dir"
                fi
                cp -r ./"$(basename "$config_dir")" "$config_dir"
                cp ./* "$config_dir"
            done
        fi
    done
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
    # echo "1. Update paths in YAML files"
    # echo "2. Create directories from YAML files"
    echo "3. Create containers from YAML files"
    echo "4. Exit"
    read -p "Enter your choices: " choices

    IFS=',' read -ra choice_array <<<"$choices"

    for choice in "${choice_array[@]}"; do
        case $choice in
        # 1) update_paths ;;
        # 2) create_all_directories ;;
        3) create_docker_containers ;;
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
