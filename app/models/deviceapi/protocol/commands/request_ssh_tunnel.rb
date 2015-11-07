class Deviceapi::Protocol::Commands::RequestSshTunnel < Deviceapi::Protocol::BaseCommand
  def call(to_device, options = {})
    tunnel = options.fetch(:tunnel)
    clean_previous_commands(tunnel.device.login, type)
    Deviceapi::MessageQueue.enqueue(tunnel.device.login, json(tunnel), type)
  end

  def json(tunnel)
    {'type' => 'ssh_tunnel',
      'status' => 'open',
      'server' => tunnel.server,
      'server_port' => tunnel.server_port,
      'external_port' => tunnel.external_port,
      'internal_port' => tunnel.internal_port,
      'duration' => tunnel.open_duration,
      'username' => tunnel.username
    }.to_json
  end

end
