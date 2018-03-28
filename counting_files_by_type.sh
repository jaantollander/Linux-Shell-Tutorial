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
