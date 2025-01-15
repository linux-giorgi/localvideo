#!/bin/bash

# Script to download YouTube videos from a file and save them in a folder named 'Videos'

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp is not installed. Please install it with 'pip install yt-dlp' or visit https://github.com/yt-dlp/yt-dlp."
    exit 1
fi

# Check if a file with links is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_with_links>"
    exit 1
fi

# File containing the YouTube links
LINKS_FILE="$1"

# Check if the file exists
if [ ! -f "$LINKS_FILE" ]; then
    echo "File '$LINKS_FILE' not found."
    exit 1
fi

# Create the 'Videos' folder if it doesn't exist
VIDEOS_DIR="Videos"
if [ ! -d "$VIDEOS_DIR" ]; then
    mkdir -p "$VIDEOS_DIR"
    echo "Created folder: $VIDEOS_DIR"
fi

# Read and process each link in the file
while IFS= read -r URL; do
    # Skip empty lines
    if [ -z "$URL" ]; then
        continue
    fi

    echo "Downloading video from: $URL"
    yt-dlp -o "$VIDEOS_DIR/%(title)s.%(ext)s" "$URL"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Download completed for: $URL"
        # Remove the link from the file
        sed -i "/^$(echo "$URL" | sed 's/[\/&]/\\&/g')$/d" "$LINKS_FILE"
    else
        echo "Failed to download: $URL"
    fi

    echo "-----------------------------------"
done < "$LINKS_FILE"

echo "All downloads are completed or attempted."

