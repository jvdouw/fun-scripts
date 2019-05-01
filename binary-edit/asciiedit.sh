#!/bin/bash
# Quit at the first sign of trouble
set -e

echo "********************************************************" >&2
echo "* Welcome to the one and only binary ASCII text editor *" >&2
echo "********************************************************" >&2
echo >&2
echo "Type ones and zeroes as long as you want; cancel with any other character or
key. This script interprets 7-bit ASCII characters, and only 7-bit ASCII
characters." >&2
echo >&2
echo "Tip: typed in a wrong character? No worries whatsoever! Simply use the
backspace ASCII character! Made a mistake in typing the backspace? Just use two
backspaces characters!" >&2
echo >&2
echo "This intro is written to stderr, so you can suppress it." >&2
echo >&2
echo "=============================================================================" >&2

# Exiting happens within the loop
while [[ 1 ]]; do
  code=""
  for i in {1..7}; do
    read -rn 1 opt
    if [[ $opt != 0 && $opt != 1 ]]; then
      # This is admittedly very cryptic: it executes the loop once for every char
      # in $code.
      for i in $(eval "echo {0..${#code}}"); do
        # For some reason, in this case, backspace only puts the 'cursor' back,
        # doesn't delete the char, so replace by space to mimic actually
        # deleting.
        echo -ne "\b \b"
      done
      echo
      exit 0
    fi
    code=$code$opt
  done

  # Same code as above, not very elegant like this (double maintenance)
  for i in $(eval "echo {1..${#code}}"); do
    echo -ne "\b \b"
  done

  # bc is very 'logic', in a way: obase comes after ibase=2, so needs to be
  # defined in binary: 10000 = 16.
  hexcode=$(echo "ibase=2;obase=10000;$code" | bc)
  printf "\x$hexcode"
done
