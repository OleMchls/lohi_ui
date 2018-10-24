// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.css'

import 'bootstrap'
import Dropzone from 'dropzone'
import ReactDOM from 'react-dom'
import React from 'react'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import 'phoenix_html'

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import channel from './socket'
import Uploader from './Uploader'

Dropzone.options.albumDropzone = {
  init: function() {
    this.on('success', function(file, response) {
      let fileSelect = document.getElementById('lohi_upload_files')
      fileSelect.options[fileSelect.options.length] = new Option(
        response.name,
        response.name,
        false,
        true
      )
    })
  }
}

library.add(fas)

ReactDOM.render(
  <Uploader channel={channel} />,
  document.getElementById('upload')
)
