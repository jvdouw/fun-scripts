#!/bin/bash

# First define functions, otherwise they can't be called.
function printUsage(){
  # Prevent usage from being printed twice
  if [[ -z $usagePrinted ]]; then
    echo "Usage: coloured-text.sh TEXT"
    echo "TEXT is displayed in different colours for each letter, appearing over time."
    usagePrinted=1
  fi
}

function pickRandomColour() {
  # Make sure the range is between 30 (light green) and 47 (grey background)
  colourCode=$(($RANDOM % 18 + 30))
}

# Get the parameter, make sure it's just one
if [[ $# -le 1 ]]; then
  if [[ ! -z $1 ]]; then
    text=$1
  else
    echo "ERROR: No text passed" >&2
    printUsage
    exit 1
  fi
else
  echo "ERROR: too many arguments passed" >&2
  printUsage
  exit 1
fi

for (( i=0 ;i < ${#text}; i=i+1 )); do
  # Print the given text word in random colours
  pickRandomColour
  echo -en "\e[1;${colourCode}m"${text:$i:1}"\e[0m"
  sleep .1
done

echo

if [[ ! -z $debugMode ]]; then
  echo '\e[1;'$code"m$arg\e[0m" # debug
fi
