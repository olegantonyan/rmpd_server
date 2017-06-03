module Deviceapi
  module Protocol
    module Outgoing
      class RequestSshTunnel < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(options = {})
          tunnel = options.fetch(:tunnel)
          clean_previous_commands
          enqueue(json(tunnel))
        end

        def ack(ok, sequence_number, _data = {})
          super
          Notifiers::SshTunnelNotifierJob.perform_later(device) if ok
        end

        private

        def json(tunnel)
          {
            server: tunnel.server,
            server_port: tunnel.server_port,
            external_port: tunnel.external_port,
            internal_port: tunnel.internal_port,
            duration: tunnel.open_duration,
            username: tunnel.username
          }.merge(legacy_json)
        end

        def legacy_json
          { type: 'ssh_tunnel', status: 'open' }
        end
      end
    end
  end
end
