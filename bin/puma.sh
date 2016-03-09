#!/bin/bash

pushd `pwd` > /dev/null

cd $(dirname $(readlink -f $0))
cd ..

PUMA_CONFIG_FILE=config/puma_config.rb
PUMA_PID_FILE=tmp/pids/puma.pid
ENVIROMENT=production

if [ -z "$2" ]; then
    echo "Using default enviroment $ENVIROMENT"
else
    ENVIROMENT=$2
    echo "Using enviroment $ENVIROMENT"
fi

puma_start()
{
    echo "Starting puma server"
    RACK_MULTIPART_LIMIT=0 bundle exec puma --config $PUMA_CONFIG_FILE -e $ENVIROMENT --pidfile $PUMA_PID_FILE
}

puma_stop()
{
    echo "Stopping puma server"
    kill -s SIGTERM `cat $PUMA_PID_FILE`
    rm -f $PUMA_PID_FILE
    rm -f $PUMA_SOCKET
}

case "$1" in
  start)
    puma_start
    ;;

  stop)
    puma_stop
    ;;

  restart)
    puma_stop
    sleep 2
    puma_start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}" >&2
    exit 1
    ;;
esac

popd > /dev/null

exit 0
