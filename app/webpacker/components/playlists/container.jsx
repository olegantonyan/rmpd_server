import React from 'react'
import PropTypes from 'prop-types'
import Item from './item'
import Loader from '../common/loader'
import Pagination from '../common/pagination'
import SearchBox from '../common/search_box'
import Select from '../common/select'
import I18n from '../i18n'

const ITEMS_PER_PAGE = 20
const ALL_COMPANIES_PLACEHOLDER = { id: 0, title: I18n.any_company }

export default class Container extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  state = {
    playlists: [],
    total_count: 0,

    current_page: 0,
    loading: true,
    search_query: "",
    selected_company: ALL_COMPANIES_PLACEHOLDER
  }

  componentDidMount() {
    this.fetchItems(this.state.current_page, this.state.search_query, this.state.selected_company.id)
  }

  render() {
    const loader = <Loader />
    const pagination = <section className="section">
      <Pagination total_items={this.state.total_count} per_page={ITEMS_PER_PAGE} current_page={this.state.current_page} onPageChange={this.onPageChange} />
    </section>

    const companies = <div className="field">
      <div className="control">
        <Select items={[ALL_COMPANIES_PLACEHOLDER].concat(this.props.js_data.companies)} value={this.state.selected_company} onSelect={this.onCompanySelected} />
      </div>
    </div>

    return (
      <div className="columns">
        <div className="column is-one-quarter">
          <div className="box">
            <SearchBox value={this.state.search_query} onChange={this.onSearchQueryChange} />

            {this.props.js_data.companies.length > 1 && companies}
          </div>
        </div>

        <div className="column">
          {this.state.loading && loader}
          <section className="section">
            {this.state.playlists.map((p) => <Item playlist={p} key={p.id} js_data={this.props.js_data}/>)}
          </section>
          {!this.state.loading && pagination}

        </div>
      </div>
    )
  }

  onPageChange = (page) => {
    this.fetchItems(page, this.state.search_query, this.state.selected_company.id)
  }

  onCompanySelected = (company) => {
    this.setState({ selected_company: company })
    this.fetchItems(0, this.state.search_query, company.id)
  }

  onSearchQueryChange = (qry) => {
    this.setState({ search_query: qry })
    this.fetchItems(0, qry, this.state.selected_company.id)
  }

  fetchItems = (page, search_query, company_id) => {
    this.setState({ loading: true })

    let url = `${this.props.js_data.index_path}?limit=${ITEMS_PER_PAGE}&offset=${page}`
    if (search_query.length > 0) {
      url += `&search_query=${search_query}`
    }
    if (company_id > 0) {
      url += `&with_company_id=${company_id}`
    }

    let headers = new Headers()
    headers.append('Accept', 'application/json')

    fetch(url, { headers: headers })
    .then(result => result.json())
    .catch(error => this.fetchError(error))
    .then(data => this.setState({ playlists: data.data, total_count: data.total_count, current_page: page, loading: false }))
    .catch(error => this.fetchError(error))
  }

  fetchError = (err) => {
    console.error(err)
    this.setState({ loading: false })
  }
}
