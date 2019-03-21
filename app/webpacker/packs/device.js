import React from 'react';
import ReactDOM from 'react-dom';
import Device from '../components/devices/device';

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  ReactDOM.render(
    <Device js_data={js_data} />, document.getElementById('root_component'),
  )
});
