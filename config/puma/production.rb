FileUtils.mkdir_p 'tmp/sockets'

threads 0,32
stdout_redirect 'log/puma_stdout.log', 'log/puma_stderr.log', true
quiet
bind "unix://tmp/sockets/puma.socket"
daemonize