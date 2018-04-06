# Linux Shell Tutorial Homework
Homework exercises from [Linux shell tutorial](http://scicomp.aalto.fi/training/linux-shell-tutorial.html).


## 1. Counting files by type (10 points)

Write two versions of script that counts how many files there
are of each type in a given directory. Use `file filename`.
Script should accept a directory name. Output should look like:

```
$ ./script path/to/directory/name
5 gzip compressed data
20 directory
3 Bourne-Again shell script
11 ASCII text
3 empty
1 UTF-8 Unicode text
1 FORTRAN program
```

One version may use whatever Linux tools you find on Triton, but
the other one can use only BASH built-in functionality. The only
exception is `file` utility itself.


## 2. Aalto account checker utilty (10 points)

Expand `/scratch/scip/BASH/bin/expires` script to get a proper
utility out of it. Your new script should:

* accept list of users either as input parameters
  `./expires user1 user2 user3 user4`
* or as STDIN
  `w -h | cut -c1-8 | sort -u | ./expires`
* if run with no arguments or STDIN report for current `$USER`
* report account expiration date
* report amount of days till account is expired
* report date when password has been last changed. Example:
  ```
  $ ./expires user1 user2
  user1
    Account expires: Sun Jan  8 23:00:00 EET 2019
    Days till expiration: 234
    Password last changed: Wed Dec 14 16:45:12 EET 2017
  user2
    ...
  ```
* accept -c option, and if given, make a compact version. Example:
  ```
  $ ./expires -c user1 user2
  user1:2019-01-08:234:2017-12-14
  user2:...:....:
  ```

Note: script will work on Aalto Linux servers and workstations,
not on Triton.


## 3. Bubble sort and Shell sort  (10 points)

Implement Bubble and David Shell sort algorithms using BASH
internal functionality only. Make a performance comparison
for sorting 1000 random numbers with `time` utility.

([Shellsort](http://lcm.csa.iisc.ernet.in/dsa/node197.html))

For generating random numbers one can use function we have
developed during the tutorial. Alternatively, script can
accept random numbers as standard input, generated like
`shuf -i1-1000 -n1000` or in a similar way.

Optionally, if only Bubble sort algorithm is implemented,
it is 4 points.


## 4. Text analyzer  (10 points)

Write a script that accepts a file with random text either from STDIN
or a filename as a script argument (`-f filename`). Your script must
accept several options and take an action based on them

```
-c      reports total number of characters in the document
-w      reports total number of words in the document
-t n    top 'n' most common words, where n is any positive integer
-s      sorted list of how often appear words of different lengths, like
          words #    word length
               56    1
               34    2
               87    3
               23    4
```

As a text file example, script should be able to analyze
[bash.txt](https://www.gnu.org/software/bash/manual/bash.txt)

Usage `cat bash.txt | ./script -t 10 -w`
   or `./script -f bash.txt -s`

When counting words, word may consist of letters only
i.e. `[a-zA-Z]+`. Pay attention to 'instance.' 'integer;'
occurrances and alike. Punctuation, special characters, digits,
must be cleaned up before counting word lengths. The rest items
like paths, variable names, URLs etc can be omitted for this
assignment.


## 5. Sanajahti solver (10 points)

Originally it is a game, known in English as Wordz. The game
play is connecting letters to words on 4x4 matrix of letters.
In any direction, any connection be it edge or corner
(diagonal) works.

Pick up dictionary from
[words_alpha.txt](https://github.com/dwyl/english-words/raw/master/words_alpha.txt)
(remember `tr -d '\15\32' < windows.txt > unix.txt`)

The script should accept a 16 characters line like
`DOBEWCMEEETPCNXT`, that corresponds to 4x4 matrix

```
DOBE
WCME
EETP
CNXT
```

The script must output found words one by one to STDOUT.
The script must accept a dictionary file as an argument.

Example: `./sj_solver -d words.txt DOBEWCMEEETPCNXT`
