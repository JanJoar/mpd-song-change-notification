#!/bin/bash

# Get the current song details.
song_info=$(mpc --format '%artist%\n%title%\n%file%' current)

# Split the song details into artist, title, and file path.
artist=$(echo "$song_info" | sed -n '1p')
title=$(echo "$song_info" | sed -n '2p')
file=$(echo "$song_info" | sed -n '3p')

# Use a temporary directory to store the album art.
album_art_dir="/tmp/mpd_album_art"
mkdir -p "$album_art_dir"

# Extract album art using ffmpeg.
album_art_file="${album_art_dir}/album_art.jpg"
ffmpeg -loglevel quiet -y -i "$HOME/Music/$file" -an -vcodec copy "$album_art_file" < /dev/null

# Display unknown metadata when the file played does not contain any.
if [ $? -ne 0 ]; then
    notify-send -a "Now playing" -i "~/notfound.jpg" "Unknown" "Unknown"
else
    notify-send -a "Now playing" -i "$album_art_file" "$artist" "$title"
fi
