import React from 'react'
import { render, fireEvent, cleanup } from 'react-testing-library'
import FilesTable from '../FilesTable'

const renderTable = (overrides = {}) => {
  const props = {
    files: [{ uuid: 1, name: 'file_1' }, { uuid: 2, name: 'file_2' }],
    onMove: jest.fn().mockName('onMove'),
    onRemove: jest.fn().mockName('onRemove'),
    ...overrides
  }

  return { ...render(<FilesTable {...props} />), props }
}

afterEach(cleanup)

it('renders null with no files provided', () => {
  const { container } = renderTable({ files: [] })

  expect(container).toBeEmpty()
})

it('renders a table with 2 files', () => {
  const { container } = renderTable()

  expect(container).toMatchSnapshot()
})

it('moves an item up and down', () => {
  const {
    getByTitle,
    props: { onMove }
  } = renderTable()

  fireEvent.click(getByTitle('move file_1 down'))
  expect(onMove).toHaveBeenCalledWith(0, 1)

  fireEvent.click(getByTitle('move file_2 up'))
  expect(onMove).toHaveBeenCalledWith(1, 0)
})

it('deletes an item', () => {
  const {
    getByTitle,
    props: { onRemove }
  } = renderTable()

  fireEvent.click(getByTitle('remove file_1'))

  expect(onRemove).toHaveBeenCalledWith({ uuid: 1, name: 'file_1' })
})
