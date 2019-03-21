import React from 'react';
import ReactDOM from 'react-dom';
import Container from '../components/playlists/container';

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  ReactDOM.render(
    <Container js_data={js_data} />, document.getElementById('root_component'),
  )
});
