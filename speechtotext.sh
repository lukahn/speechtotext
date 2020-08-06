#!/bin/bash
# Version 1 - 08/10/2017
# Version 2 - 18/10/2017 - Added a move/resume support, and fixed some variables.
# Version 3 - 06/08/2020 - Fixed the script, and updated it for the latest IBM method calling format

# Todo: Make directories if they don't already exist when the input folder contains directories
#       Add flags to the command line, so we don't need to modify this file directly
#       Add formatting option to change from JSON to a list of sentences


#See https://console.bluemix.net/docs/services/speech-to-text/getting-started.html

#Note: This is not the secret. Example format given below.
username=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
password=aaaaaaaaaaaa

apikey="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
url="x"

#Directory that you wish to convert, quotes used in case of spaces.
#E.g. "The Economist Radio (All audio)"
inputDirectory=""

#Output directory. This will be a directory containing the same directory structure as the inputDirectory.
#E.g. "results" becomes "results/The Economist Radio (All audio)".
outputDirectory=""

#Directory to move the audio to once complete. This means that you can cancel and resume the script.
#E.g. "done"
moveDirectory=""

mkdir -p $outputDirectory
mkdir -p $moveDirectory

find "$inputDirectory" -type f | sed "s%^$inputDirectory/%%" | while read file; do
    echo File: "$file"
    extension="${file##*.}"

    #Audio format (see: https://console.bluemix.net/docs/services/speech-to-text/input.html)
    audioformat=mp3

    if [ "${extension,,}" = "mp3" ]; then
        audioformat="mp3"
    elif [ "${extension,,}" = "wav" ]; then
        audioformat="wav"
    elif [ "${extension,,}" = "flac" ]; then
        audioformat="flac"
    elif [ "${extension,,}" = "ogg" ]; then
        audioformat="ogg"
    else
        echo "Audio format not found. Trying mp3."
    fi

    curl -X POST -u "apikey:$apikey" \
        --header "Content-Type: audio/$audioformat" \
        --data-binary @"$file" \
        "$url/v1/recognize" >> "$outputDirectory"/"$file".txt

    mv "$file" "$moveDirectory"/"$file"
done
