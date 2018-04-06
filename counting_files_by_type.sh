#!/bin/bash

# Write two versions of script that counts how many files there
# are of each type in a given directory. Use 'file filename'.
# Script should accept a directory name. Output should look like:
#
#  $ ./script path/to/directory/name
#   5 gzip compressed data
#   20 directory
#   3 Bourne-Again shell script
#   11 ASCII text
#   3 empty
#   1 UTF-8 Unicode text
#   1 FORTRAN program
#
# One version may use whatever Linux tools you find on Triton, but
# the other one can use only BASH built-in functionality. The only
# exception is 'file' utility itself.

# TODO: getopt

# Directory to search with default value of "."
directory=${1:-.}

# Count the unique filetypes in an associative array which has integer elements
declare -iA counts

# Iterate over each file in the directory
for fpath in ${directory}/*
do
  # Get brief description of the filetype of given directory
  filetype=$(file -b ${fpath})

  # Does the key (filepath) already exist in the associative array
  if [[ -z counts[$filetype] ]]; then
    # Set the count to one
    counts[${filetype}]=1
  else
    # Increment the count by one
    counts[${filetype}]+=1
  fi

done

# Print the elements in the associative array
for filetype in "${!counts[@]}"
do
  echo ${counts[${filetype}]} $filetype
done
