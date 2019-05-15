import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import Select from '../common/select'
import CsrfToken from "../csrf_token"

const NONE_PLAYLIST_PLACEHOLDER = { id: 0, name: I18n.devices.none_playlist }

export default class Playlist extends React.Component {
  static propTypes = {
    playlist: PropTypes.object,
    playlists: PropTypes.array.isRequired,
    playlist_assign_path: PropTypes.string.isRequired,
  }

  static defaultProps = {
    playlist: NONE_PLAYLIST_PLACEHOLDER
  }

  constructor(props) {
    super(props)
    this.state = {
      initial_playlist: this.props.playlist === null ? NONE_PLAYLIST_PLACEHOLDER : this.props.playlist,
      selected_playlist: this.props.playlist === null ? NONE_PLAYLIST_PLACEHOLDER : this.props.playlist,
      saving: false,
      last_error: null
    }
  }

  render() {
    let button;
    if (this.state.selected_playlist.id === this.state.initial_playlist.id) {
      button = <span></span>
    } else if (this.state.selected_playlist.id === NONE_PLAYLIST_PLACEHOLDER.id) {
      let btn_classes = "button is-danger"
      if (this.state.saving) {
        btn_classes += " is-loading"
      }
      button = <button className={btn_classes} onClick={this.onButtonClick}>{I18n.devices.remove_playlist}</button>
    } else {
      let btn_classes = "button is-primary"
      if (this.state.saving) {
        btn_classes += " is-loading"
      }
      button =<button className={btn_classes} onClick={this.onButtonClick}>{I18n.devices.assign_playlist}</button>
    }

    return(
      <div>
        <Select items={[NONE_PLAYLIST_PLACEHOLDER].concat(this.props.playlists)} value={this.state.selected_playlist} onSelect={this.onSelected} text_attr="name"/>
        {button}
      </div>
    )
  }

  onSelected = (item) => {
    this.setState({ selected_playlist: item })
  }

  onButtonClick = () => {
    if (this.state.saving) {
      return
    }
    this.setState({ saving: true })
    this.saveRequest(this.state.selected_playlist.id)
  }

  saveRequest = (playlist_id) => {
    const headers = new Headers()
    headers.append('Content-Type', 'application/json')
    headers.append('Accept', 'application/json')
    headers.append('X-CSRF-Token', CsrfToken.get())

    let ok = false
    fetch(this.props.playlist_assign_path, { method: 'PATCH', headers: headers, body: JSON.stringify({ playlist_id: playlist_id }) })
    .then(response => {
      ok = response.ok
      this.setState({ saving: false })
      return response.json()
    })
    .then(json => {
      if (!ok) {
        this.setState({ last_error: json.error })
      } else {
        this.setState({ last_error: null })
      }
    })
    .catch(e => {
      this.setState({ last_error: e.toString() })
    })
  }
}
