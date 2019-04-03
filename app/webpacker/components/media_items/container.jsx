import React from 'react'
import PropTypes from 'prop-types'
import Loader from '../common/loader'
import Item from './item'
import TagsSelect from './tags_select'
import Pagination from '../common/pagination'
import SearchBox from '../common/search_box'
import Select from '../common/select'
import I18n from '../i18n'
import PlayerControls from './player_controls'
import CsrfToken from "../csrf_token"
import DeleteMessage from "./deleted_message"

const ITEMS_PER_PAGE = 25
const ALL_COMPANIES_PLACEHOLDER = { id: 0, title: I18n.any_company }

export default class Container extends React.Component {
  static propTypes = {
    js_data: PropTypes.object.isRequired
  }

  constructor(props) {
    super(props)

    const url_params = new URLSearchParams(window.location.search)

    let pre_selected_tags = []
    const tag_id_from_url = url_params.get("with_tag_ids")
    if (tag_id_from_url !== null) {
      pre_selected_tags = this.props.js_data.tags.filter(t => t.id.toString() === tag_id_from_url.toString())
    }

    this.state = {
      media_items: [],
      total_count: 0,

      current_page: 0,
      loading: true,
      search_query: "",
      selected_tags: pre_selected_tags,
      selected_company: ALL_COMPANIES_PLACEHOLDER,
      selected_type: "",
      selected_library: "all",

      playing_now: null,

      selected_items: [],
      deleted_results: null
    }
  }

  componentDidMount() {
    this.fetchItems(this.state.current_page, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
  }

  render() {
    const pagination = <section className="section">
      <Pagination total_items={this.state.total_count} per_page={ITEMS_PER_PAGE} current_page={this.state.current_page} onPageChange={this.onPageChange} />
    </section>

    const companies = <div className="field">
      <div className="control">
        <Select items={[ALL_COMPANIES_PLACEHOLDER].concat(this.props.js_data.companies)} value={this.state.selected_company} onSelect={this.onCompanySelected} />
      </div>
    </div>

    return(
      <div className="columns">
        <div className="column is-one-quarter">
          <div className="box">
            <SearchBox value={this.state.search_query} onChange={this.onSearchQueryChange} />

            <TagsSelect tags={this.props.js_data.tags} selected_tags={this.state.selected_tags} onSelect={this.onTagSelect} onDelete={this.onTagDelete} />

            {this.selectTypeComponent()}

            <div className="field">
              <div className="control">
                <div className="select">
                  <select value={this.selected_type} onChange={this.onTypeSelectHandler}>
                    <option data-id="all_types">{I18n.media_items.any_type}</option>
                    <option data-id="background">{I18n.media_items.background}</option>
                    <option data-id="advertising">{I18n.media_items.advertising}</option>
                  </select>
                </div>
              </div>
            </div>

            {this.props.js_data.companies.length > 1 && companies}

            <a className="button is-small is-danger is-outlined" onClick={this.onResetFilters}>{I18n.reset_filters}</a>
          </div>

        </div>

        <div className="column">
          {this.state.playing_now !== null && <PlayerControls playing_now={this.state.playing_now} onPause={this.onPlayerControlPause}/>}
          {this.state.loading && <Loader />}
          <section className="section">
            {this.state.media_items.map((item) => this.itemComponent(item))}
          </section>

          {!this.state.loading && pagination}

          <div className="section is-pulled-right">
            {this.state.selected_items.length > 0 && <a className="button is-small is-danger is-outlined" onClick={() => { if(window.confirm(I18n.media_items.delete_confirm)) this.onDeleteSelected() } }>
              <span>{I18n.media_items.delete_selected}</span>
            </a>}

            <a className="button is-small is-primary is-outlined" onClick={this.onSelectAll}>
              <span>{I18n.media_items.select_all}</span>
            </a>
          </div>

          {this.state.deleted_results !== null &&
            <div className="section">
              <span className="icon" onClick={() => this.setState({ deleted_results: null })}><i className="fas fa-times-circle fa-2x"></i></span>
              <DeleteMessage deleted_results={this.state.deleted_results} />
            </div>
          }

        </div>

      </div>
    )
  }

  itemComponent = (item) => {
    return (
      <div key={item.id} className="columns">
        <div className="column">
          <Item item={item} onPlayPause={this.onItemPlayPause} playing={this.state.playing_now !== null && this.state.playing_now.item.id === item.id} onProgress={this.onItemPlayProgress} />
        </div>
        <div className="column is-narrow">
          <input type="checkbox" checked={this.state.selected_items.map(i => i.id).includes(item.id)} onChange={(ev) => this.onItemSelectChanged(ev.target.checked, item)}/>
        </div>
      </div>
    )
  }

  selectTypeComponent = () => {
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

  onResetFilters = () => {
    this.setState({
      current_page: 0,
      search_query: "",
      selected_tags: [],
      selected_company: ALL_COMPANIES_PLACEHOLDER,
      selected_type: "",
      selected_library: "all"
    }, () => {
      this.fetchItems(this.state.current_page,
                      this.state.search_query,
                      this.state.selected_tags,
                      this.state.selected_company.id,
                      this.state.selected_type,
                      this.state.selected_library)
    })
  }

  onPageChange = (page) => {
    this.fetchItems(page, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
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

  onTypeSelectHandler = (ev) => {
    for (let node of ev.target.children) {
      if (node.value === ev.target.value) {
        const id = node.getAttribute('data-id')
        this.setState({ selected_type: id })
        this.fetchItems(0, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, id, this.state.selected_library)
        return
      }
    }
  }

  onLibraryHandler = (type) => {
    this.setState({ selected_library: type })
    this.fetchItems(0, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, type)
  }

  onSelectAll = () => {
    if (this.state.selected_items.length === 0) {
      this.setState({ selected_items: [...this.state.media_items] })
    } else {
      this.setState({ selected_items: [] })
    }
  }

  onItemSelectChanged = (checked, item) => {
    if (checked) {
      this.setState({ selected_items: [...this.state.selected_items, item] })
    } else {
      const new_items = this.state.selected_items.filter(i => i.id !== item.id).slice()
      this.setState({ selected_items: new_items })
    }
  }

  onDeleteSelected = () => {
    this.setState({ loading: true })
    let headers = new Headers()
    headers.append('Accept', 'application/json')
    headers.append('Content-Type', 'application/json')
    headers.append('X-CSRF-Token', CsrfToken.get())

    const data = { media_item_ids: this.state.selected_items.map(i => i.id) }

    fetch(this.props.js_data.destroy_path, { method: 'DELETE', headers: headers, body: JSON.stringify(data) })
    .then(result => result.json())
    .catch(error => this.fetchError(error))
    .then(data => {
      this.setState({ deleted_results: data })
      this.fetchItems(this.state.current_page, this.state.search_query, this.state.selected_tags, this.state.selected_company.id, this.state.selected_type, this.state.selected_library)
    })
    .catch(error => this.fetchError(error))
  }

  fetchItems = (page, search_query, tags, company_id, type, library) => {
    this.setState({ loading: true })

    let url = `${this.props.js_data.index_path}?limit=${ITEMS_PER_PAGE}&offset=${page}`
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
    .then(data => this.setState({ media_items: data.data, total_count: data.total_count, current_page: page, loading: false }))
    .catch(error => this.fetchError(error))
  }

  fetchError = (err) => {
    console.error(err)
    this.setState({ loading: false })
  }

  onItemPlayPause = (item, audio_element) => {
    if (this.state.playing_now !== null) {
      this.state.playing_now.audio_element.pause()
      if (item.id === this.state.playing_now.item.id) {
        this.setState({ playing_now: null })
      } else {
        audio_element.play()
        this.setState({ playing_now: { item: item, audio_element: audio_element, current: 0, total: 0 } })
      }
    } else {
      audio_element.play()
      this.setState({ playing_now: { item: item, audio_element: audio_element, current: 0, total: 0 } })
    }
  }

  onPlayerControlPause = () => {
    if (this.state.playing_now !== null) {
      this.state.playing_now.audio_element.pause()
    }
    this.setState({ playing_now: null })
  }

  onItemPlayProgress = (current, total) => {
    if (this.state.playing_now !== null) {
      const newc = { current: current, total: total }
      this.setState({
        playing_now: { ...this.state.playing_now, ...newc }
      })
    }
  }
}
