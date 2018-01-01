/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue'

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    data: {
      tracks: []
    },
    mounted: function() {
      const trackField = document.getElementById('track-field')
      if (!trackField) {
        this.tracks.push({
          title: '',
          id: null
        })
        return
      }
      const model = JSON.parse(trackField.dataset.vueModel)
      for (let track of model.tracks) {
        this.tracks.push({
          id: track.id,
          title: track.title
        })
      }
    },
    methods: {
      addTrack: function() {
        this.tracks.push({
          title: '',
          id: null
        })
      },
      removeTrack: function(index) {
        this.tracks.splice(index, 1)
      }
    }
  })
})
