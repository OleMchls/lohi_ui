import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

library.add(fas)

class Player extends Component {
  constructor (props) {
    super(props)
    this.state = {
      current: "",
      next: [],
      status: "pause",
      volume: 0
    }
  }

  update (event) {
    console.log(event);
    this.setState({
      current: event.current_song ? event.current_song.Title : "",
      next: event.queue.map((item) => { return item.Title }),
      status: event.status.state,
      volume: event.status.volume
    })
  }

  render () {
    return (
      <div>
        <div className='page-header'>
          <h3>{this.state.current} <small>{this.state.status}</small></h3>
          <small>
            { this.state.next.length > 1 ? `Next: ${this.state.next[1]} (+${this.state.next.length - 2})` : "" }
          </small>
          <p>Volume: {this.state.volume}</p>
        </div>
      </div>
    )
  }
}

export default document.getElementById('player') ? ReactDOM.render(<Player />, document.getElementById('player')) : null
