package main

import (
	"fmt"
	"io/ioutil"
	"os"
)

func main() {
	// data1 := "Hello world"
	// fmt.Printf("%v %T\n", data1, data1) // Hello world string
	// data2 := []byte("Hello slice")
	// fmt.Printf("%v %T %v\n", data2, data2, string(data2)) // [72 101 108 108 111 32 115 108 105 99 101] []uint8 Hello slice
  var a []int
	b := []
	fmt.Println(a, b)

	// そもそもioutil.Write()には[]byteしか渡せない。
	data := []byte("Hello World")
	err := ioutil.WriteFile("data1", data, 0644)
	if err != nil {
		panic(err)
	}
	
	read1, _ := ioutil.ReadFile("data1")
	fmt.Println("read1 :", string(read1))
	
	file1, _ := os.Create("data2")
	defer file1.Close()
	
	bytes, _ := file1.Write(data)
	fmt.Println("Wrote %d bytes to file \n", bytes)
	
	file2, _ := os.Open("data2")
	defer file2.Close()
	
	read2 := make([]byte, len(data))
	
	bytes, _ = file2.Read(read2)
	fmt.Println("Read %d bytes from file\n", bytes)
	fmt.Println(string(read2))

  //defer -- main()が終わるタイミングで、file2 → file1 の順番でクローズ
}
