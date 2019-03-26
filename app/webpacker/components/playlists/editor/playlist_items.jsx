import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'

export default class PlaylistItems extends React.Component {
  static propTypes = {
    media_items: PropTypes.array.isRequired
  }

  render() {
    console.log(this.props.media_items)
    return(
      <div>
        {this.props.media_items.map(i => this.itemComponent(i))}
      </div>
    )
  }

  itemComponent = (i) => {
    return(
      <div className="media" key={i.id}>
        <div className="media-left">
          {i.file}
        </div>

        <div className="media-content">
        </div>

        <div className="media-right">
        </div>
      </div>
    )
  }
}
