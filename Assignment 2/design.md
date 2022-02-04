# Design Document
Here we descirbe the design and algorithm of our program.

## Algorithm
Mergesort follows a simple divide abd conquer algorithm, i.e. first we break down the array to the smallest possible division and start merging two divisions while sorting them. This way size of our divisions keep increasing till we finally have only 1 division left that is our array  
**Representation**
```
[2, 5, 4, 3, 7, 1, 0]
[[2, 5, 4, 3] [7, 1, 0]]
[[[2, 5] [4, 3]] [[7, 1] [0]]]
[[[[2] [5]] [[4] [3]]] [[[7], [1]] [0]]]
-- Now merging each set of two divisions while sorting them
[[[2, 5] [3, 4]] [[1, 7] [0]]]
[[2, 3, 4, 5] [0, 1, 7]]
[0, 1, 2, 3, 4, 5, 7] -- Our sorted array
```
This is a simple workflow. Our aim is show the same working through a iterative flow.

## Workflow
As per our definiation we consider at any given time our program to be at a sinngle state, and any corresponding action would lead to change in state. As mentioned in our [Design doc](./system.md)  
Our state(Modal) consists of 4 values array: List Int, index: Int, size: Int, change: Bool  
* array i our array which has to be sorted (and which will be sorted as we perform actions)
* size is the size of the subarray which we are merging, we start this from 1, and move from left to right and selct two subArrays of length size. and we merge them using merge sort. Through this procedure at any given point, two selected sublists are internaly fully sorted. 
* index shows the index from which we select two subLists. we keep incrementing this after every action till we reach the end of the array.
* change is a boolean that stays false as long as we are iteratively merging the sub lists, and when we increment size (from 1 to 2 or 2 to 4) and reset index to start from beginning, 

## Recursive vs My Implementation
The recursive implementation continuously breaks down the array to atomic (single) element and starts merging it while sorting.  
The code iteratively follows the same structure, and directly starts form the atomic element and starts merging them 2 at a time from left and sorting them while merging. Next we consider our atomic element to be set of two elements as now two elements sets will be sorted. and thus we follow the recursive algorithm.

## Implementation
The implementation follows hand in hand with the above mentioned description. Below quoted is the most major driver code of the program
```
Next -> 
    if model.size > List.length model.array then
        model
    else if model.i > List.length model.array then
        { model | array = model.array, i = 1, size = model.size * 2, change = True }
    else
        { model | array = mergeSort model.array model.i model.size, i = model.i + (model.size * 2), size = model.size, change = False }
```
and  
```
-- This line in mergeSort Function
getSubList 1 i arr ++ mergeSubList (getSubList i (i + size) arr) (getSubList (i + size) (i + size * 2) arr) ++ getSubList (i + size * 2) (List.length arr + 1) arr
```
> Here getSublist f l returns a sublist from f(inclusive) to l(exclusive) i.e. [arr[x] | x belongs to [f, l)]  

This last snippet merges the sublist and inserts the sorted merged list in place, where the unsorted elements were present.
