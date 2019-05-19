import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import Dropzone from 'react-dropzone'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import superagent from 'superagent'
import arrayMove from 'array-move'
import sortBy from 'sort-by'

library.add(fas)

class Uploader extends Component {
  constructor (props) {
    super(props)
    this.state = {
      tag: '',
      files: []
    }
  }

  tag (tag) {
    this.setState({
      tag: tag
    })
  }

  onDrop (files) {
    files.forEach(file => {
      const req = superagent.post('/media')
      req.attach('file', file)
      req.end((err, res) => {
        if (err) { return console.error(err) }
        this.setState(prevState => ({
          files: [
            ...prevState.files,
            res.body
          ]
        }))
      })
    })
  }

  move (from, to) {
    this.setState(prevState => ({
      files: arrayMove(prevState.files, from, to)
    }))
  }

  remove (item) {
    this.setState(prevState => ({
      files: prevState.files.filter(x => x !== item)
    }))
  }

  sort () {
    this.setState(prevState => ({
      files: prevState.files.sort(sortBy("name"))
    }))
  }

  save () {
    const req = superagent.post('/playlists')
    req.send({ tag: this.state.tag, files: this.state.files.map(f => f.name) })
      .then(this.back)
  }

  back () {
    window.location.pathname = '/'
  }

  // Normally you would want to split things out into separate components.
  // But in this example everything is just done in one place for simplicity
  render () {
    let table

    if (this.state.files.length > 0) {
      table = <table className='table table-striped'>
        <thead>
          <tr>
            <th>#</th>
            <th>File</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {
            this.state.files.map((f, i) =>
              <tr key={f.uuid}>
                <th scope='row'>{i + 1}</th>
                <td>{f.name}</td>
                <td>
                  {i !== 0 &&
                    <button type='button' className='btn btn-link' onClick={() => this.move(i, i - 1)} ><FontAwesomeIcon icon='chevron-up' aria-hidden='true' /></button>
                  }
                  {i !== this.state.files.length - 1 &&
                    <button type='button' className='btn btn-link' onClick={() => this.move(i, i + 1)}><FontAwesomeIcon icon='chevron-down' aria-hidden='true' /></button>
                  }
                  <button type='button' className='btn btn-link' onClick={() => this.remove(f)}><FontAwesomeIcon icon='minus' aria-hidden='true' /></button>
                </td>
              </tr>
            )
          }
        </tbody>
      </table>
    }

    return (
      <div>
        <div className='page-header'>
          <h1>New Playlist <small>scan a token to start</small></h1>
        </div>

        <div className='form-group'>
          <label htmlFor='tag'>RFID Tag</label>
          <input type='text' className='form-control-lg form-control-plaintext' readOnly value={this.state.tag} />
          <small id='emailHelp' className='form-text text-muted'>Hold a RFID tag close the the RFID reader.</small>
        </div>

        {table}

        <Dropzone className='dropzone' onDrop={this.onDrop.bind(this)}>
          <p>Try dropping some files here, or click to select files to upload.</p>
        </Dropzone>

        <div>
          <button type='button' className='btn btn-outline-secondary btn-lg' onClick={() => this.sort()}>Sort</button>
          <button type='button' className='btn btn-primary btn-lg' onClick={() => this.save()}>Save</button>
          <button type='button' className='btn btn-default btn-lg' onClick={() => this.back()}>Back</button>
        </div>
      </div>
    )
  }
}

export default ReactDOM.render(
  <Uploader />,
  document.getElementById('upload')
)
