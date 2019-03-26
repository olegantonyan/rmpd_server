import React from 'react';
import ReactDOM from 'react-dom';
import Editor from '../components/playlists/editor';

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  ReactDOM.render(
    <Editor js_data={js_data} />, document.getElementById('root_component'),
  )
});
