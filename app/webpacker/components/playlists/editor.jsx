import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import Select from '../common/select'
import { humanized_size } from '../dumpster'
import CsrfToken from "../csrf_token"
import MediaItems from "./editor/media_items"

export default class Editor extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      playlist: props.js_data.playlist,

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
        <div className="section">
          <MediaItems js_data={this.props.js_data}/>
        </div>
        <div className="section">
          {this.saveButton()}
          {this.state.last_error !== null && this.errorNotificationComponent()}
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
      <div className="actions">
        <button className={btn_classes} disabled={this.state.saving} onClick={this.onSaveHandler}>{I18n.playlists.save}</button>
        <div>
          {this.state.save_ok && <em className="has-text-success">{I18n.playlists.save_successful}</em>}
        </div>
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

  onSaveHandler = () => {
    if (this.state.saving) {
      return
    }

    const data = {
      name: this.state.playlist.name,
      description: this.state.playlist.description,
      company_id: this.state.playlist.company.id,
      media_item_ids: []
    }
    this.saveRequest(data)
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
