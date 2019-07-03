import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import Select from '../common/select'
import { humanized_size } from '../dumpster'
import CsrfToken from "../csrf_token"
import MediaItems from "./editor/media_items"
import PlaylistItemsBackground from "./editor/playlist_items_background"
import PlaylistItemsAdvertising from "./editor/playlist_items_advertising"

export default class Editor extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      playlist: props.js_data.playlist,

      max_position: Math.max(Math.max(...props.js_data.playlist.playlist_items.map(i => i.position)), 0),

      saving: false,
      last_error: null,
      save_ok: false
    }
  }

  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  render() {
    return(
      <div>
        {this.nameInput()}
        {this.descriptionInput()}
        {this.props.js_data.companies.length > 1 && this.companySelect()}

        {this.saveButton()}

        <div className="section">

          <div className="columns">

            <div className="column">
              <PlaylistItemsBackground playlist_items={this.state.playlist.playlist_items.filter(i => i.type === "background")} onDelete={this.onDeleteItems} />
            </div>

            <div className="column">
              <PlaylistItemsAdvertising playlist_items={this.state.playlist.playlist_items.filter(i => i.type === "advertising")} onDelete={this.onDeleteItems} />
            </div>

          </div>

        </div>

        <div className="section">
          <h5 className="title is-5">{I18n.playlists.add_new_files}</h5>
          <MediaItems js_data={this.props.js_data} onAdd={this.onAddItems} can_add_advertising={this.canAddAdvertising()}/>
        </div>

        <div className="section">
          {this.saveButton()}
        </div>
      </div>
   )
  }

  nameInput = () => {
    return(
      <div className="field is-horizontal">
        <div className="field-label is-normal">
          <label className="label">{I18n.playlists.name}</label>
        </div>
        <div className="field-body">
          <div className="field">
            <p className="control">
              <input className="input"
                     type="text"
                     value={this.state.playlist.name}
                     onChange={e => this.setState({ playlist: { ...this.state.playlist, name: e.target.value } })} />
            </p>
          </div>
        </div>
      </div>
    )
  }

  descriptionInput = () => {
    return(
      <div className="field is-horizontal">
        <div className="field-label is-normal">
          <label className="label">{I18n.playlists.description}</label>
        </div>
        <div className="field-body">
          <div className="field">
            <p className="control">
              <input className="input"
                     type="text"
                     value={this.state.playlist.description}
                     onChange={e => this.setState({ playlist: { ...this.state.playlist, description: e.target.value } })} />
            </p>
          </div>
        </div>
      </div>
    )
  }

  companySelect = () => {
    return(
      <div className="field is-horizontal">
        <div className="field-label is-normal">
          <label className="label">{I18n.company}</label>
        </div>
        <div className="field-body">
          <div className="field">
            <div className="control">
              <Select items={this.props.js_data.companies}
                      value={this.state.playlist.company}
                      onSelect={comp => this.setState({ playlist: { ...this.state.playlist, company: comp } })} />
            </div>
          </div>
        </div>
      </div>
    )
  }

  saveButton = () => {
    let btn_classes = "button is-link"
    if (this.state.saving) {
      btn_classes += " is-loading"
    }
    return(
      <div>
        <div className="actions">
          <button className={btn_classes} disabled={this.state.saving} onClick={this.onSaveHandler}>{I18n.playlists.save}</button>
          <div>
            {this.state.save_ok && <em className="has-text-success">{I18n.playlists.save_successful}</em>}
          </div>
        </div>
        {this.state.last_error !== null && this.errorNotificationComponent()}
      </div>
    )
  }

  errorNotificationComponent = () => {
    return(
      <div className="notification is-danger">
        <button className="delete" onClick={() => this.setState({ last_error: null })}></button>
        {this.state.last_error}
      </div>
    )
  }

  onAddItems = (playlist_items) => {
    const existing_items_ids = this.state.playlist.playlist_items.map(i => i.media_item.id.toString())
    let new_playlist_items = []
    let position_increase = 0

    const max_ad = Math.max(this.props.js_data.max_advertising_items - this.advertisingCount(), 0)
    let ad_count = 0

    playlist_items.forEach((item, _idx) => {

      if (!existing_items_ids.includes(item.media_item.id.toString())) {
        if (item.type == "background") {
          const playlist_item = { ...item, position: this.state.max_position + position_increase }
          new_playlist_items.push(playlist_item)
          position_increase += 1
        } else if (item.type == "advertising" && ad_count < max_ad) {
          const playlist_item = { ...item }
          new_playlist_items.push(playlist_item)
          ad_count += 1
        }
      }
    })

    this.setState({
      playlist: { ...this.state.playlist, playlist_items: [...this.state.playlist.playlist_items, ...new_playlist_items] },
      max_position: this.state.max_position + position_increase
    })
  }

  onDeleteItems = (items) => {
    const items_ids = items.map(i => i.media_item.id.toString())
    const new_items = this.state.playlist.playlist_items.filter(i => !items_ids.includes(i.media_item.id.toString())).slice()
    this.setState({
      playlist: { ...this.state.playlist, playlist_items: new_items },
    })
  }

  onSaveHandler = () => {
    if (this.state.saving) {
      return
    }

    const playlist_items = [...this.state.playlist.playlist_items].map(i => {
      i.media_item_id = i.media_item.id
      const { schedule, media_item, ...new_i } = i
      return new_i
    })

    const data = {
      name: this.state.playlist.name,
      description: this.state.playlist.description,
      company_id: this.state.playlist.company.id,
      playlist_items: playlist_items,
      shuffle: this.state.playlist.shuffle
    }
    this.saveRequest(data)
  }

  canAddAdvertising = () => {
    return this.advertisingCount() < this.props.js_data.max_advertising_items
  }

  advertisingCount = () => {
    return this.state.playlist.playlist_items.filter(i => i.type === "advertising").length
  }


  saveRequest = (data) => {
    this.setState({ saving: true })

    const headers = new Headers()
    headers.append('Content-Type', 'application/json')
    headers.append('Accept', 'application/json')
    headers.append('X-CSRF-Token', CsrfToken.get())

    let path = this.props.js_data.create_path
    let method = 'POST'
    if (this.state.playlist.id !== null && this.state.playlist.id !== undefined) {
      path = this.props.js_data.update_path
      method = 'PATCH'
    }

    let ok = false
    fetch(path, { method: method, headers: headers, body: JSON.stringify({ playlist: data }) })
    .then(response => {
      ok = response.ok
      this.setState({ saving: false })
      return response.json()
    })
    .then(json => {
      if (!ok) {
        this.setState({ last_error: json.error })
      } else {
        this.setState({ last_error: null, save_ok: true, playlist: json })
        setTimeout(() => this.setState({ save_ok: false }), 10000)
        if (method === 'POST') {
          setTimeout(() => window.location.replace(this.props.js_data.edit_path.replace(":id", json.id)), 500)
        }
      }
    })
    .catch(e => {
      this.setState({ last_error: e.toString() })
    })
  }
}
