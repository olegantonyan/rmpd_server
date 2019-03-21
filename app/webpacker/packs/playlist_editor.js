import React from 'react';
import ReactDOM from 'react-dom';
import PlaylistEditor from '../components/playlists/playlist_editor';

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  ReactDOM.render(
    <PlaylistEditor js_data={js_data} />, document.getElementById('root_component'),
  )
});
