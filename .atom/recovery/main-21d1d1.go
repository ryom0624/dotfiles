package main

import (
	"github.com/gin-gonic/gin"
	"google.golang.org/appengine"
	"net/http"
	c "sample/controllers"
)

func main() {
	r := gin.Default()
	r.LoadHTMLGlob("views/*")
	r.GET("/", c.GetIndex)
	r.GET("/posts/new", c.NewPost)
	r.GET("/posts/show", c.ShowPost)
	r.POST("/post", c.PostPost)

	http.Handle("/", r)
	appengine.Main()
}
