#!/bin/bash
# Mauricio Pasten (mavor)
# mauricio.pasten.martinez@gmail.com
PATCH_DIR="patches/"
FAILED_PATCHES=()  

for patch in $PATCH_DIR/*.diff; do
    echo "Applying patch: $patch"
    patch -i "$patch"
    
    if [ $? -ne 0 ]; then  
        echo "Error applying patch: $patch"
        FAILED_PATCHES+=("$patch")  
    fi
done

if [ ${#FAILED_PATCHES[@]} -ne 0 ]; then
    echo -e "\n\033[31mThe following patches failed:\033[0m"
    for failed in "${FAILED_PATCHES[@]}"; do
        echo -e "\033[31m$failed\033[0m"  
    done
else
    echo "All patches applied successfully!"
fi
