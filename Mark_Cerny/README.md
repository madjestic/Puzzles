# a Haskell solution to Mark Cerny puzzle

$ ghc -O2 ./Main.hs -o ./test && time ./test
[1 of 1] Compiling Main             ( Main.hs, Main.o )
Linking ./test ...
solution for [1,2] : 
4

solution for [1,2,3] : 
10

solution for [1,2,3,4] : 
29

solution for [1,2,3,4,5] : 
76

solution for [1,2,3,4,5,6] : 
284


real	4m46.801s

$ time python -OO ./scratch_7.py 
2
4
10
29
76
284

real	330m54.546s
user	329m28.705s
sys	0m35.569s