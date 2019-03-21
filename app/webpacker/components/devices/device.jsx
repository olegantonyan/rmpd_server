import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import { humanized_size } from '../dumpster'
import LogMessages from './log_messages'

export default class Device extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  state = {
    show_webui_password: false
  }

  render() {
    return(
      <div>
        <nav className="level">
          <div className="level-item has-text-centered">
            <div>
              <span className="icon"><i className="fas fa-wifi"></i></span>
              <span>{this.props.js_data.device.online ? <b className="has-text-success">Online</b> : <b className="has-text-danger">Offline</b>}</span>
            </div>
          </div>

          <div className="level-item has-text-centered">
            <div>
              <p className="heading">{I18n.devices.now_playing}</p>
              <p>{this.props.js_data.device.now_playing}</p>
            </div>
          </div>
        </nav>

        <div className="columns">
          <div className="column">
            <table className="table box">
              <tbody>
                <tr>
                  <td>{I18n.devices.login}</td>
                  <td>{this.props.js_data.device.login}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.name}</td>
                  <td>{this.props.js_data.device.name}</td>
                </tr>
                <tr>
                  <td>{I18n.company}</td>
                  <td>{this.props.js_data.device.company !== null && this.props.js_data.device.company.title}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.playlist}</td>
                  <td>{this.props.js_data.device.playlist !== null && this.props.js_data.device.playlist.name}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.timezone}</td>
                  <td>{this.props.js_data.device.time_zone}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.devicetime}</td>
                  <td>{this.props.js_data.device.devicetime}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.poweredon_at}</td>
                  <td>{this.props.js_data.device.poweredon_at}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.free_space}</td>
                  <td>{humanized_size(this.props.js_data.device.free_space)}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div className="column">

          </div>
        </div>

        <h4 className="title is-4">{I18n.devices.log_messages.title}</h4>

        <LogMessages url={this.props.js_data.log_messages_path} />

        <div className="box">
          <a className="button" onClick={this.onShowWebUiPassword}>{I18n.devices.webui_password}</a>
          {this.state.show_webui_password && <pre>{this.props.js_data.device.webui_password}</pre>}
        </div>

      </div>
   )
  }

  onShowWebUiPassword = () => {
    this.setState({ show_webui_password: true })
    setTimeout(() => this.setState({ show_webui_password: false }), 5000)
  }
}
