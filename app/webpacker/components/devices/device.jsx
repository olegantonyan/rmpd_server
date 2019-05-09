import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import { humanized_size } from '../dumpster'
import LogMessages from './log_messages'

export default class Device extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      show_webui_password: false,
      device: props.js_data.device
    }
  }

  static propTypes = {
    js_data: PropTypes.object.isRequired,
    action_cable: PropTypes.object.isRequired
  }

  componentDidMount() {
    const component = this
    this.props.action_cable.subscriptions.create({ channel: "DevicesChannel", device_id: this.state.device.id }, {
      received(data) {
        component.setState({ device: data })
      }
    })
  }

  render() {
    return(
      <div>
        <nav className="level">
          <div className="level-item has-text-centered">
            <div>
              <span className="icon"><i className="fas fa-wifi"></i></span>
              <span>{this.state.device.online ? <b className="has-text-success">Online</b> : <b className="has-text-danger">Offline</b>}</span>
            </div>
          </div>

          <div className="level-item has-text-centered">
            <div>
              <p className="heading">{I18n.devices.now_playing}</p>
              <p>{this.state.device.now_playing}</p>
            </div>
          </div>
        </nav>

        <div className="columns">
          <div className="column">
            <table className="table box">
              <tbody>
                <tr>
                  <td>{I18n.devices.login}</td>
                  <td>{this.state.device.login}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.name}</td>
                  <td>{this.state.device.name}</td>
                </tr>
                <tr>
                  <td>{I18n.company}</td>
                  <td>{this.state.device.company !== null && this.state.device.company.title}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.playlist}</td>
                  <td>{this.state.device.playlist !== null && this.state.device.playlist.name}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.timezone}</td>
                  <td>{this.state.device.time_zone}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.devicetime}</td>
                  <td>{this.state.device.devicetime}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.poweredon_at}</td>
                  <td>{this.state.device.poweredon_at}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.free_space}</td>
                  <td>{humanized_size(this.state.device.free_space)}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.version}</td>
                  <td>{this.state.device.version}</td>
                </tr>
                <tr>
                  <td>{I18n.devices.ip_addr}</td>
                  <td><a href={"http://" + this.state.device.ip_addr} target="_blank">{this.state.device.ip_addr}</a></td>
                </tr>
              </tbody>
            </table>

            <div>
              <a className="button" onClick={this.onShowWebUiPassword}>{I18n.devices.webui_password}</a>
              {this.state.show_webui_password && <pre>{this.state.device.webui_password}</pre>}
            </div>

          </div>

          <div className="column">

          </div>
        </div>

        <h4 className="title is-4">{I18n.devices.log_messages.title}</h4>

        <LogMessages url={this.props.js_data.log_messages_path} device_id={this.state.device.id} action_cable={this.props.action_cable} />

      </div>
   )
  }

  onShowWebUiPassword = () => {
    this.setState({ show_webui_password: true })
    setTimeout(() => this.setState({ show_webui_password: false }), 5000)
  }
}
