#!/bin/bash

# Implement Bubble and David Shell sort algorithms using BASH
# internal functionality only. Make a performance comparison
# for sorting 1000 random numbers with 'time' utility.
#
# (Shellsort http://lcm.csa.iisc.ernet.in/dsa/node197.html)
#
# For generating random numbers one can use function we have
# developed during the tutorial. Alternatively, script can
# accept random numbers as standard input, generated like
# 'shuf -i1-1000 -n1000' or in a similar way.
#
# Optionally, if only Bubble sort algorithm is implemented,
# it is 4 points.

bubble_sort() {
  # Input is space separated string of numbers: `n_1 n_2 n_3 ... n_m`.
  if [[ -p /dev/stdin ]]; then # If STDIN is not empty ...
    # `echo $(shuf -i1-100 -n10) | bubble_sort)`
    numbers=$(</dev/stdin)
  else
    # `bubble_sort $(shuf -i1-100 -n10)`
    numbers=$@
  fi

  # Create an array from the input.
  array=()
  for i in $numbers; do
    array+=($i)
  done

  # Bubble sort algorithm.
  # https://www.geeksforgeeks.org/python-program-for-bubble-sort/
  n=${#array[@]}
  for (( i=0; i < $n; i++ )); do
    for (( j=0; j < $n-$i-1; j++ )); do
      j2=$(( $j+1 ))
      if [[ ${array[$j]} -gt ${array[$j2]} ]]; then
        # echo ${array[$j]}, ${array[$j2]}
        tmp=${array[$j]}
        array[$j]=${array[$j2]}
        array[$j2]=$tmp
      fi
    done
  done

  # Output the sorted array into STDOUT.
  for i in ${array[@]}; do
    echo -n "$i "
  done
  echo
}

shell_sort() {
  # TODO: implementation
  :
}
