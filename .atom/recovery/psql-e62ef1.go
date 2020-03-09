package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
)

type Post struct {
	Id      int
	Content string
	Author  string
}

// 構造体sql.DBをポインタで指定。
var Db *sql.DB

func init() {
	var err error
	Db, err = sql.Open("postgres", "user=gwp dbname=gwp password=gwp sslmode=disable")
	fmt.Println("*Db:", *Db)
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
		err = rows.Scan(&post.Id, &post.Content, &post.Author)
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
	err = Db.QueryRow("select id, content, author from posts where id = $1", id).Scan(&post.Id, &post.Content, &post.Author)
	return
}

func (post *Post) Create() (err error) {
	// idを返すようにしている。
	statement := "insert into posts (content, author) values($1, $2) returning id"
	stmt, err := Db.Prepare(statement)
	if err != nil {
    fmt.Println("Error: You cannot save data", err)
		return
	}
	defer stmt.Close()
	err = stmt.QueryRow(post.Content, post.Author).Scan(&post.Id)
  fmt.Println("Create_err:", err)
	return
}

func (post *Post) Update() (err error) {
	_, err = Db.Exec("update posts set content = $2, author = $3 where id = $1", post.Id, post.Content, post.Author)
  fmt.Println("Update_err:", err)
	return
}

func (post *Post) Delete() (err error) {
  _, err = Db.Exec("delete from posts where id = $1", post.Id)
  //	_, err = Db.Exec("delete from posts")
  fmt.Println("Delete_err:", err)
	return
}

func main() {
	post := Post{Content: "hello world", Author: "Keisuke Honda"}

	fmt.Println("BeforeCreate",post)
	post.Create()

	readPost, _ := GetPost(post.Id)
	fmt.Println("readPost:",readPost)

	readPost.Content = "Bonjour Monde!"
	readPost.Author = "Masashi Nakayama"
	readPost.Update()

	posts, _ := Posts(10)
	fmt.Println("posts",posts)

	readPost.Delete()

  posts, _ = Posts(10)
  fmt.Println("posts",posts)
}
