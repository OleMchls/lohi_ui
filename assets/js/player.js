import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

import channel from './socket'

library.add(fas)

class Player extends Component {
  constructor (props) {
    super(props)
    this.state = {
      current: "",
      next: [],
      status: "pause",
      volume: 0,
      max_volume: 100
    }
  }

  update (event) {
    console.debug(event);
    this.setState({
      current: event.current_song ? event.current_song.Title : "",
      next: event.queue.map((item) => { return item.Title }),
      status: event.status.state,
      volume: event.status.volume + 1,
      max_volume: event.max_volume
    })
  }

  ctrl (ctrl) {
    channel.push('ctrl', ctrl)
  }

  max_volume (e) {
    channel.push('ctrl', { action: 'max_volume', max: e.target.value })
  }

  render () {
    return (
        <div className='page-header'>
          <h3>{this.state.current} <small>{this.state.status}</small></h3>
          <small>
            { this.state.next.length > 1 ? `Next: ${this.state.next[1]} (+${this.state.next.length - 2})` : "" }
          </small>
          <p>Volume: {this.state.volume}</p>
          <div className="row justify-content-center">
            <div className="input-group col-lg-4">
            <div className="btn-group" role="group" aria-label="Basic example">
                <button type="button" className="btn btn-secondary" onClick={() => this.ctrl({ action: 'play' })}>Play</button>
                <button type="button" className="btn btn-secondary" onClick={() => this.ctrl({ action: 'skip' })}>Skip</button>
                <button type="button" className="btn btn-secondary" onClick={() => this.ctrl({ action: 'vol_up' })}>Volume +</button>
                <button type="button" className="btn btn-secondary" onClick={() => this.ctrl({ action: 'vol_down' })}>Volume -</button>
              </div>
            </div>
          </div>

          <div className="row justify-content-center">
            <div className="input-group col-lg-4">
              <div className="input-group-prepend">
                <div className="input-group-text" id="btnGroupAddon">Max Volume</div>
              </div>
              <input type="text" className="form-control" placeholder={`Max Volue (${this.state.max_volume})`} onBlur={this.max_volume}></input>
            </div>
          </div>
        </div>
    )
  }
}

export default document.getElementById('player') ? ReactDOM.render(<Player />, document.getElementById('player')) : null
