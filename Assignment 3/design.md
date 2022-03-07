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

## For Parallelism
We divide this merge sort into two main systems
* Controller
* Merge Unit (Plant)
> There can be multiple merge units which gets sub arrays from controller and internally update their states.

## System Definations and Implementations
### Transition System
The systems here follow a deterministic approach and each action is atomic and every non trivial interaction leads it to a well defined state.   
```Controller -> Merge Unit -> Result```  
> This can internally be changed and order could be different depending on the order of actions performed. 
### Available Interactions
* Next: Action in the controller which moves forward the experiment.
* Sort MergeUnit<sub>i</sub>: Sorts the part of array in mergeUnit using merge sort algo.
* Merge MergeUnit<sub>i</sub>: Merges the part of array in mergeUnit to the original position in main Array in Controller.
### Controller
Controller here is the main working system, which is invoked when user presses next. 
* Controller has control on the main array, and it sends out sub arrays to merge Units on clicking next by user
* We have sanity checks to make sure that on clicking next:
  * If the current size all arrays are sorted increment index
  * Select n arrays of length size starting from index (n is the number of merge units)
  * If all merge units have not merged the arrays succesfuuly after sorting, do nothing.
### Merge Unit 
Merge Units have two booleans mu_sorted, mu_merged, which tell us about their status. Each merge unit also has a sub array which we merge independently and which helps in the parallel processing here, which can work independently. 
