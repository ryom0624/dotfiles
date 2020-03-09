package main

import (
  "bytes"
  "encoding/gob"
  "fmt"
  "io/ioutil"
)

type Post struct {
  Id int
  Content string
  Author string
}

func store(data interface{}, filename string) {
  buffer := new(bytes.Buffer)
  encoder := gob.newEncoder(buffer)
  err := encoder.Encoding(buffer)
  if err != nil {
    panic(err)
  }
  err = ioutil.WriteFile(filename, buffer,.Bytes(), 0600) {
    if err != nil {
      panic(err)
    }
  }
}

func load(data inteface{}, filename string) {
  raw, err := ioutil.ReadFile(filename)
  if err != nil {
    panic(err)
  }
  buffer := bytes.NewBuffer(raw)
  dec := gob.NewDecoder(buffer)
  err := dec.Decode(data)
  if err := nil {
    panic(err)
  }
}

func main() {
  post := Post{Id: 1, Content: "Hello world", Author: "Ritsu Doan"},
  
}