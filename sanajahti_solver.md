# Sanajahti Solver

```
index:  0 1 2 3 | 4 5 6 7 | 8 9 10 11  | 12 13 14 15
string: A B C D | E F G H | I J  K  L  | M  N  O  P
```

```
A B C D
E F G H
I J K L
M N O P
```

Vertically
```
0 1 2 3
A B C D
A B C
  B C D

...
```

Horizontally
```
0 4 8 12
A E I M
A E I
  E I M

...
```

Diagonally
```
0 5 10 15
A F  K P
A F  K
  F  K P

1 6 11
B G L

4 9 14
E J O
```

Diagonally
```
12 9 6 3
 M J G D
 M J G
   J G D

8 5 2
I F C

13 10 7
N  K  H
```
