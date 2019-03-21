import React from 'react'
import PropTypes from 'prop-types'
import I18n from '../i18n'

export default class SearchBox extends React.Component {
  static propTypes = {
    value: PropTypes.string.isRequired,
    placeholder: PropTypes.string,
    onChange: PropTypes.func.isRequired
  }

  static defaultProps = {
    placeholder: I18n.search
  }

  state = {
    value: "",
    timer: null
  }

  componentWillReceiveProps(next_props) {
    if(next_props.value !== this.props.value){
      this.setState({
        value: next_props.value
      })
    }
  }

  render() {
    return(
      <div className="field">
        <div className="control has-icons-left">
          <input className="input is-fullwidth" type="text" placeholder={this.props.placeholder} value={this.state.value} onChange={this.onTextChange}></input>
          <span className="icon is-left"><i className="fas fa-search"></i></span>
        </div>
      </div>
    )
  }

  onTextChange = (ev) => {
    this.setState({ value:  ev.target.value })

    if (this.state.timer !== null) {
      clearTimeout(this.state.timer)
      this.setState({ timer:  null })
    }
    let timer = setTimeout(() => {
      this.props.onChange(this.state.value)
    }, 400)
    this.setState({ timer:  timer })
  }
}
