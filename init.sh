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

config="$current_dir/.obsynconfig"

# Check CONFIRM_REPO_IS_PRIVATE value
if [ -f "$config" ]; then
  confirm_repo_private=$(grep -o "CONFIRM_REPO_IS_PRIVATE=.*" "$config" | cut -d'=' -f2)
  if [ "$confirm_repo_private" = "true" ]; then
    echo "CONFIRM_REPO_IS_PRIVATE is set to true"
  else
    echo "CONFIRM_REPO_IS_PRIVATE is set to false"
  fi
fi



# Create .obsynconfig if it doesn't exist
if [ ! -f "$current_dir/.obsynconfig" ]; then
   rm "$current_dir/.obsynconfig"
fi

touch "$current_dir/.obsynconfig"
echo "CONFIRM_REPO_IS_PRIVATE=false" >> "$current_dir/.obsynconfig"



echo -e "This repository will store vaults with your notes that are not meant to be available to a broader public. Before you proceed, ensure this repository is private. Do you want to proceed? (y/n) \c"

read answer

if [ "$answer" != "${answer#[Yy]}" ]; then
  echo "Proceeding..."
else
  echo "Exiting..."
  exit 1
fi

