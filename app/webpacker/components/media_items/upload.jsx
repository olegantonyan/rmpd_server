import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import TagsSelect from './tags_select'
import Select from '../common/select'
import UploadService from '../upload_service'
import CsrfToken from "../csrf_token"
import { humanized_size } from '../dumpster'

export default class Upload extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  state = {
    uploading: false,
    progress: 0,
    total: 0,
    lock_start : false,
    error: null,

    selected_tags: [],
    selected_company: this.props.js_data.companies[0],
    selected_type: "background",
    selected_library: "personal",
    selected_skip_volume_normalization: false,
    selected_description: "",
    selected_files: []
  }

  service = new UploadService(this.props.js_data.upload_path)

  render() {
    return(
      <div>
        <div className="columns">
          <div className="column is-one-third">
            {this.fileInput()}

            {this.descriptionInput()}

            {this.props.js_data.companies.length > 1 && this.companyInput()}

            {this.typeInput()}

            {this.props.js_data.current_user.root && this.libraryInput()}

            {this.volumeNormalizationInput()}

            {this.tagsInput()}
          </div>

          <div className="column">

            <div className="columns">
              <div className="column is-narrow">
                {this.state.selected_files.length > 0 && this.startUploadInput()}
              </div>
              <div className="column">
                <progress className="progress is-primary is-large" value={this.state.progress} max={this.state.total}></progress>
              </div>

              <div className="column is-narrow">
                { this.state.uploading &&
                  <a className="button is-danger is-outlined is-small is-rounded" onClick={this.service.cancel}>
                    <span className="icon"><i className="fas fa-ban"></i></span>
                    <span>{I18n.cancel}</span>
                  </a>
                }
              </div>
           </div>

           {this.state.error &&
             <div className="notification is-danger">
               {this.state.error}
             </div>
           }

            <table className="table is-fullwidth">
              <thead>
                <tr>
                  <th>{I18n.media_items.file_name}</th>
                  <th>{I18n.media_items.file_size}</th>
                  <th>{I18n.media_items.progress}</th>
                </tr>
              </thead>
              <tbody>
                {this.state.selected_files.map((f) => this.fileComponent(f))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    )
  }

  descriptionInput = () => {
    return (
      <div className="field">
        <label className="label">{I18n.media_items.description}</label>
        <div className="control">
          <input className="input" type="text" placeholder="" disabled={this.state.uploading} value={this.state.selected_description} onChange={(ev) => this.setState({ selected_description: ev.target.value})} />
        </div>
      </div>
    )
  }

  tagsInput = () => {
    return (
      <div>
        <TagsSelect tags={this.props.js_data.tags} selected_tags={this.state.selected_tags} onSelect={this.onTagSelect} onDelete={this.onTagDelete} disabled={this.state.uploading} />
      </div>
    )
  }

  companyInput = () => {
    return (
      <div className="field">
        <label className="label">{I18n.company}</label>
        <div className="control">
          <Select items={this.props.js_data.companies} value={this.state.selected_company} onSelect={(comp) => this.setState({ selected_company: comp })} disabled={this.state.uploading} />
        </div>
      </div>
    )
  }

  typeInput = () => {
    return (
      <div className="field">
        <label className="label">{I18n.media_items.type}</label>
        <div className="control">
          <label className="radio">
            <input type="radio" name="mediaitems_type" checked={this.state.selected_type === "background"} disabled={this.state.uploading} onChange={() => this.setState({ selected_type: "background" })} />
            {I18n.media_items.background}
          </label>
          <label className="radio">
            <input type="radio" name="mediaitems_type" checked={this.state.selected_type === "advertising"} disabled={this.state.uploading} onChange={() => this.setState({ selected_type: "advertising" })} />
            {I18n.media_items.advertising}
          </label>
        </div>
      </div>
    )
  }

  libraryInput = () => {
    return(
      <div className="field">
        <label className="label">{I18n.media_items.library}</label>
        <div className="control">
          <div className="select">
            <select value={this.selected_library} onChange={this.onLibrarySelectHandler}>
              <option data-id="personal">{I18n.media_items.personal}</option>
              <option data-id="standard">{I18n.media_items.standard}</option>
              <option data-id="premium">{I18n.media_items.premium}</option>
            </select>
          </div>
        </div>
      </div>
    )
  }

  volumeNormalizationInput = () => {
    return(
      <div className="field">
        <label className="checkbox">
          <input type="checkbox" disabled={this.state.uploading} onChange={(ev) => this.setState({ selected_skip_volume_normalization: ev.target.checked })} />
          {I18n.media_items.skip_volume_normalization}
        </label>
      </div>
    )
  }

  fileInput = () => {
    return (
      <div className="field">
        <div className="file">
          <label className="file-label">
            <input className="file-input" type="file" name="file" multiple={true} onChange={this.onFilesSelected} disabled={this.state.uploading} accept="audio/mpeg" />
            <span className="file-cta">
              <span className="file-icon">
                <i className="fas fa-upload"></i>
              </span>
              <span className="file-label">
                {I18n.media_items.add_files}
              </span>
            </span>
          </label>

          {this.state.selected_files.length > 0 &&
            <a className="button is-danger is-outlined" disabled={this.state.uploading} onClick={this.clearHandler}>
              <span className="icon"><i className="fas fa-trash-alt"></i></span>
              <span>{I18n.media_items.clear_selected}</span>
            </a>}
        </div>
      </div>
    )
  }

  startUploadInput = () => {
    let btn_classes = "button is-primary"
    if (this.state.uploading) {
      btn_classes += " is-loading"
    }
    return (
      <div className="field">
        <a className={btn_classes} onClick={this.startUploadHandler} disabled={this.state.uploading || this.state.lock_start}>{I18n.media_items.start_upload}</a>
      </div>
    )
  }

  startUploadHandler = () => {
    if (this.state.uploading || this.state.lock_start) {
      return
    }
    const callbacks = {
      ondoneall: this.ondoneall,
      ondonesingle: this.ondonesingle,
      onprogressall: this.onprogressall,
      onprogresssingle: this.onprogresssingle,
      onerror: this.onerror,
      oncancel: this.oncancel
    }
    this.service.run(this.state.selected_files.map(f => f.file), callbacks)
    this.setState({ uploading: true, lock_start: true })
  }

  fileComponent = (f) => {
    return (
      <tr key={f.file.name}>
        <td>{f.file.name}</td>
        <td>{humanized_size(f.file.size)}</td>
        <td>
          {f.error === null ?
            <progress className="progress is-primary" value={f.progress} max={f.total}></progress>
            :
            <i className="has-text-danger fas fa-exclamation-triangle"></i>
          }
        </td>
      </tr>
    )
  }

  onLibrarySelectHandler = (ev) => {
    for (let node of ev.target.children) {
      if (node.value === ev.target.value) {
        const id = node.getAttribute('data-id')
        this.setState({ selected_library: id })
        this.fetchItems(0, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, id, this.state.selected_library)
        return
      }
    }
  }

  clearHandler = () => {
    if (this.state.uploading) {
      return
    }
    this.setState({ selected_files: [], progress: 0, total: 0, lock_start: false, error: null })
  }

  onFilesSelected = (ev) => {
    if (this.state.uploading) {
      return
    }

    let files = []
    for (let i = 0; i < ev.target.files.length; i++) {
      const sf = new SelectedFile(ev.target.files[i])
      files.push(sf)
    }
    this.setState({ selected_files: files, progress: 0, total: 0 })
  }

  onTagSelect = (tag_id) => {
    if (this.state.uploading) {
      return
    }

    const new_tags = [...this.state.selected_tags, this.props.js_data.tags.find(t => t.id.toString() === tag_id.toString()) ]
    this.setState({ selected_tags: new_tags})
  }

  onTagDelete = (tag_id) => {
    if (this.state.uploading) {
      return
    }

    const new_tags = this.state.selected_tags.filter(t => t.id.toString() !== tag_id.toString()).slice()
    this.setState({ selected_tags: new_tags })
  }

  ondonesingle = (file, uuid) => {
    const headers = new Headers()
    headers.append('Content-Type', 'application/json')
    headers.append('Accept', 'application/json')
    headers.append('X-CSRF-Token', CsrfToken.get())

    const data = {
      media_item: {
        description:                this.state.selected_description,
        company_id:                 this.state.selected_company.id,
        type:                       this.state.selected_type,
        library:                    this.state.selected_library,
        skip_volume_normalization:  this.state.selected_skip_volume_normalization,
        tag_ids:                    this.state.selected_tags.map(t => t.id)
      },
      upload: {
        upload_uuid:                uuid,
        upload_filename:            file.name,
        upload_content_type:        file.type
      }
    }

    let ok = false
    fetch(this.props.js_data.create_path, { method: 'POST', headers: headers, body: JSON.stringify(data) })
    .then(response => {
      ok = response.ok
      return response.json()
    })
    .then(json => {
      if (!ok) {
        this.onerror(json.error, file, uuid)
      }
    })
    .catch((e) => this.onerror(e, file, uuid))
  }

  ondoneall = () => {
    //console.info("all done")
    this.setState({ uploading: false })
  }

  onerror = (message, file, uuid) => {
    //this.service.cancel() // just in case this was an error not with upload itself
    this.setState({ error: `${I18n.error}: ${file.name} (${uuid}): ${message}`, uploading: false })

    const selected_files_copy = [...this.state.selected_files]
    const files = selected_files_copy.map(f => {
      if (file.name === f.file.name) {
        f.progress = 0
        f.total = 0
        f.error = message
      }
      return f
    })
    this.setState({ selected_files: files })
  }

  onprogresssingle = (file, uuid, value, total) => {
    //console.info(`progress ${file.name} (${uuid}): ${value}/${total}`)
    const selected_files_copy = [...this.state.selected_files]
    const files = selected_files_copy.map(f => {
      if (file.name === f.file.name) {
        f.progress = value
        f.total = total
      }
      return f
    })
    this.setState({ selected_files: files })
  }

  onprogressall = (value, total) => {
    //console.info(`progressall ${value}/${total}`)
    this.setState({ progress: value, total: total })
  }

  oncancel = () => {
    //console.info("canceled")
    this.setState({ uploading: false })
  }
}

class SelectedFile {
  constructor(file) {
    this.file = file
    this.progress = 0
    this.total = 0
    this.error = null
  }
/*
  done = () => {
    return this.total > 0 && this.total == this.progress
  }*/
}
