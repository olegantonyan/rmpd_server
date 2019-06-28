import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../../i18n'
import TagsSelect from '../../media_items/tags_select'
import Pagination from '../../common/pagination'
import SearchBox from '../../common/search_box'
import Select from '../../common/select'
import FormBackground from './form_background'
import FormAdvertising from './form_advertising'

const ITEMS_PER_PAGE = 50
const ALL_COMPANIES_PLACEHOLDER = { id: 0, title: I18n.any_company }

export default class MediaItems extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired,
    onAdd: PropTypes.func.isRequired
  }

  state = {
    all_items: [],
    total_count: 0,

    selected_items: [],

    current_page: 0,
    loading: false,
    search_query: "",
    selected_tags: [],
    selected_company: ALL_COMPANIES_PLACEHOLDER,
    selected_type: "background",
    selected_library: "all",
  }

  constructor(props) {
    super(props)
    this.itemsForm = React.createRef()
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
      <div className="columns">
        <div className="column is-one-quarter">
          <SearchBox value={this.state.search_query} onChange={this.onSearchQueryChange} />
          {this.selectTypeComponent()}
          <TagsSelect tags={this.props.js_data.tags} selected_tags={this.state.selected_tags} onSelect={this.onTagSelect} onDelete={this.onTagDelete} />
          {this.props.js_data.companies.length > 1 && companies}
          {this.selectLibraryComponent()}
        </div>

        <div className="column">

          <div className="columns">
            <div className="column">
              <div className="select is-multiple is-fullwidth">
                <select multiple size={this.state.all_items.length} onChange={this.onItemsSelected}>
                  {this.state.all_items.map(i => <option key={i.id} data-id={i.id}>{this.itemText(i)}</option>)}
                </select>
              </div>
              {!this.state.loading && <Pagination total_items={this.state.total_count} per_page={ITEMS_PER_PAGE} current_page={this.state.current_page} onPageChange={this.onPageChange} />}
            </div>

            <div className="column is-one-quarter">
              {this.state.selected_type === "background" ?
                <FormBackground ref={this.itemsForm} />
              :
                <FormAdvertising ref={this.itemsForm} />
              }
              <hr />
              <button className="button is-primary"
                      onClick={() => this.props.onAdd(this.itemsForm.current.buildItems(this.state.selected_items))}>
                      {this.state.selected_type === "background" ? I18n.playlists.add_background : I18n.playlists.add_advertising}
              </button>
            </div>
          </div>

        </div>
      </div>
    )
  }

  selectLibraryComponent = () => {
    return(
      <div className="box">
        <div className="control">
          <label className="radio">
            <input type="radio" name="library" checked={this.state.selected_library === "personal"} onChange={() => this.onLibraryHandler("personal")} />
            {I18n.media_items.personal}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="library" checked={this.state.selected_library === "standard"} onChange={() => this.onLibraryHandler("standard")} />
            {I18n.media_items.standard}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="library" checked={this.state.selected_library === "premium"} onChange={() => this.onLibraryHandler("premium")} />
            {I18n.media_items.premium}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="library" checked={this.state.selected_library === "all"} onChange={() => this.onLibraryHandler("all")} />
            {I18n.media_items.all}
          </label>
        </div>
      </div>
    )
  }

  selectTypeComponent = () => {
    return(
      <div className="box">
        <div className="control">
          <label className="radio">
            <input type="radio" name="selected_type" checked={this.state.selected_type === "advertising"} onChange={() => this.onTypeHandler("advertising")} />
            {I18n.media_items.advertising}
          </label>
        </div>

        <div className="control">
          <label className="radio">
            <input type="radio" name="selected_type" checked={this.state.selected_type === "background"} onChange={() => this.onTypeHandler("background")} />
            {I18n.media_items.background}
          </label>
        </div>
      </div>
    )
  }

  itemText = (item) => {
    let result = item.file
    if (item.description.length > 0) {
      result += ` (${item.description})`
    }
    if (item.tags.length > 0) {
      result += ` # ${item.tags.map(i => i.name).join(", ")}`
    }
    return result
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

  onTypeHandler = (type) => {
    this.setState({ selected_type: type })
    this.fetchItems(0, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, type, this.state.selected_library)
  }

  onItemsSelected = (ev) => {
    let options = ev.target.options
    let items = []
    for (let i = 0, l = options.length; i < l; i++) {
      if (options[i].selected) {
        const id = options[i].getAttribute('data-id')
        const value = this.state.all_items.find(i => i.id.toString() === id.toString())
        items.push(value)
      }
    }
    this.setState({ selected_items: items })
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
    if (["all", "personal", "standard", "premium"].includes(library)) {
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
