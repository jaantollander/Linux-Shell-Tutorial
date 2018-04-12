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


# -- Options --
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


# -- The algorithm --
if [[ -p /dev/stdin ]]; then  # If STDIN is not empty ...
  # Use the text from STDIN, overwrites any supplied -f arguments
  text=$(</dev/stdin)
else
  # Use the text in the FILE
  text=$(cat $FILE)
fi

# Create a list of words. Word is defined as the pattern '[a-zA-Z]+'. Convert
# all words to lower case.
words=$(echo $text | grep -E -o '[a-zA-Z]+' | tr [:upper:] [:lower:])

# Remove all all characters exept alphabetic, line endings or white spaces.
# TODO? tr -dc '[:alpha:]\r\n '

# Count the number of times a particular word appears in the text
declare -iA count
for word in $words; do
  if [[ -z count[$word] ]]; then
    count[${word}]=1
  else
    count[${word}]+=1
  fi
done


# Reports total number of characters in the document
if [[ $CHARACTERS ]]; then
  echo "Total number of characters in the document: ${#text}"
fi


# Reports total number of words in the document
if [[ $WORDS ]]; then
  number_of_words=0
  for i in ${count[@]}; do
    number_of_words=$(($number_of_words+$i))
  done
  echo "Total number of words in the document: ${number_of_words}"
fi


# TOP 'n' most common words, where n is any positive integer
if [[ -n $n && $n -gt 0 ]]; then
  sepw=','
  sepl='^'
  word_and_count=''
  for word in ${!count[@]}; do
    count_=${count[$word]}
    word_and_count+="${count_}${sepw}${word}${sepl}"
  done

  most_common_words=$(echo $word_and_count | tr $sepl $'\n' | sort -n -r 2>/dev/null | head -n $n)

  echo -e "count #\tword"
  for word in $most_common_words; do
    # TODO: perhaps change ordering from "count word" to "word count"?
    echo -e "$(echo $word | tr $sepw $'\t')"
  done
fi


# Sorted list of how often words appear of different lengths
if [[ $SORTED ]]; then
  declare -iA count_by_length

  for word in ${!count[@]}; do
    length=${#word}
    if [[ -z count_by_length[$length] ]]; then
      count_by_length[$length]=${count[$word]}
    else
      count_by_length[$length]+=${count[$word]}
    fi
  done

  # TODO: sort count_by_length
  sepw=','
  sepl='^'
  count_by_length_str=''
  for length in ${!count_by_length[@]}; do
    count_by_length_str+="${count_by_length[$length]}${sepw}${length}${sepl}"
  done

  count_by_length_sorted=$(echo $count_by_length_str | tr $sepl $'\n' | sort -r -k 2n -t $sepw)

  echo -e "words #\tword length"
  for word in $count_by_length_sorted; do
    echo -e "$(echo $word | tr $sepw $'\t')"
  done
fi
