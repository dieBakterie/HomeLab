#!/bin/bash

# Verzeichnis, in dem die .yaml Dateien gespeichert sind
directory="/home/pi/homelab/podman/pods/"

# Durchlaufe alle .yaml Dateien im angegebenen Verzeichnis
for file in "$directory"/*.yaml; do
  if [[ -f "$file" ]]; then
    # Verwende sed, um den Pfad zu ändern
    sed -i 's|PATH|NewPath|g' "$file"
    echo "Updated $file"
  fi
done

echo "All files updated."
