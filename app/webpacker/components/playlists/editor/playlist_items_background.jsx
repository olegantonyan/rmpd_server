import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'

export default class PlaylistItemsBackground extends React.Component {
  static propTypes = {
    playlist_items: PropTypes.array.isRequired,
    onDelete: PropTypes.func.isRequired,
  }

  state = {
    selected_items: [],
  }

  render() {
    return(
      <div className="card">
        <header className="card-header">
          <p className="card-header-title">
            {I18n.playlists.files_in_playlist} ({I18n.media_items.background})
          </p>

          <div>
            {this.state.selected_items.length > 0 && <button className="button is-small is-danger is-outlined" onClick={this.onDeleteSelected}>
              <span>{I18n.media_items.delete_selected}</span>
            </button>}

            <button className="button is-small is-outlined" onClick={this.onSelectAll}>
              <span>{I18n.media_items.select_all}</span>
            </button>
          </div>

        </header>
        <div className="card-content">
          <div className="content">
          <table className="table is-narrow is-hoverable is-fullwidth">
            <tbody>
              {this.props.playlist_items.map(i => this.itemComponent(i))}
            </tbody>
          </table>
          </div>
        </div>
      </div>
    )
  }

  itemComponent = (i) => {
    return(
      <tr key={i.media_item.id}>
        <td>
          {i.media_item.file}
        </td>

        <td>
          {i.media_item.description}
        </td>

        <td>
          <div className="tags">
            {this.itemTags(i.media_item)}
          </div>
        </td>

        <td>
          <input type="checkbox" checked={this.state.selected_items.map(j => j.media_item.id).includes(i.media_item.id)} onChange={(ev) => this.onItemSelectChanged(ev.target.checked, i)}/>
        </td>
      </tr>
    )
  }

  itemTags = (item) => {
    if (item.tags.length > 0) {
      return item.tags.map(tag => <span className="tag is-dark" key={tag.id}>{tag.name}</span>)
    } else {
      return <span></span>
    }
  }

  onItemSelectChanged = (checked, item) => {
    if (checked) {
      this.setState({ selected_items: [...this.state.selected_items, item] })
    } else {
      const new_items = this.state.selected_items.filter(i => i.id !== item.id).slice()
      this.setState({ selected_items: new_items })
    }
  }

  onSelectAll = () => {
    if (this.state.selected_items.length === 0) {
      this.setState({ selected_items: [...this.props.playlist_items] })
    } else {
      this.setState({ selected_items: [] })
    }
  }

  onDeleteSelected = () => {
    this.props.onDelete(this.state.selected_items)
    this.setState({ selected_items: [] })
  }
}
