module.exports = {
  public
  css: {
    loaderOptions: {
      scss: {
        prependData: `@import "@/scss/style.scss";`
      }
    }
  }
};
