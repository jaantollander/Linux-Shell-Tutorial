#!/bin/bash

# Write a script that accepts a file with random text either from STDIN
# or a filename as a script argument (-f filename). Your script must
# accept several options and take an action based on them
#
#  -c      reports total number of characters in the document
#  -w      reports total number of words in the document
#  -t n    top 'n' most common words, where n is any positive integer
#  -s      sorted list of how often appear words of different lengths, like
#             words #    word length
#                   56    1
#                   34    2
#                   87    3
#                   23    4
#
# As a text file example, script should be able to analyze
# https://www.gnu.org/software/bash/manual/bash.txt
#
# Usage 'cat bash.txt | ./script -t 10 -w'
#    or './script -f bash.txt -s'
#
# When counting words, word may consist of letters only
# i.e. " [a-zA-Z]+ ". Pay attention to 'instance.' 'integer;'
# occurrances and alike. Punctuation, special characters, digits,
# must be cleaned up before counting word lengths. The rest items
# like paths, variable names, URLs etc can be omitted for this
# assignment.


# -- Arguments and options --
# Source of the getopt template: http://scicomp.aalto.fi/training/linux-shell-tutorial.html#working-with-the-input
# here is the whole trick: getopt validates the input parameters, returns the
# correct ones then they are reassigned back to $@ with 'set --'
opts=$(getopt "f:cwt:s" "$@") || exit 1   # instead of exit, can be 'usage' message/function
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
    -f) shift; FILE=$1 ;; # path to the input file
    -c) CHARACTERS=0 ;; # reports total number of characters in the document
    -w) WORDS=0 ;; # reports total number of words in the document
    -t) shift; n=$1 ;; # top 'n' most common words, where n is any positive integer
    -s) SORTED=0 ;; # sorted list of how often appear words of different lengths
    --) shift; break ;;   # remove --
  esac
  shift
done
# by now $@ has only rubish filtered out by 'getopt', could be a file name

# STDIN: Overwrites any supplied -f arguments if given
FILE=${FILE:-$1}

# -- The algorithm --
text=$(cat $FILE)

# Create a list of words. Word is defined as the pattern '[a-zA-Z]+'.
words=$(grep -E -o '[a-zA-Z]+' $FILE)
# Remove all all characters exept alphabetic, line endings or white spaces.
# words=$(tr $text -dc '[:alpha:]\r\n ')

# TODO: count the number of times a particular word appears in the text
declare -iA count
for word in $words; do
  if [[ -z count[$word] ]]; then
    # Set the count to one
    count[${word}]=1
  else
    # Increment the count by one
    count[${word}]+=1
  fi
done

# Reports total number of characters in the document
if [[ $CHARACTERS == 0 ]]; then
  echo "Total number of characters in the document: ${#text}"
fi

# Reports total number of words in the document
if [[ $WORDS == 0 ]]; then
  number_of_words=0
  for i in ${count[@]}; do
    number_of_words=$(($number_of_words+$i))
  done
  echo "Total number of words in the document: ${number_of_words}"
fi

# TODO: top 'n' most common words, where n is any positive integer
if [[ -z $n && $n > 0 ]]; then
  :
fi

# TODO: sorted list of how often appear words of different lengths
if [[ $SORTED == 0 ]]; then
  :
fi
