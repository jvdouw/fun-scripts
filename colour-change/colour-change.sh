#!/bin/bash

# First define functions, otherwise they can't be called.
function printUsage(){
  # Prevent usage from being printed twice
  if [[ -z $usagePrinted ]]; then
    echo "Usage: colour-change.sh [FLAGS] [TEXT]"
    echo "TEXT is displayed in a color derived from the current second, i.e. it is
different every second."
    echo "FLAGS are one or more of:"
    echo "  -h  Display this help on usage, plus extra suggestions, and quit without
      processing any further arguments."
    echo "  -d  Debug mode: display 'raw' string as well"
    echo "  -n  Output no newline after string"
    usagePrinted=1
  fi
}

function printSuggestions(){
  echo "---------"
  echo "Suggested (fun) ways of using this script:"
  echo "---------"
  echo "# See the colour change in 'watch' every second"
  echo "watch -cn 1 ./colour-change.sh"
  echo "---------"
  echo "# See the colour change in your terminal every second"
  echo "while [[ 1 ]]; do"
  echo "  echo -ne '\b\b\b\b\b\b\b\b\b'";
  echo "  ./colour-change.sh -n"
  echo "  sleep 1"
  echo "done"
  echo "---------"
  echo "Nice, isn't it, a script outputting another script to the terminal?!"
  echo
}

# Get the flags (First colon sets getopts to silent mode so I can handle errors
# myself)
while getopts ':dhn' flag; do
  case "$flag" in
    h) printUsage
       printSuggestions
       exit 0 ;;
    d) debugMode=1 ;;
    n) noNewline=1 ;;
    *) echo "ERROR: flag -"$OPTARG" is invalid." >&2
       printUsage
       exit 1 ;;
  esac
done

# Don't display flags as coloured text
shift $((OPTIND-1))

# Get the parameter, make sure it's just one
if [[ $# -le 1 ]]; then
  if [[ ! -z $1 ]]; then
    arg=$1
  else
    # If there are no args, take default value "KLEURTJES"
    arg="KLEURTJES"
  fi
else
  echo "ERROR: too many arguments passed" >&2
  printUsage
  exit 1
fi

# Get the amount of seconds since the epoch
sec=$(date '+%s')

# Make sure the range is between 30 (light green) and 47 (grey background)
code=$((sec % 18 + 30))

# Print the word "KLEURTJES" in these colours
outputString='\e[1;'$code"m$arg\e[0m"
if [[ -z $noNewline ]]; then
  echo -e $outputString
else
  echo -en $outputString
fi

if [[ ! -z $debugMode ]]; then
  echo '\e[1;'$code"m$arg\e[0m" # debug
fi
