import React, { Component } from 'react'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'

const FilesTable = ({ files, onMove, onRemove }) => {
  if (!files.length) return null

  return (
    <table className="table table-striped">
      <thead>
        <tr>
          <th>#</th>
          <th>File</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        {files.map((file, idx) => (
          <tr key={file.uuid}>
            <th scope="row">{idx + 1}</th>
            <td>{file.name}</td>
            <td>
              {idx !== 0 && (
                <button
                  type="button"
                  className="btn btn-link"
                  onClick={() => onMove(idx, idx - 1)}
                >
                  <FontAwesomeIcon icon="chevron-up" aria-hidden="true" />
                </button>
              )}
              {idx !== files.length - 1 && (
                <button
                  type="button"
                  className="btn btn-link"
                  onClick={() => onMove(idx, idx + 1)}
                >
                  <FontAwesomeIcon icon="chevron-down" aria-hidden="true" />
                </button>
              )}
              <button
                type="button"
                className="btn btn-link"
                onClick={() => onRemove(file)}
              >
                <FontAwesomeIcon icon="minus" aria-hidden="true" />
              </button>
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}

export default FilesTable
