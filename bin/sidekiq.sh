#!/bin/bash

pushd `pwd` > /dev/null

cd $(dirname $(readlink -f $0))
cd ..

if [ -z "$2" ]; then
    ENVIROMENT=production
    echo "Using default enviroment $ENVIROMENT"
else
    ENVIROMENT=$2
    echo "Using enviroment $ENVIROMENT"
fi

SIDEKIQ_CONFIG_FILE=config/sidekiq.yml
SIDEKIQ_PID_FILE=tmp/pids/sidekiq.pid

sidekiq_start()
{
    echo "Starting sidekiq"
    mkdir -p tmp/pids
    bundle exec sidekiq -d --config $SIDEKIQ_CONFIG_FILE -e $ENVIROMENT --pidfile $SIDEKIQ_PID_FILE
}

sidekiq_stop()
{
    echo "Stopping sidekiq"
    kill -s SIGTERM `cat $SIDEKIQ_PID_FILE`
    rm -f $SIDEKIQ_PID_FILE
}

case "$1" in
  start)
    sidekiq_start
    ;;

  stop)
    sidekiq_stop
    ;;

  restart)
    sidekiq_stop
    sleep 2
    sidekiq_start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}" >&2
    exit 1
    ;;
esac

popd > /dev/null

exit 0
