import React from 'react'
import PropTypes from 'prop-types'
import { seconds_to_string } from '../dumpster'

export default class PlayerControls extends React.Component {
  static propTypes = {
    playing_now: PropTypes.object.isRequired,
    onPause: PropTypes.func.isRequired
  }

  render() {
    return (
      <article className="message is-primary">
        <div className="message-body">

          <div className="columns">
            <div className="column is-narrow">
              <span className="icon" onClick={this.props.onPause}>
                <i className="fas fa-pause-circle fa-2x"></i>
              </span>
            </div>
            <div className="column is-narrow">
              <strong>{this.props.playing_now.item.file}</strong>
            </div>

            <div className="column">
              <div className="columns">
                <div className="column is-narrow">
                  <span>{seconds_to_string(this.props.playing_now.current)}</span>
                </div>

                <div className="column">
                  <progress className="progress is-small is-primary" max={this.props.playing_now.total} value={this.props.playing_now.current}></progress>
                </div>

                <div className="column is-narrow">
                  <span>{seconds_to_string(this.props.playing_now.total)}</span>
                </div>
              </div>

            </div>

          </div>

        </div>
      </article>
    )
  }
}
