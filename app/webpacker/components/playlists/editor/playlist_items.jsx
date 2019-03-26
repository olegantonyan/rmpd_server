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
        {this.props.media_items.map(i => <span>{i.file}</span>)}
      </div>
    )
  }
}
