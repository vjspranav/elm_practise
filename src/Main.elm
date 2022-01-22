module Main exposing (myArray,merge)
import List

myArray =
    [ 5, 1, 2, 100, 24, 38, 20, 15, 3 ]

merge array =
    List.map (\num -> num*2) array 
