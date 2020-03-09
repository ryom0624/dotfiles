package main

import (
  "database/sql"
  "fmt"
  _ "github.com/lib/pq"
)


type Post struct {
  Id int
  Content string
  Author string
}


var DB *sql.DB

func init() {
  var err error
  Db, err = sql.Open("postgres", "user=gwp dbname=gwp password=gwp sslmode=disable")
  if err != nil {
    panic(err)
  }
}

func Posts(limit int) (posts []Post, err error) {
  rows, err := Db.Query("select id, content, author from posts limit $1", limit)
  if err != nil {
    return
  }
  
  for rows.Next() {
    post := Post{}
    err = rows.Scan(&post.Id, &post.Content, &post,Author)
    if err != nil {
      return
    }
    posts = append(posts, post)
  }
  rows.Close()
  return
}

func GetPost(id int) (post Post, err error) {
  post = Post{}
  err = dDb.QueryRow("select id, content, author from posts where id = $1", id).Scan(&post.Id, &post.Content, &post.Author)
  return
}





func main() {
  
}