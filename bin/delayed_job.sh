#!/usr/bin/env bash

cd $(dirname $(readlink -f $0))
cd ..

MODE=production
SECRET_KEY_BASE_FILE=secret_key

if [ -z "$2" ]; then
    echo "Using default mode $MODE"
else
    MODE=$2
    echo "Using mode $MODE"
fi

if [ $MODE = "production" ] ; then
    if [ -e $SECRET_KEY_BASE_FILE ] ; then
        export SECRET_KEY_BASE=\"`cat $SECRET_KEY_BASE_FILE`\"
    else
        echo "No secret key file $SECRET_KEY_BASE_FILE. Please, create it and put there result of 'rake secret'"
        exit 1
    fi
fi

delayed_job_start() {
        RAILS_ENV=$MODE bin/delayed_job start
}

delayed_job_stop() {
        RAILS_ENV=$MODE bin/delayed_job stop
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
    delayed_job_start
    ;;

  *)
    echo "Usage: bin/delayed_job.sh {start|stop|restart}" >&2
    ;;
esac