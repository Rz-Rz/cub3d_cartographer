#!/bin/bash

input_files=()

for entry in *; do
    if [[ -f "$entry" ]]; then
        input_files+=("\"$entry\"")
    fi
done

# Print the file list
printf '%s\n' "${input_files[@]}"
