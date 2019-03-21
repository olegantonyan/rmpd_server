import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'
import Pagination from '../common/pagination'
import Loader from '../common/loader'

const ITEMS_PER_PAGE = 50

export default class LogMessages extends React.Component {
  static propTypes = {
    url: PropTypes.string.isRequired
  }

  state = {
    log_messages: [],
    total_count: 0,

    current_page: 0,
    loading: true
  }

  componentDidMount() {
    this.fetchItems(this.state.current_page)
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
        <td>{i.message}</td>
        <td>{i.localtime}</td>
        <td>{i.created_at}</td>
      </tr>
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
