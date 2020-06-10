# The Coin Change (Change-Making) Problem

The coin change problem is an interesting pseudo-polynomial problem that involves finding all **combinations** of `coins` that when added together give a `total` value. The assumption is you have infinite number of denominations of those coins.

#### Example
Given a `total` of 5 and the following coin denominations `[1,2,3]` find all combinations of coins assuming you cannot run out of any denomination.

The answer would be the following:

```
[1, 1, 1, 1, 1]
[2, 1, 1, 1]
[2, 2, 1]
[3, 2]
```

All the above add up to the given total of 20, and we can use as many denominations as we want.

## The Coin Change Algorithm

Below is an implementation of the Coin Change Algorithm written in `Go`. The algorithm uses iteration instead of recursion as is typical with most Dynamic Programming problems, and solves it in `O(n^2)`

```go 
   package main
   
   import "fmt"
   
   
   
   // Performs Coin Change Problem using iteration and not recursion.
   // It is possible to use dynamic programing for marginal gains. This problem is considered Pseudo-Polynomial meaning
   // its running time is a polynomial in the numeric value of the input (the largest integer present in the input) —
   // but not necessarily in the length of the input (the number of bits required to represent it),
   // which is the case for polynomial time algorithms.
   // https://en.wikipedia.org/wiki/Pseudo-polynomial_time
   //
   // O(n^2) + O(5n)
   func CoinChange(total int, coins []int) [][]int {
   	ans := make([][]int, 0)
   
   	// O(n)
   	// The cache is used to check if certain remainders e.g. (total-coin) exist as part of the initial coin set.
   	// Using a cache gives O(1) access for verification
   	coinsCache := make(map[int]bool)
   	for i := range coins {
   		coinsCache[coins[i]] = true
   	}
   
   	// O(n^2)
   	// Here we are subtracting the total from each set of coins until we hit the base condition of rem > 0
   	for i := 0; i < len(coins); i++ {
   		perm := make([]int, 0)
   		coin := coins[i]
   		rem := total-coin
   
   		// coin count is used to count how many times we have deducted the remainder with our given coin i.e coins[i]
   		coinCount := 1
   		for rem > 0 {
   			// We verify if the remainder (rem) exists as part of our coin set
   			// If it does, then we add the remainder plus the number of same value coins used
   			if coinsCache[rem] {
   				perm = append(perm, rem)
   				for i := 0; i < coinCount; i++ {
   					perm = append(perm, coin)
   				}
   				ans = append(ans, perm)
   				perm = make([]int, 0)
   			}
   			// We continue to decrement the remainder until we hit our base case
   			rem = rem - coin
   			coinCount++
   		}
   	}
   
   
   	// duplStruct is a temporary struct used to house the index of the duplicates found
   	type duplStruct struct {
   		index int
   		arr []int
   	}
   
   	// O(n)
   	// We know that in certain cases we may obtain duplicate entries e.g. [4, 5] or [5,
   	//4] this only occurs if the total is a sum of two valid coins. So if our total is 9, and our coins are [2,3,4,
   	//5] we know 4 and 5 will give us 9 but so will 5 and 4. Here we weed out our duplicates.
   	tempStore := make([]duplStruct, 0)
   	for i := range ans {
   		// We know for our special case that the length of the coins array will always be 2 if there are duplicates
   		//e.g. [4,5] or [5,4] is of length two. No other combination occurs if there are same-length duplicates
   		if len(ans[i]) == 2 {
   			dupl := duplStruct{
   				index: i,
   				arr:   ans[i],
   			}
   			tempStore = append(tempStore, dupl)
   		}
   	}
   
   	// O(n)
   	// Here we find the two duplicates and adjust our final array to exclude one of the pair of duplicates
   	if len(tempStore) == 2 {
   		if isDuplicate(tempStore[0].arr, tempStore[1].arr) {
   			index := tempStore[0].index
   			left := ans[:index]
   			right := ans[index+1:]
   
   			// Here we create a new array that excludes one of the two duplicates and we return the final ans
   			finAns := make([][]int, 0)
   			finAns = append(finAns, left...)
   			finAns = append(finAns, right...)
   			return finAns
   		}
   	}
   
   	return ans
   }
   
   
   
   // isDuplicate checks to see if two same-length slices are duplicates of one another by value and not by position.
   // [1,2] and [2,1] are considered duplicates, and so are [1,2] and [1,2]
   // O(2n)
   func isDuplicate(a, b []int) bool {
   	if len(a) != len(b) {
   		return false
   	}
   
   	cacheA := make(map[int]bool)
   	for i := range a {
   		cacheA[a[i]] = true
   	}
   
   	for i := range b {
   		if !cacheA[b[i]] {
   			return false
   		}
   	}
   	return true
   }
   
   func main() {
   	coins := []int{4,3,2,5}
   	total := 20
   
   	change := CoinChange(total, coins)
   	fmt.Printf("Coins: %v\n" +
   		"Total: %d\n\n", coins, total)
   	fmt.Printf("# of Change Combinations: %d\n", len(change))
   	fmt.Println("Change Combinations:")
   
   	for _, perms := range change {
   		fmt.Printf("%v\n", perms)
   	}
   }
```

Here is the output

```shell script
    Coins: [4 3 2 5]
    Total: 20
    
    Change Combinations: 6
    Change is:
    [4 4 4 4 4]
    [5 3 3 3 3 3]
    [2 3 3 3 3 3 3]
    [4 2 2 2 2 2 2 2 2]
    [2 2 2 2 2 2 2 2 2 2]
    [5 5 5 5]
```