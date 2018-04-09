#!/bin/bash

# Originally it is a game, known in English as Wordz. The game
# play is connecting letters to words on 4x4 matrix of letters.
# In any direction, any connection be it edge or corner
# (diagonal) works.
#
# Pick up dictionary from
# https://github.com/dwyl/english-words/raw/master/words_alpha.txt
# (remember tr -d '\15\32' < windows.txt > unix.txt)
#
# The script should accept a 16 characters line like
# DOBEWCMEEETPCNXT, that corresponds to 4x4 matrix
#
# DOBE
# WCME
# EETP
# CNXT
#
# The script must output found words one by one to STDOUT.
# The script must accept a dictionary file as an argument.
#
# Example: ./sj_solver -d words.txt DOBEWCMEEETPCNX

# -- Arguments and options --
# Source of the getopt template: http://scicomp.aalto.fi/training/linux-shell-tutorial.html#working-with-the-input
# here is the whole trick: getopt validates the input parameters, returns the
# correct ones then they are reassigned back to $@ with 'set --'
opts=$(getopt "d:" "$@") || exit 1   # instead of exit, can be 'usage' message/function
set -- $opts

# note: in one line one can do it like, though ugly
#set -- $(getopt "sdf:" "$@" || kill -HUP $$)
# $( ... || exit) does not work, since exit from inside a subshell, closes the # subshell only

# since script input parameters have been validated and structured, we can go
# through them we start an endless while and go through $@ with 'case' one by
# one 'shift' makes another trick, every time it is invoked, it shifts down $@
# params, $2 becomes $1, $2 becomes $3, etc while old $1 is unset getopt adds
# -- to $@ which separates valid options and the rest that did not qualify
while :; do
  case ${1} in
    -d) shift; dictionary_file=$1 ;; # path to the input file
    --) shift; break ;;   # remove --
  esac
  shift
done
# by now $@ has only rubish filtered out by 'getopt', could be a file name


# -- The algorithm --
# Input should be 16 characters long and only contain alphabetic characters
# otherwise exit the program.
string=$1
[[ ${#string} != 16 ]] && { echo "String should have 16 characters but only has ${#string}."; exit 1; }

# Potential words
words=''

# Function that constructs potential words from indices of the string.
construct_words() {
  indices=$1
  word=''
  for i in $indices; do
    word+=${string:$i:1}
  done
  words+=$word
  words+=" "
  # Contiguous substrings of length 3
  if [[ ${#word} == 4 ]]; then
    words+=${word:0:3}
    words+=" "
    words+=${word:1:3}
    words+=" "
  fi
}

# Find words vertically.
construct_words "0 1 2 3"
construct_words "4 5 6 7"
construct_words "8 9 10 11"
construct_words "12 13 14 15"

# Find words horizontally.
construct_words "0 4 8 12"
construct_words "1 5 9 13"
construct_words "2 6 10 14"
construct_words "3 7 11 15"

# Find words diagonally (up-right -> down-left).
construct_words "0 5 10 15"
construct_words "1 6 11"
construct_words "4 9 14"

# Find words diagonally (down-right -> up-left).
construct_words "12 9 6 3"
construct_words "8 5 2"
construct_words "13 10 7"

# Test is a potential words is found in the dictionary and output it in to
# the STDIN.
for word in $words; do
  # TODO: convert windows style lineending to unix style
  # Check if the word is in the dictionary. Case insensitive.
  pattern="^${word}$"
  matching_lines=$(grep -E -c -i -m 1 $pattern $dictionary_file)

  # Output the word into STDOUT if the word in in the dictionary.
  [[ $matching_lines > 0 ]] && { echo $word; }
done
