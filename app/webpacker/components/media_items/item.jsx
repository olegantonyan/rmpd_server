import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import { seconds_to_string } from '../dumpster'

export default class Item extends React.Component {
  static propTypes = {
    item: PropTypes.object.isRequired,
    onPlayPause: PropTypes.func.isRequired,
    playing: PropTypes.bool.isRequired,
    onProgress: PropTypes.func
  }

  constructor(props) {
    super(props);
    this.audio = new Audio()
    this.audio.preload = "none"
    this.audio.src = this.props.item.file_url
    this.audio.addEventListener('ended', (e) => {
      this.props.onPlayPause(this.props.item, this.audio)
    })
    this.audio.addEventListener('timeupdate', (e) => {
      if (this.props.onProgress !== null && this.props.onProgress !== undefined) {
        this.props.onProgress(e.target.currentTime, e.target.duration)
      }
    })
  }

  render() {
    const tags = this.props.item.tags.map((tag) =>
      <span className="tag is-dark" key={tag.id}>{tag.name}</span>
    );

    return(
      <div className="media">
        <div className="media-left">
          <span className="icon" onClick={() => this.props.onPlayPause(this.props.item, this.audio)}>
            {this.props.playing ? <i className="fas fa-pause fa-lg"></i> : <i className="fas fa-play fa-lg"></i>}
          </span>

          <nav className="level">
            <span className="level-item">
              {seconds_to_string(this.props.item.duration)}
            </span>
          </nav>
        </div>

        <div className="media-content">
          <div className="content">
            <h5 className="subtitle is-5">{this.props.item.file}</h5>
          </div>

          <nav className="level">
            <div className="level-left">

              <span className="level-item">
                {this.props.item.description}
              </span>

              <span className="level-item">
                <div className="tags">
                  {tags}
                </div>
              </span>

              <span className="level-item">
                {this.props.item.type === 'advertising' ?
                  <span><span className="icon"><i className="fas fa-ad"></i></span>{I18n.media_items.advertising}</span>:
                  <span><span className="icon"><i className="fas fa-bullhorn"></i></span>{I18n.media_items.background}</span>
                }
              </span>

              <span className="level-item">
                <span><span className="icon"><i className="fas fa-book-reader"></i></span>{I18n.media_items[this.props.item.library]}</span>
              </span>

            </div>
          </nav>

        </div>

        <div className="media-right">

          <nav className="level">
            <span className="level-item">
              {this.props.item.file_processing_failed_message && <p className="has-text-danger">{this.props.item.file_processing_failed_message}</p>}
            </span>
            <span className="level-item">
              {this.props.item.file_processing && <span><span className="icon"><i className="fas fa-spinner"></i></span>{I18n.media_items.file_processing}</span>}
            </span>
          </nav>
        </div>
      </div>
   )
  }
}
