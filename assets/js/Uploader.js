import React, { Component } from 'react'
import Dropzone from 'react-dropzone'
import superagent from 'superagent'
import arrayMove from 'array-move'

import FilesTable from './FilesTable'

class Uploader extends Component {
  state = {
    tag: '',
    files: []
  }

  onDrop = files => {
    files.forEach(file => {
      const req = superagent.post('/media')

      req.attach('file', file)
      req.end((err, res) => {
        if (err) {
          return console.error(err)
        }

        this.setState(prevState => ({
          files: [...prevState.files, res.body]
        }))
      })
    })
  }

  onSave = () => {
    const { tag, files } = this.state
    const req = superagent.post('/playlists')

    req.send({ tag, files: files.map(f => f.name) }).then(this.back)
  }

  componentDidMount() {
    const { channel } = this.props

    channel.on('tag', ({ tag }) => {
      this.setState({ tag })
    })
  }

  // Normally you would want to split things out into separate components.
  // But in this example everything is just done in one place for simplicity
  render() {
    const { files, tag } = this.state

    return (
      <div>
        <div className="page-header">
          <h1>
            New Playlist <small>scan a token to start</small>
          </h1>
        </div>

        <div className="form-group">
          <label htmlFor="tag">RFID Tag</label>
          <input
            type="text"
            className="form-control-lg form-control-plaintext"
            readOnly
            value={tag}
          />
          <small id="emailHelp" className="form-text text-muted">
            Hold a RFID tag close the the RFID reader.
          </small>
        </div>

        <FilesTable
          files={files}
          onMove={(from, to) =>
            this.setState(prevState => ({
              files: arrayMove(prevState.files, from, to)
            }))
          }
          onRemove={item =>
            this.setState(({ files }) => ({
              files: files.filter(file => file !== item)
            }))
          }
        />

        <Dropzone className="dropzone" onDrop={this.onDrop}>
          <p>
            Try dropping some files here, or click to select files to upload.
          </p>
        </Dropzone>

        <p>
          <button
            type="button"
            className="btn btn-primary btn-lg"
            onClick={this.save}
          >
            Save
          </button>
          <button
            type="button"
            className="btn btn-default btn-lg"
            onClick={() => {
              window.location.pathname = '/'
            }}
          >
            Back
          </button>
        </p>
      </div>
    )
  }
}

export default Uploader
