const { environment } = require('@rails/webpacker')
const sharedConfig = require('./shared')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.config.merge(sharedConfig)
module.exports = environment
