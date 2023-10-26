#!/bin/bash

# Language selection menu
echo "Изберете език / Select Language:"
echo "1. English"
echo "2. Български"

read -p "Choose your language (Изберете вашия език): " lang_choice

if [ "$lang_choice" == "2" ]; then
    # Bulgarian language
    prompt="Въведете името на файла с началното изображение за извличане: "
    file_not_found="Файлът не беше намерен. Моля, предоставете валидно име на файл."
    output_dir="извлечени_файлове"
    extraction_complete="Извличането приключи. Извлечените файлове се намират в директорията '$output_dir'."
else
    # English language
    prompt="Enter the filename of the initial image to extract: "
    file_not_found="File not found. Please provide a valid filename."
    output_dir="extracted_files"
    extraction_complete="Extraction complete. Extracted files are in the '$output_dir' directory."
fi

#  initial image file
read -p "$prompt" initial_image

# file exists check
if [ ! -f "$initial_image" ]; then
    echo "$file_not_found"
    exit 1
fi

# Create a directory to store extracted files
mkdir -p "$output_dir"

#extraction
binwalk -e "$initial_image" -C "$output_dir"

# extract subfolders
extract_images() {
    local input_dir="$1"
    local output_dir="$2"

    for image in "$input_dir"/*; do
        if [ -f "$image" ]; then
            binwalk -e "$image" -C "$output_dir"
        fi
    done
}

# extract images in subfolders
while true; do
    subfolders=("$output_dir"/*/)
    if [ ${#subfolders[@]} -eq 0 ]; then
        break
    fi

    for subfolder in "${subfolders[@]}"; do
        extract_images "$subfolder" "$output_dir"
    done
done

echo "$extraction_complete"
