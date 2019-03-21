FileUtils.mkdir_p 'tmp/sockets'

threads 4,16
stdout_redirect 'log/puma_stdout.log', 'log/puma_stderr.log', true
bind 'unix://tmp/sockets/puma.socket'
environment 'production'
