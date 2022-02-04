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
We do the same using successively refined transition systems which take a user from govong him a lot of choice to finally a trivial Next.  
This has been done as 4 systems:
* Manual Merge
* Automatic Merge
* Manual Iterative Sort
* Automatic Iterative Transitive System

Each of them is discussed briefly with the most trivial system discussed in detail at the end.  
## Manual Merge
Very firstly, we would want to give user the gist of how merge works. In the merge sort algorithm we have two arrays left and right which each have numbers in sorted order (by nature of algorithm). We chose the smaller of each number and increment the respective arrays index. We keep doing the same untill both arrays are empty. and we'll have a merged array which is also sorted.  
In the Manual merge we give user the option to select **left** or **right**, which will select element from left or right array.  
In this case we let the user select either left or right element and **do not** check the correctness.  
This choice could lead user to not getting a sorted array at the end, and we inform the same after the complete system completes runnnig.  
i.e. when both left array and right array are empty.  

## Automatic Merge
The automatic merge aims at letting user do the system step by step but not giving space for mistake. We would want to give user the gist of how merge works.  
In the Automatic merge we give user only one option **next**, which will select element from left or right array depending upon which element is smaller.    
In this case we do not let the user select left or right element and **ensure** the correctness.  
This shows the user the correct way of merghing left array and rigth array.  

## Manual Iterative Sort
Another crucial part of merge sort split, i.e. in merge sort we start from atomic number and start merging.  
Example: If we have array with 4 elements. First We select element 1 and 2 and merge(sort), then we select element 3 and 4 and merge(sort). Now we have two sets of sorted sub arrays. (1, 2) and (3, 4) Now we try mering them, and here the user is expected to gain the understanding from Merge Machine.  
Ideally the split sizes are supposed to be 1->2->4->8.... (length of array)/2  
But in the manual version, we give user a dropdown and allow him to select the size and start merging, which definitively leads to wrong answer if sizes aren't incremented in order.  

## Automatic Iterative Transition System
Finally, this is the most trivial of the machines. This takes only **next** as user input, and takes care of size slection, splitting and merging automatically while iteratively taking the user through the process. The detailed explanation of this workflow is given below. 

# The Final Work flow of Transition System
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


# Components
All four systems(machines) in the end perform the same action and hence almost the whole codebase remains the same, with exceptions for difference in a single variable (like larray, lsize, size, select etc..) which respectibvely define the working of a system.