#!/bin/bash

# Create a directory for resized large images
mkdir -p resized_large

# Loop through image files (JPEG, PNG, etc.)
for file in *.jpg *.jpeg *.png; do
    # Check if the file exists to avoid errors
    if [ -f "$file" ]; then
        # Get the filename without extension for output
        filename=$(basename "$file" | sed 's/\.[^.]*$//')
        
        # Resize to a width of 1200px (maintaining aspect ratio) and convert to JPEG with quality 85
        # If the image is smaller than 1200px, it won't be upscaled
        convert "$file" -resize 1200x> -quality 85 "resized_large/${filename}.jpg"
        
        # Optional: Further optimize the JPEG to ensure file size is under 200–300 KB
        # Using jpegoptim (install with `sudo apt install jpegoptim` on Linux)
        jpegoptim --max=85 --size=250k "resized_large/${filename}.jpg"
    fi
done

echo "Resizing complete. Check the 'resized_large' folder for results."