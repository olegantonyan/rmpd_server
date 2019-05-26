import React from 'react'
import PropTypes from 'prop-types'

export default class Pagination extends React.Component {
  static propTypes = {
    current_page: PropTypes.number,
    per_page: PropTypes.number,
    total_items: PropTypes.number.isRequired,
    onPageChange: PropTypes.func.isRequired
  }

  static defaultProps = {
    current_page: 0,
    per_page: 20,
  }

  render() {
    const first_page = <li>
      <a className={this.props.current_page == 0 ? "pagination-link is-current" : "pagination-link"}
         aria-label="Page 1"
         onClick={this.onNumberedHandler}>
         1
      </a>
    </li>

    const last_page = <li>
      <a className={this.props.current_page == this.max_pages() - 1 ? "pagination-link is-current" : "pagination-link"}
         aria-label={"Page " + this.max_pages()}
         onClick={this.onNumberedHandler}>
         {this.max_pages()}
      </a>
    </li>

    const elipsis = <li><span className="pagination-ellipsis">&hellip;</span></li>

    let central_buttons = <ul className="pagination-list"></ul>
    if (this.max_pages() == 2) {
      central_buttons = <ul className="pagination-list">
        {first_page}
        {last_page}
      </ul>
    } else if (this.max_pages() == 3) {
      central_buttons = <ul className="pagination-list">
        {first_page}
        {this.central_button(1)}
        {last_page}
      </ul>
    } else if (this.max_pages() == 4) {
      central_buttons = <ul className="pagination-list">
        {first_page}
        {this.central_button(1)}
        {this.central_button(2)}
        {last_page}
      </ul>
    } else if (this.max_pages() == 5) {
      central_buttons = <ul className="pagination-list">
        {first_page}
        {this.central_button(1)}
        {this.central_button(2)}
        {this.central_button(3)}
        {last_page}
      </ul>
    } else if (this.max_pages() > 5) {
      if (this.props.current_page == 0 || this.props.current_page == 1 || this.props.current_page == 2) {
        central_buttons = <ul className="pagination-list">
          {first_page}
          {this.central_button(1)}
          {this.central_button(2)}
          {this.central_button(3)}
          {elipsis}
          {last_page}
        </ul>
      } else if (this.props.current_page == (this.max_pages() - 1) || this.props.current_page == (this.max_pages() - 2) || this.props.current_page == (this.max_pages() - 3)) {
        central_buttons = <ul className="pagination-list">
          {first_page}
          {elipsis}
          {this.central_button(this.max_pages() - 4)}
          {this.central_button(this.max_pages() - 3)}
          {this.central_button(this.max_pages() - 2)}
          {last_page}
        </ul>
      } else {
        const middle = this.props.current_page
        central_buttons = <ul className="pagination-list">
          {first_page}
          {elipsis}
          {this.central_button(middle - 1)}
          {this.central_button(middle)}
          {this.central_button(middle + 1)}
          {elipsis}
          {last_page}
        </ul>
      }
    }

    return(
      <nav className="pagination is-right" role="navigation" aria-label="pagination">

        <a className="pagination-previous"
           onClick={this.onPrevHandler}
           disabled={this.props.current_page <= 0}>
           <span className="icon"><i className="fas fa-angle-left"></i></span>
        </a>

        <a className="pagination-next"
           onClick={this.onNextHandler}
           disabled={this.props.current_page >= this.max_pages() - 1}>
           <span className="icon"><i className="fas fa-angle-right"></i></span>
        </a>

        {central_buttons}
      </nav>
   )
  }

  central_button = (page_num) => {
    return(
      <li>
        <a className={this.props.current_page == page_num ? "pagination-link is-current" : "pagination-link"} onClick={this.onNumberedHandler}>{page_num + 1}</a>
      </li>
    )
  }

  max_pages = () => {
    return Math.ceil(this.props.total_items / this.props.per_page)
  }

  onPrevHandler = (_ev) => {
    if (this.props.current_page <= 0) {
      return
    }
    this.props.onPageChange(this.props.current_page - 1)
  }

  onNextHandler = (_ev) => {
    if (this.props.current_page >= this.max_pages() - 1) {
      return
    }
    this.props.onPageChange(this.props.current_page + 1)
  }

  onNumberedHandler = (ev) => {
    const num = parseInt(ev.target.text) - 1
    if (num >= this.max_pages() || num < 0) {
      return
    }
    this.props.onPageChange(num)
  }
}
