import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'
import TagsSelect from '../../media_items/tags_select'
import Pagination from '../../common/pagination'
import SearchBox from '../../common/search_box'
import Select from '../../common/select'

const ITEMS_PER_PAGE = 25
const ALL_COMPANIES_PLACEHOLDER = { id: 0, title: I18n.any_company }

export default class MediaItems extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  state = {
    all_items: [],
    total_count: 0,

    current_page: 0,
    loading: false,
    search_query: "",
    selected_tags: [],
    selected_company: ALL_COMPANIES_PLACEHOLDER,
    selected_type: "background",
    selected_library: "all",
  }

  componentDidMount() {
    this.fetchItems(this.state.current_page,
      this.state.search_query,
      this.state.selected_tags,
      this.state.selected_company.id,
      this.state.selected_type,
      this.state.selected_library)
  }

  render() {
    const companies = <div className="field">
      <div className="control">
        <Select items={[ALL_COMPANIES_PLACEHOLDER].concat(this.props.js_data.companies)} value={this.state.selected_company} onSelect={this.onCompanySelected} />
      </div>
    </div>

    return(
      <div>

        <SearchBox value={this.state.search_query} onChange={this.onSearchQueryChange} />
        <TagsSelect tags={this.props.js_data.tags} selected_tags={this.state.selected_tags} onSelect={this.onTagSelect} onDelete={this.onTagDelete} />
        {this.props.js_data.companies.length > 1 && companies}
        {this.selectTypeComponent()}

        <div className="select is-multiple">
          <select multiple size={ITEMS_PER_PAGE}>
            {this.state.all_items.map(i => <option key={i.id} data-id={i.id}>{i.description.length > 0 ? `${i.file} (${i.description})` : i.file}</option>)}
          </select>
        </div>

        {!this.state.loading && <Pagination total_items={this.state.total_count} per_page={ITEMS_PER_PAGE} current_page={this.state.current_page} onPageChange={this.onPageChange} />}
      </div>
    )
  }

  selectTypeComponent = () => {
    return(
      <div className="box">
        <div className="control">
          <label className="radio">
            <input type="radio" name="library_shared" checked={this.state.selected_library === "private"} onChange={() => this.onLibraryHandler("private")} />
            {I18n.media_items.private_only}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="library_shared" checked={this.state.selected_library === "library"} onChange={() => this.onLibraryHandler("library")} />
            {I18n.media_items.library}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="library_shared" checked={this.state.selected_library === "all"} onChange={() => this.onLibraryHandler("all")} />
            {I18n.media_items.all}
          </label>
        </div>
      </div>
    )
  }

  onPageChange = (page) => {
    this.fetchItems(page,
      this.state.search_query,
      this.state.selected_tags,
      this.state.selected_company.id,
      this.state.selected_type,
      this.state.selected_library)
  }

  onSearchQueryChange = (qry) => {
    this.setState({ search_query: qry })
    this.fetchItems(0, qry, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
  }

  onTagSelect = (tag_id) => {
    const new_tags = [...this.state.selected_tags, this.props.js_data.tags.find(t => t.id.toString() === tag_id.toString()) ]
    this.setState({ selected_tags: new_tags})
    this.fetchItems(0, this.state.search_query, new_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
  }

  onTagDelete = (tag_id) => {
    const new_tags = this.state.selected_tags.filter(t => t.id.toString() !== tag_id.toString()).slice()
    this.setState({ selected_tags: new_tags })
    this.fetchItems(0, this.state.search_query, new_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
  }

  onCompanySelected = (company) => {
    this.setState({ selected_company: company })
    this.fetchItems(0, this.state.search_query, this.state.selected_tags, company.id, this.state.selected_type, this.state.selected_library)
  }

  onLibraryHandler = (type) => {
    this.setState({ selected_library: type })
    this.fetchItems(0, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, type)
  }

  fetchItems = (page, search_query, tags, company_id, type, library) => {
    this.setState({ loading: true })

    let url = `${this.props.js_data.media_items_path}?limit=${ITEMS_PER_PAGE}&offset=${page}`
    if (search_query.length > 0) {
      url += `&search_query=${search_query}`
    }
    if (tags.length > 0) {
      url += tags.map(t => `&with_tag_ids[]=${t.id}`).join("")
    }
    if (company_id > 0) {
      url += `&with_company_id=${company_id}`
    }
    if (["background", "advertising"].includes(type)) {
      url += `&with_type=${type}`
    }
    if (["all", "private", "library"].includes(library)) {
      url += `&with_library=${library}`
    }

    let headers = new Headers()
    headers.append('Accept', 'application/json')

    fetch(url, { headers: headers })
    .then(result => result.json())
    .catch(error => this.fetchError(error))
    .then(data => this.setState({ all_items: data.data, total_count: data.total_count, current_page: page, loading: false }))
    .catch(error => this.fetchError(error))
  }
}
