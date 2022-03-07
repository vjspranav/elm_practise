# System Defination
Here we define the system architecture, and how we defined our program as 
## States and Actions
We define each problem in a very simple way
* P: Where To Start
* F: What to Do
* f: When to stop (fixed point)
* pi: How to report answer.

We try to show the functionality of a program as dicrete flows. Further down we'll be talking about how our Merge Sort program can be described in the above mentioned format.  

We describe our program as a set of states and we move from one state to another through actions.

X -F-> Y : Would Say action F is changing state X to Y.

## Successively Refined Transisiton Systems.
We have 4 systems which gradually take a user from giving him the freedom to control the experiment to making it trivial. The system design for each is discussed below.

### Merge Sort with Manual Merge
Our state(Modal) consists of  values array, larray, rarray, index, size, lsize, rsize  
At any given point larray and rarray are themselves sorted.  
User is given the options of left and right buttons.  
Left button picks the smallest element from the left and Right button from the right anf places it in array.  
User constinues to do so till the larray and rarray are empty.  
Then we tell user whether he did it properly ot not.  

### Merge Sort with Automatic Merge
Our state(Modal) consists of  values array, larray, rarray, index, size, lsize, rsize  
At any given point larray and rarray are themselves sorted.  
User is given the options of next button.  
On click of next button, the smaller of left and rigth is selected and placed into the array.  
User constinues to do so till the larray and rarray are empty.  
This will give the correct order of steps, as machine is selecting and there is little user intervention.  

### Merge Sort as Manual Iterative System
Our state(Modal) consists of 4 values array: List Int, index: Int, size: Int, change: Bool  
We move from one State to another on our action **Next**.  
On a single next our array tries to sort a pair of size elements.  
size here is the number of elements that we divide before merging.  
This size control is given to user and allowed to change and keep clicking next.  
If the steps followed are wrong the array in the end won't be sorted and user will be informed the same.  

### Merge Sort as Iterative Transition System
This is the most trivial system
Our state(Modal) consists of 4 values array: List Int, index: Int, size: Int, change: Bool  
We move from one State to another on our action **Next**.  
On a single next our state changes from one to another by one of the two functions:
1. MergeSort subArray ```i``` to ```size```, ```i+size``` to ```i + size * 2```: These two sub arrays are internall sorted using merge mechanism and i is incremented by size*2. 
2. Increment size: Doubles the value of size.

If our i is more than size of array size is incremented and i is reset else MergeSort sublist is called.  
Let's relate this to our transition system
* P: The initial state containing arr, size, index initialized to default values
* F: 1, 2 are our actions which change one state to another.
* f: We stop once our size is greater than length of array, as sublist greater than size won't be possible and all smaller sublists are already sorted.
* pi: We output the array internally sorted at every step.
