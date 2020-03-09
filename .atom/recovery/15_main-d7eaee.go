package main

import (
  "fmt"
)

func foo(p1, p2 int) int {
  return p1 * p2
}

func bar(params... int) []int {
  fmt.Println(params)
  return params
}

func piyo(params... int) int {
  fmt.Println(len(params), params)
}

func main() {
  foo(10, 20)
  piyo := bar(10,20,30,20,30,50)
  fmt.Println(piyo)
}