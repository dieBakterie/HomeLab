#!/bin/bash

# Verzeichnis, in dem die .yaml Dateien gespeichert sind
directory="/home/pi/podman_pods/"

# Durchlaufe alle .yaml Dateien im angegebenen Verzeichnis
for file in "$directory"/*.yaml; do
  if [[ -f "$file" ]]; then
    # Verwende sed, um den Pfad zu ändern
    sed -i 's|~|/home/pi|g' "$file"
    echo "Updated $file"
  fi
done

echo "All files updated."
