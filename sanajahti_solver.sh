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
