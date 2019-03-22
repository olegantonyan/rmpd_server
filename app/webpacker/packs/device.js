import React from 'react';
import ReactDOM from 'react-dom';
import Device from '../components/devices/device';
import ActionCable from "actioncable"

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  const action_cable = ActionCable.createConsumer()
  ReactDOM.render(
    <Device js_data={js_data} action_cable={action_cable} />, document.getElementById('root_component'),
  )
});
