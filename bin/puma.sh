#!/usr/bin/env bash

# Simple move this file into your Rails `script` folder. Also make sure you `chmod +x puma.sh`.
# Please modify the CONSTANT variables to fit your configurations.

# The script will start with config set by $PUMA_CONFIG_FILE by default

cd $(dirname $(readlink -f $0))
cd ..

PUMA_CONFIG_FILE=config/puma.rb
PUMA_PID_FILE=tmp/pids/puma.pid
PUMA_SOCKET=tmp/sockets/puma.sock
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

# check if puma process is running
puma_is_running() {
  if [ -S $PUMA_SOCKET ] ; then
    if [ -e $PUMA_PID_FILE ] ; then
      if cat $PUMA_PID_FILE | xargs pgrep -P > /dev/null ; then
        return 0
      else
        echo "No puma process found"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi

  return 1
}

puma_start() {
    echo "Starting puma..."
    rm -f $PUMA_SOCKET
    if [ -e $PUMA_CONFIG_FILE ] ; then
      bundle exec puma --config $PUMA_CONFIG_FILE -e $MODE -d
    else
      RACK_MULTIPART_LIMIT=0 bundle exec puma --bind unix://$PUMA_SOCKET --pidfile $PUMA_PID_FILE -e $MODE -d 
    fi

    echo "done"
}

puma_stop() {
    echo "Stopping puma..."
    kill -s SIGTERM `cat $PUMA_PID_FILE`
    rm -f $PUMA_PID_FILE
    rm -f $PUMA_SOCKET

    echo "done"
}

case "$1" in
  start)
    puma_start
    ;;

  stop)
    puma_stop
    ;;

  restart)
    if puma_is_running ; then
      echo "Hot-restarting puma..."
      kill -s SIGUSR2 `cat $PUMA_PID_FILE`

      echo "Doublechecking the process restart..."
      sleep 5
      if puma_is_running ; then
        echo "done"
        exit 0
      else
        echo "Puma restart failed :/"
      fi
    fi

    echo "Trying cold reboot"
    puma_stop
    sleep 2
    puma_start
    ;;

  *)
    echo "Usage: bin/puma.sh {start|stop|restart}" >&2
    ;;
esac
