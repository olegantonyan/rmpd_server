import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'

export default class TagsSelect extends React.Component {
  static propTypes = {
    tags: PropTypes.array.isRequired,
    selected_tags: PropTypes.array.isRequired,
    onSelect: PropTypes.func.isRequired,
    onDelete: PropTypes.func.isRequired,
    disabled: PropTypes.bool
  }

  static defaultProps = {
    disabled: false
  }

  render() {
    return(
      <div className="box">
        <div className="field">
          <div className="control has-icons-left">
            <div className="select">
              <select value={I18n.media_items.tags} onChange={this.selectHandler} disabled={this.props.disabled}>
                <option style={{display: 'none'}}>{I18n.media_items.tags}</option>
                {this.props.tags.filter(tag => !this.props.selected_tags.map(t => t.id.toString()).includes(tag.id.toString())).map(tag => <option key={tag.id} data-id={tag.id}>{tag.name}</option>)}
              </select>
            </div>
            <div className="icon is-left">
              <i className="fas fa-tags"></i>
            </div>
          </div>
        </div>

        <div className="tags">
          {this.props.selected_tags.map(tag => this.tagComponent(tag))}
        </div>
      </div>
    )
  }

  tagComponent = (tag) => {
    return(
      <span className="tag is-dark" key={tag.id}>
        {tag.name}
        <button className="delete" onClick={() => this.deleteHandler(tag.id)} disabled={this.props.disabled}></button>
      </span>
    )
  }

  deleteHandler = (id) => {
    this.props.onDelete(id)
  }

  selectHandler = (ev) => {
    for (let node of ev.target.children) {
      if (node.value === ev.target.value) {
        const tag_id = node.getAttribute('data-id')
        this.props.onSelect(tag_id)
        return
      }
    }
  }
}
