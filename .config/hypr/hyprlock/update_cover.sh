#!/bin/bash
# update_cover.sh: Update cover art only when the track changes

# Temporary file to store the previous track ID
prev_track_file="/tmp/prev_track.txt"
cover_file="/tmp/cover.jpg"
default_cover="assets/black.jpg"  # Replace with the path to your default image

# Initialize the previous track value if the file doesn't exist
if [ -f "$prev_track_file" ]; then
    prev_track=$(cat "$prev_track_file")
else
    prev_track=""
fi

while true; do
    # Get the current track ID
    current_track=$(playerctl metadata --player=%any,chromium,firefox --format "{{ mpris:trackid }}" 2>/dev/null)
    
    # If the track has changed, update the cover art
    if [ "$current_track" != "$prev_track" ]; then
        echo "$current_track" > "$prev_track_file"  # Update the reference file
        cover_url=$(playerctl metadata --player=%any,chromium,firefox --format "{{ mpris:artUrl }}" 2>/dev/null)
        
        if [ -n "$cover_url" ]; then
            # Download the new cover art
            curl -s "$cover_url" -o "$cover_file"
        else
            # If no cover art exists, use the default cover
            cp "$default_cover" "$cover_file"
        fi
    fi
    sleep 10  # Check every 5 seconds (adjust as needed)
done

