const merge = require('webpack-merge')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const CleanWebpackPlugin = require('clean-webpack-plugin')
const common = require('./webpack.common')

console.log('Building for Production...')

module.exports = merge(common, {
  mode: 'production',
  output: { filename: '[name]-[hash].js' },
  plugins: [
    new CleanWebpackPlugin(['dist'], {
      root: __dirname,
      exclude: [],
      verbose: true,
      dry: false,
    }),
    new CopyWebpackPlugin([{ from: 'public' }]),
  ],
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: {
          loader: 'elm-webpack-loader',
          options: { optimize: true },
        },
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ['css-loader?url=false'],
      },
    ],
  },
})
