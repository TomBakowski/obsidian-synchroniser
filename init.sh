#!/bin/bash


script_dir=$(dirname "$0")
current_dir=$(cd "$script_dir" && pwd)
echo "Current directory: $current_dir"


if uname -r | grep -q -e 'microsoft' -e 'WSL'; then
    echo "This is WSL"
else
    echo "This is not WSL"
fi


# Get the path of this script
script_path=$(readlink -f "$0")

# Convert to Windows format
windows_path=$(wslpath -w "$current_dir")

echo "Windows path: $windows_path"

# Create .obsynconfig if it doesn't exist
if [ ! -f "$current_dir/.obsynconfig" ]; then
    touch "$current_dir/.obsynconfig"
fi
