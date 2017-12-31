/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue'

Vue.use(TurbolinksAdapter)

var vms = []

document.addEventListener('turbolinks:load', () => {
  vms.push(
    new Vue({
      el: '#hello',
      data: {
        message: "Can you say hello?"
      },
      components: { App }
    })
  )
})

document.addEventListener('turbolinks:visit', () => {
  for (let vm of vms) {
    vm.$destroy()
  }
  vms = []
})
