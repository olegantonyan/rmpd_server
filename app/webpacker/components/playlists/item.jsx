import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import { humanized_size } from '../dumpster'

export default class Item extends React.Component {
  static propTypes = {
    playlist: PropTypes.object.isRequired,
    js_data: PropTypes.object.isRequired
  }

  render() {
    return(
      <div className="media">
        <div className="media-left">
          <span className="icon"><i className="fas fa-music fa-2x"></i></span>
        </div>

        <div className="media-content">
          <div className="content">


            <nav className="level">
              <div className="level-left">
                <span className="level-item">
                  <h5 className="subtitle is-5">{this.props.playlist.name}</h5>
                </span>

                <span className="level-item">
                  <span className="icon"><i className="fas fa-compact-disc"></i></span>
                  {this.props.playlist.description}
                </span>

                <span className="level-item">
                  <span>{this.props.playlist.items_count} {I18n.playlists.files}</span>
                </span>

                <span className="level-item">
                  <span>{humanized_size(this.props.playlist.items_size)}</span>
                </span>

                <span className="level-item">
                  <span><span className="icon"><i className="fas fa-user-secret"></i></span>{this.props.playlist.company.title}</span>
                </span>
              </div>
            </nav>
          </div>
        </div>

        <div className="media-right">
          <nav className="level">
            <span className="level-item">

              <a className="button is-primary is-outlined" href={this.props.js_data.show_path.replace(":id", this.props.playlist.id)}>
                <span className="icon"><i className="fas fa-bars"></i></span>
              </a>

            </span>
          </nav>
        </div>
      </div>
   )
  }
}
