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
	ctx := appengine.NewContext(c.Request)
	params := m.TemplateParams{}
	q := datastore.NewQuery("PostApp").Order("-Posted").Limit(20)
	_, err := q.GetAll(ctx, &params.Posts)
	fmt.Fprintln(os.Stdout, "GetIndex params.Posts: ", params.Posts)
	if err != nil {
		log.Errorf(ctx, "Getting posts: %v", err)
		params.Notice = "Cloudmn't get latest posts. Refresh?"
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
		Updated:  time.Now(),
	}
	fmt.Fprintln(os.Stdout, "POSTDATA:", post)

	// title
	if post.Title == "" {
		params.Notice = "Cannnot post empty title"
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
	params.Notice = fmt.Sprintln("New Post Added!!")
	fmt.Fprintln(os.Stdout, "PostPost After append params.Posts: ", params.Posts)

	c.Redirect(302, "/")
}





