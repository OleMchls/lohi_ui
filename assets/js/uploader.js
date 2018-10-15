import React from 'react'
import ReactDOM from 'react-dom'

import socket from "./socket"

ReactDOM.render(
  <h1>Hello World with JSX, Babel and Webapck</h1>,
  document.getElementById("upload")
);

let channel = socket.channel('tags:lobby', {})
debugger
