import React from 'react'
import PropTypes from 'prop-types'

export default class Select extends React.Component {
  static propTypes = {
    items: PropTypes.array.isRequired,
    onSelect: PropTypes.func.isRequired,
    id_attr: PropTypes.string,
    text_attr: PropTypes.string,
    value: PropTypes.object.isRequired,
    disabled: PropTypes.bool
  }

  static defaultProps = {
    id_attr: "id",
    text_attr: "title",
    disabled: false
  }

  render() {
    return(
      <div className="select">
        <select value={this.props.value[this.props.text_attr]} onChange={this.selectHandler} disabled={this.props.disabled}>
          {this.props.items.map(i => <option key={i[this.props.id_attr]} data-id={i[this.props.id_attr]}>{i[this.props.text_attr]}</option>)}
        </select>
      </div>
    )
  }

  selectHandler = (ev) => {
    for (let node of ev.target.children) {
      if (node.value === ev.target.value) {
        const id = node.getAttribute('data-id')
        const value = this.props.items.find(i => i[this.props.id_attr].toString() === id.toString())
        this.props.onSelect(value)
        return
      }
    }
  }
}
