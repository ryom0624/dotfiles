var glob = require("glob"),
  entriesJs = glob.sync("/Users/two_0002/git/rakuten/assets/src/javascripts/common.js"),
  path = require('path'),
  ExtractTextPlugin = require('extract-text-webpack-plugin');
module.exports = [{
    entry: entriesJs, //ビルドするファイル
    output: {
      path: '/Users/two_0002/git/rakuten/assets/javascripts', //ビルドしたファイルを吐き出す場所
      filename: 'app.js' //ビルドした後のファイル名
    },
    module: {
      rules: [{
        test: /\.js$/, //ビルド対象のファイルを指定
        loader: 'babel-loader', //loaderを指定
        exclude: /node_modules/, //ビルド対象に除外するファイルを指定
      }]
    }
  },
  {
    entry: {
      'style': '../rakuten/assets/src/sass/style.scss',
      'campaign': '../rakuten/assets/src/sass/campaign.scss',
      'landingpage': '../rakuten/assets/src/sass/landingpage.scss'
    },
    output: {
      path: path.join(__dirname, '../rakuten/assets/stylesheets'),
      filename: '[name].css'
    },
    module: {
      rules: [{
          test: /\.(scss|sass)$/i,
          loader: ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: [{
                loader: 'css-loader',
                options: {
                  url: false,
                  minimize: true,
                  sourceMap: true
                }
              },
              {
                loader: 'postcss-loader',
                options: {
                  plugins: (loader) => [
                    require('autoprefixer')()
                  ],
                  sourceMap: true
                }
              },
              {
                loader: 'sass-loader',
                options: {
                  outputStyle: 'compressed',
                  sourceMap: true
                }
              }
            ]
          })
        }
      ]
    },
    devtool: 'source-map',
    plugins: [
      new ExtractTextPlugin('[name].css')
    ]
  }
]