package main


import "C"

//export Add
func Add(a, b int) int {
    return a + b
}

// 必须有一个 main 函数，即使它是空的
func main() {
}