import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'

export default class Item extends React.Component {
  static propTypes = {
    device: PropTypes.object.isRequired,
    js_data: PropTypes.object.isRequired
  }

  render() {
    return(
      <div className="media box">
        <div className="media-left">
          <span className="icon"><i className="fas fa-microchip fa-lg"></i></span>
          <nav className="level">
            <span className="level-item">
              {this.props.device.login}
            </span>
          </nav>
        </div>

        <div className="media-content">
          <div className="content">
            <h5 className="subtitle is-5">{this.props.device.name.length > 0 ? this.props.device.name : this.props.device.login}</h5>

            <nav className="level">
              <div className="level-left">
                <span className="level-item">
                  <span className="icon"><i className="fas fa-wifi"></i></span>
                  <span>{this.props.device.online ? <b className="has-text-success">Online</b> : <b className="has-text-danger">Offline</b>}</span>
                </span>

                <span className="level-item">
                  <span className="icon"><i className="fas fa-volume-up"></i></span>
                  {this.props.device.now_playing}
                </span>

                <span className="level-item">
                  {this.props.device.company !== null ? <span><span className="icon"><i className="fas fa-user-secret"></i></span>{this.props.device.company.title}</span> : <span><span className="icon"><i className="fas fa-link"></i></span>UNBOUND</span> }
                </span>
              </div>
            </nav>
          </div>
        </div>

        <div className="media-right">
          <nav className="level">
            <span className="level-item">

              <a className="button is-primary is-outlined" href={this.props.js_data.show_path.replace(":id", this.props.device.id)}>
                <span className="icon"><i className="fas fa-bars"></i></span>
              </a>

            </span>
          </nav>
        </div>
      </div>
   )
  }
}
