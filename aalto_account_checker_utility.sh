#!/bin/bash

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

# -- Options --
# Source of the getopt template: http://scicomp.aalto.fi/training/linux-shell-tutorial.html#working-with-the-input
# here is the whole trick: getopt validates the input parameters, returns the
# correct ones then they are reassigned back to $@ with 'set --'
opts=$(getopt "c" "$@") || exit 1   # instead of exit, can be 'usage' message/function
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
    -c) COMPACT=0 ;; # reports total number of characters in the document
    --) shift; break ;;   # remove --
  esac
  shift
done
# by now $@ has only rubish filtered out by 'getopt', could be a file name


# -- Argumets --
# Input is space separated string of usernames: `u_1 u_2 ... u_n`.
if [[ -p /dev/stdin ]]; then # If STDIN is not empty ...
  users=$(</dev/stdin)
else
  users=${@:-$USER}
fi


expires() {
  # Shows Aalto account expiration date, needs to be run
  # on Aalto Linux servers or workstations
  # Usage: $0 [aalto_login_name]
  # Remember to run 'kinit' if you SSH to kosh/lyta etc

  user=$1
  query=$(net ads search samaccountname=$user accountExpires pwdLastSet 2>/dev/null)

  if [[ "$query" =~ 'Got 0 replies' ]]; then
    # if this found, no user info is available
    echo No account found: $user
  else
    account_expires=$(echo $query | grep -E -o 'accountExpires: ([0-9]+)' | grep -E -o '[0-9]+')
    account_expires=$(( ($account_expires/10000000)-11644473600 ))
    password_last_set=$(echo $query | grep -E -o 'pwdLastSet: ([0-9]+)' | grep -E -o '[0-9]+')
    password_last_set=$(( ($password_last_set/10000000)-11644473600 ))

    now=$(date +%s)
    days_till_expiration=$(( ($account_expires - $now) / (60*60*24) ))

    if [[ $COMPACT ]]; then
      format='+%Y-%m-%d'
      echo -n $user:
      echo -n $(date $format -d "1970-01-01 $account_expires sec GMT"):
      echo -n $days_till_expiration:
      echo $(date $format -d "1970-01-01 $password_last_set sec GMT")
    else
      echo $user
      echo -e "  Account expires: $(date -d "1970-01-01 $account_expires sec GMT")"
      echo -e "  Days till expiration: $days_till_expiration"
      echo -e "  Password last changed: $(date -d "1970-01-01 $password_last_set sec GMT")"
    fi
  fi
}


# Loop over the users and output the information into the STDOUT
for user in $users; do
  expires $user
done
