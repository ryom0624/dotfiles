package main

import (
  "fmt"
)

func main() {
  n := []int{1,2,3,4,5,6}
  fmt.Println(n) 
  fmt.Println(n[2]) // 3
  fmt.Println(n[2:4]) // [3 4]
  fmt.Println(n[:2]) //[1 2]
  fmt.Println(n[2:]) //[3 4 5 6]
  fmt.Println(n[:])
  n[2] = 100 
  fmt.Println(n)
  
  var board = [][]int{
    []int{0,1,3}
  }
  
}