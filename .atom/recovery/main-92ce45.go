package main

import (
	"github.com/gin-gonic/gin"
	c "sample/controllers"
  "net/http"
)

func main() {
	r := gin.Default()
	r.LoadHTMLGlob("views")
	r.GET("/", c.GetPosts)

  http.Handle("/", r)
	appengine.Main()
}
