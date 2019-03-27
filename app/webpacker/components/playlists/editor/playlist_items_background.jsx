import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'

export default class PlaylistItemsBackground extends React.Component {
  static propTypes = {
    playlist_items: PropTypes.array.isRequired
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
          {i.media_item.file}
        </div>

        <div className="media-content">
        </div>

        <div className="media-right">
        </div>
      </div>
    )
  }
}
