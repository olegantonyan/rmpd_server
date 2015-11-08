class Deviceapi::Protocol::Outgoing::RequestSshTunnel < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    tunnel = options.fetch(:tunnel)
    clean_previous_commands
    enqueue(json(tunnel))
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
