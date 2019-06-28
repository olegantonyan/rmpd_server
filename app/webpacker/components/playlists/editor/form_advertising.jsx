import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'
import DatePicker from 'react-datepicker'
import 'react-datepicker/dist/react-datepicker.css'
import { time_string_to_date, date_to_time_string } from '../../dumpster'

export default class FormAdvertising extends React.Component {
  state = {
    playbacks_per_day: 10,
    begin_time: '09:00:00',
    end_time: '18:00:00',
    begin_date: '01.01.1970',
    end_date: '19.01.2038'
  }

  render() {
    return(
      <div>

        <div className="field">
          <label className="label">{I18n.playlist_items.begin_time}</label>
          <div className="control">

            <DatePicker
              selected={time_string_to_date(this.state.begin_time)}
              onChange={v => this.setState({ begin_time: date_to_time_string(v) })}
              showTimeSelect
              showTimeSelectOnly
              timeIntervals={10}
              timeFormat="HH:mm:ss"
              dateFormat="HH:mm:ss"
              timeCaption=""
            />

            <input className="input" value={this.state.begin_time} onChange={ev => this.setState({ begin_time: ev.target.value })} />
          </div>
        </div>

        <div className="field">
          <label className="label">{I18n.playlist_items.end_time}</label>
          <div className="control">
            <input className="input" value={this.state.end_time} onChange={ev => this.setState({ end_time: ev.target.value })} />
          </div>
        </div>

        <div className="field">
          <label className="label">{I18n.playlist_items.begin_date}</label>
          <div className="control">
            <input className="input" value={this.state.begin_date} onChange={ev => this.setState({ begin_date: ev.target.value })} />
          </div>
        </div>

        <div className="field">
          <label className="label">{I18n.playlist_items.end_date}</label>
          <div className="control">
            <input className="input" value={this.state.end_date} onChange={ev => this.setState({ end_date: ev.target.value })} />
          </div>
        </div>

        <div className="field">
          <label className="label">{I18n.playlist_items.playbacks_per_day}</label>
          <div className="control">
            <input className="input" type="number" min="1" max="500" value={this.state.playbacks_per_day} onChange={ev => this.setState({ playbacks_per_day: ev.target.value })} />
          </div>
        </div>


      </div>
    )
  }

  buildItems = (media_items) => {
    const playlist_items = media_items.map(i => {
      const playlist_item = {
        media_item: i,
        begin_time: this.state.begin_time,
        end_time: this.state.end_time,
        begin_date: this.state.begin_date,
        end_date: this.state.end_date,
        playbacks_per_day: this.state.playbacks_per_day,
        type: 'advertising'
       }
       return playlist_item
    })
    return playlist_items
  }
}
