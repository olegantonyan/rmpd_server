import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'

export default class FormBackground extends React.Component {
  render() {
    return(
      <div></div>
    )
  }

  buildItems = (media_items) => {
    const playlist_items = media_items.map(i => {
      const playlist_item = {
        media_item: i,
        begin_time: '00:00:00',
        end_time: '23:59:59',
        begin_date: '01.01.1970',
        end_date: '19.01.2038',
        type: 'background'
       }
       return playlist_item
    })
    return playlist_items
  }
}
