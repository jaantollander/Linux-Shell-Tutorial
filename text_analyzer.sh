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
