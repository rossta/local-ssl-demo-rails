const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', {
  test: /\.vue$/,
  use: [{
    loader: 'vue-loader',
    options: {
      hotReload: false,
    },
  }],
})

environment.loaders.append('vue', vue)
module.exports = environment
