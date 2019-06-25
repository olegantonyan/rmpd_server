import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'

export default class PlaylistItemsBackground extends React.Component {
  static propTypes = {
    playlist_items: PropTypes.array.isRequired,
    onDelete: PropTypes.func.isRequired,
  }

  render() {
    return(
      <div>
        {this.props.playlist_items.map(i => this.itemComponent(i))}
      </div>
    )
  }

  itemComponent = (i) => {
    return(
      <div className="media" key={i.media_item.id}>
        <div className="media-left">
          {this.itemText(i.media_item)}
        </div>

        <div className="media-content">
          <div className="tags">
            {this.itemTags(i.media_item)}
          </div>
        </div>

        <div className="media-right">
          <button className="button is-outlined is-small" onClick={() => this.props.onDelete(i)}>
            <span className="icon"><i className="fas fa-trash-alt"></i></span>
          </button>
        </div>
      </div>
    )
  }

  itemText = (item) => {
    let result = item.file
    if (item.description.length > 0) {
      result += ` (${item.description})`
    }
    return result
  }

  itemTags = (item) => {
    if (item.tags.length > 0) {
      return item.tags.map(tag => <span className="tag is-dark" key={tag.id}>{tag.name}</span>)
    } else {
      return <span></span>
    }
  }
}
