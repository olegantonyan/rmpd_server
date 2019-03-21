import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'

export default class DeletedMessage extends React.Component {
  static propTypes = {
    deleted_results: PropTypes.object.isRequired
  }

  render() {
    return(
      <article className="message is-warning">
        <div className="message-body">

          {this.props.deleted_results.deleted.length > 0 && <div className="box">
            <h5 className="subtitle is-5">{I18n.media_items.deleted}</h5>
            <ul>
              {this.props.deleted_results.deleted.map(i => <li key={i.id}>{i.file}</li> )}
            </ul>
          </div>}

          {this.props.deleted_results.unauthorized.length > 0 && <div className="box">
            <h5 className="subtitle is-5">{I18n.media_items.unauthorized}</h5>
            <ul>
              {this.props.deleted_results.unauthorized.map(i => <li key={i.id}>{i.file}</li> )}
            </ul>
          </div>}


          {this.props.deleted_results.has_playlist.length > 0 && <div className="box">
            <h5 className="subtitle is-5">{I18n.media_items.has_playlist}</h5>
            <ul>
              {this.props.deleted_results.has_playlist.map(i => <li key={i.id}>{i.file}</li> )}
            </ul>
          </div>}

        </div>
      </article>
   )
  }
}
