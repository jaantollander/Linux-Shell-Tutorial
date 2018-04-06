#!/bin/bash

# Shows Aalto account expiration date, needs to be run
# on Aalto Linux servers or workstations
# Usage: $0 [aalto_login_name]
# Remember to run 'kinit' if you SSH to kosh/lyta etc

# If login name omitted, $USER used by default
u=${1:-$USER}

# request the account info and pipe it to while loop
net ads search samaccountname=$u accountExpires 2>/dev/null | \
while read line; do

  # we read output line by line

  # if this found, no user info is available
  if [[ "$line" =~ ^Got\ 0\ replies$ ]]; then
    echo No account found: $u
    exit 1
  # if string matches, get the number and convert it to human readable
  elif [[ "$line" =~ ^accountExpires:\ ([0-9]+)$ ]]; then
    date -d "1970-01-01 $(((${BASH_REMATCH[1]}/10000000)-11644473600)) sec GMT"
    exit 0
  fi
done

# a shorter version can be implemented with grep, if errors handling
# does not matter
