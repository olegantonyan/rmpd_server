#!/bin/bash

pushd `pwd` > /dev/null

cd $(dirname $(readlink -f $0))
cd ..

ENVIROMENT=production
WORKERS=4

if [ -z "$2" ]; then
    echo "Using default enviroment $ENVIROMENT"
else
    ENVIROMENT=$2
    echo "Using enviroment $ENVIROMENT"
fi

delayed_job_start()
{
    echo "Starting delayed job"
    RAILS_ENV=$ENVIROMENT bin/delayed_job -n $WORKERS start
}

delayed_job_stop()
{
    echo "Stopping delayed job"
    RAILS_ENV=$ENVIROMENT bin/delayed_job stop
}

case "$1" in
  start)
    delayed_job_start
    ;;

  stop)
    delayed_job_stop
    ;;

  restart)
    delayed_job_stop
    sleep 2
    delayed_job_start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}" >&2
    exit 1
    ;;
esac

popd > /dev/null

exit 0
