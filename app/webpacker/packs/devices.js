import React from 'react';
import ReactDOM from 'react-dom';
import Container from '../components/devices/container';
import ActionCable from "actioncable"

document.addEventListener('DOMContentLoaded', () => {

  const node = document.getElementById('js_data')
  const js_data = JSON.parse(node.getAttribute('js_data'))
  const action_cable = ActionCable.createConsumer()
  ReactDOM.render(
    <Container js_data={js_data} action_cable={action_cable} />, document.getElementById('root_component'),
  )
});
