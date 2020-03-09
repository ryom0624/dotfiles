module.exports = {
  publicPath: {
    publicPath: './'
  },
  css: {
    loaderOptions: {
      scss: {
        prependData: `@import "@/scss/style.scss";`
      }
    }
  }
};
