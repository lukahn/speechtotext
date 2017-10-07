#!/bin/bash
# Version 1 - 08/10/2017
#Username and password. See https://console.bluemix.net/docs/services/speech-to-text/getting-started.html
#Note: This is not the secret. Example format given below.
username=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa
password=aaaaaaaaaaaa

#Directory that you wish to convert, quotes used in case of spaces.
#E.g. "The Economist Radio (All audio)"
inputdirectory="<directory>"

#Output directory. This will be a directory containing the same directory structure as the inputdirectory.
#E.g. "results" becomes "results/The Economist Radio (All audio)".
outputdirectory="<directory>"


mkdir -p $outputdirectory

find "$inputpath" -type f | while read file; do
    echo File: "$file"
    extension="${file##*.}"

    #Audio format (see: https://console.bluemix.net/docs/services/speech-to-text/input.html)
    audioformat=mp3

    if [ "${extension,,}" = "mp3" ]; then
        audioformat="mp3"
    fi
    elif [ "${extension,,}" = "wav" ]; then
        audioformat="wav"
    fi
    elif [ "${extension,,}" = "flac" ]; then
        audioformat="flac"
    fi
    elif [ "${extension,,}" = "ogg" ]; then
        audioformat="ogg"
    fi
    else echo "Audio format not found. Trying mp3."

    curl -X POST -u $username:$password \
        --header "Content-Type: audio/$audioformat" \
        --header "Transfer-Encoding: chunked" \
        --data-binary @"$file" \
        "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize" >> "outputdirectory""/"$file".txt
done