package controllers

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"google.golang.org/appengine"
	"google.golang.org/appengine/datastore"
	"google.golang.org/appengine/log"
	"net/http"
	"os"
	m "sample/models"
	"time"
)

func GetIndex(c *gin.Context) {
	// 特定のリクエストに関連するすべての操作をまとめてリンク。リクエストに関連したcontext.Context値を返す。
	ctx := appengine.NewContext(c.Request)
	
	// テンプレート表示用の構造体を作成
	params := m.TemplateParams{}

	// 特定のエンティティの種類に対する新しいクエリを作成。"-"は降順
	q := datastore.NewQuery("PostApp").Order("-Posted").Limit(20)
	// 指定されたコンテキスト(q)でクエリを実行し、そのクエリに一致するすべてのキーを返し、dst(第2引数)に値を追
	keys, err := q.GetAll(ctx, &params.Posts)
	fmt.Fprintln(os.Stdout, "GetKeys:", keys)
	
	if err != nil {
		log.Errorf(ctx, "Getting posts: %v", err)
		params.Notice = "Cloudn't get latest posts. Refresh?"
		c.HTML(http.StatusInternalServerError, "home", gin.H{
			"params": params,
		})
		return
	}

	c.HTML(http.StatusOK, "home", gin.H{
		"params": params,
	})
}


func NewPost(c *gin.Context) {
	params := m.TemplateParams{}
	c.HTML(http.StatusOK, "form", gin.H{"params": params})
}

func ShowPost(c *gin.Context) {
	ctx := appengine.NewContext(c.Request)
	params := m.TemplateParams{}
	postKey := datastore.NewKey(ctx, "PostApp", )
}


func PostPost(c *gin.Context) {
	ctx := appengine.NewContext(c.Request)
	params := m.TemplateParams{}
	post := m.Post{
		Title:   c.PostForm("title"),
		Content: c.PostForm("content"),
		Author:  c.PostForm("author"),
		Posted:  time.Now(),
		UpdatedAt:  time.Now(),
	}

	// title
	if post.Title == "" {
		params.Notice = "Cannot post empty title"
		c.HTML(http.StatusBadRequest, "form", gin.H{"params": params})
		return
	}
	// Author
	if post.Author == "" {
		post.Author = "nanashinogonbei"
	}

	params.Title = post.Title
	params.Author = post.Author
	params.Posted = post.Posted
	// content
	params.Content = post.Content

	// エンティティのキーを自動生成
	key := datastore.NewIncompleteKey(ctx, "PostApp", nil)
	fmt.Fprintln(os.Stdout, "Key:", key)
	
	// 保存
	_, err := datastore.Put(ctx, key, &post)

	if err != nil {
		log.Errorf(ctx, "datastore.Put: %v", err)
		params.Notice = "Couldn't add new post. Try again??"
		c.HTML(http.StatusInternalServerError, "home", gin.H{
			"params": params,
		})
		return
	}

	// Postスライスにparams構造体のPostsを追加。
	params.Posts = append([]m.Post{post}, params.Posts...)

	c.Redirect(302, "/")
}





