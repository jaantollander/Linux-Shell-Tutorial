# Expand /scratch/scip/BASH/bin/expires script to get a proper
# utility out of it. Your new script should:
#
#  * accept list of users either as input parameters
#    ./expires user1 user2 user3 user4
#  * or as STDIN
#    w -h | cut -c1-8 | sort -u | ./expires
#  * if run with no arguments or STDIN report for current $USER
#  * report account expiration date
#  * report amount of days till account is expired
#  * report date when password has been last changed
#
#    Example: $ ./expires user1 user2
#             user1
#               Account expires: Sun Jan  8 23:00:00 EET 2019
#               Days till expiration: 234
#               Password last changed: Wed Dec 14 16:45:12 EET 2017
#             user2
#               ...
#
#  * accept -c option, and if given, make a compact version
#
#     Example: $ ./expires -c user1 user2
#              user1:2019-01-08:234:2017-12-14
#              user2:...:....:
#
# Note: script will work on Aalto Linux servers and workstations,
# not on Triton.
