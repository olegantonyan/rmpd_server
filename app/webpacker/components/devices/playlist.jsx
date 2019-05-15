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
    onAssigned: PropTypes.func.isRequired
  }

  constructor(props) {
    super(props)
    this.state = {
      selected_playlist: this.props.playlist === null ? NONE_PLAYLIST_PLACEHOLDER : this.props.playlist,
      saving: false,
      last_error: null,
      ok: false
    }
  }

  render() {
    let button = <span></span>
    if (this.props.playlist !== null && this.state.selected_playlist.id === this.props.playlist.id) {
    } else if (this.props.playlist === null && this.state.selected_playlist.id === NONE_PLAYLIST_PLACEHOLDER.id) {
    } else if (this.props.playlist !== null && this.state.selected_playlist.id === NONE_PLAYLIST_PLACEHOLDER.id) {
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
        {this.state.last_error !== null && this.errorNotificationComponent()}
        {this.state.ok && this.okNotificationComponent()}
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

  errorNotificationComponent = () => {
    return(
      <div className="notification is-danger">
        <button className="delete" onClick={() => this.setState({ last_error: null })}></button>
        {this.state.last_error}
      </div>
    )
  }

  okNotificationComponent = () => {
    return(
      <div className="notification is-success">
        {I18n.devices.playlist_assigned}
      </div>
    )
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
        this.setState({ last_error: json.error, selected_playlist: this.props.playlist === null ? NONE_PLAYLIST_PLACEHOLDER : this.props.playlist })
      } else {
        this.props.onAssigned(json)
        this.setState({ last_error: null, ok: true })
        setTimeout(() => this.setState({ ok: false }), 5000)
      }
    })
    .catch(e => {
      this.setState({ last_error: e.toString() })
    })
  }
}
