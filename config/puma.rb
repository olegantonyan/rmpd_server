threads 0,32
workers 0
stdout_redirect 'log/puma_stdout.log', 'log/puma_stderr.log', true
quiet
bind "unix://tmp/sockets/puma.socket"
daemonize
preload_app!
