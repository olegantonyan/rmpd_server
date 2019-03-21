import React from 'react';
import ReactDOM from 'react-dom';
import Upload from '../components/media_items/upload';

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  ReactDOM.render(
    <Upload js_data={js_data} />, document.getElementById('root_component'),
  )
});
