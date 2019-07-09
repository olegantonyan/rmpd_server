import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import Pagination from '../common/pagination'
import Loader from '../common/loader'

const ITEMS_PER_PAGE = 50

export default class LogMessages extends React.Component {
  static propTypes = {
    device_id: PropTypes.number.isRequired,
    url: PropTypes.string.isRequired,
    action_cable: PropTypes.object.isRequired
  }

  state = {
    log_messages: [],
    total_count: 0,

    current_page: 0,
    loading: true
  }

  componentDidMount() {
    this.fetchItems(this.state.current_page)

    const component = this
    this.props.action_cable.subscriptions.create({ channel: "DeviceLogMessagesChannel", device_id: this.props.device_id }, {
      received(data) {
        if (component.state.current_page > 0) {
          return
        }
        let new_log_messages = [data].concat(component.state.log_messages.slice(0, ITEMS_PER_PAGE - 1));
        component.setState({ log_messages: new_log_messages, total_count: component.state.total_count + 1 })
      }
    })
  }

  render() {
    const pagination = <section className="section">
      <Pagination total_items={this.state.total_count} per_page={ITEMS_PER_PAGE} current_page={this.state.current_page} onPageChange={this.onPageChange} />
    </section>

    return (
      <div>
        {this.state.loading && <Loader />}
        <table className="table is-striped is-fullwidth">
          <thead>
            <tr>
              <th>{I18n.devices.log_messages.command}</th>
              <th>{I18n.devices.log_messages.message}</th>
              <th>{I18n.devices.log_messages.localtime}</th>
              <th>{I18n.devices.log_messages.created_at}</th>
            </tr>
          </thead>
          <tbody>
            {this.state.log_messages.map(i => this.logMessageItem(i))}
          </tbody>
        </table>

        {!this.state.loading && pagination}
      </div>
    )
  }

  logMessageItem = (i) => {
    return (
      <tr key={i.id}>
        <td>{i.command}</td>
        <td>{this.logMessageItemMessage(i)}</td>
        <td>{i.localtime}</td>
        <td>{i.created_at}</td>
      </tr>
    )
  }

  logMessageItemMessage = (i) => {
    return (
      <span>
        {i.message}
        {i.media_item_type === "advertising" && <span className="icon"><i className="fas fa-ad"></i></span>}
      </span>
    )
  }

  onPageChange = (page) => {
    this.fetchItems(page)
  }

  fetchItems = (page) => {
    this.setState({ loading: true })

    let url = `${this.props.url}?limit=${ITEMS_PER_PAGE}&offset=${page}`

    let headers = new Headers()
    headers.append('Accept', 'application/json')

    fetch(url, { headers: headers })
    .then(result => result.json())
    .catch(error => this.fetchError(error))
    .then(data => this.setState({ log_messages: data.data, total_count: data.total_count, current_page: page, loading: false }))
    .catch(error => this.fetchError(error))
  }

  fetchError = (err) => {
    console.error(err)
    this.setState({ loading: false })
  }
}
