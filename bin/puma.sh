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
export SECRET_KEY_BASE="b240b6a3c727ea326d16ca583416bbf313c0a48a9fbcc2d1b88bcbf9918df42ddf327ac606d782e9adea57fe75315045741727695c93a1095675f2abc6c7a000"

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

case "$1" in
  start)
    echo "Starting puma..."
    rm -f $PUMA_SOCKET
    if [ -e $PUMA_CONFIG_FILE ] ; then
      bundle exec puma --config $PUMA_CONFIG_FILE -e $MODE
    else
      bundle exec puma --daemon --bind unix://$PUMA_SOCKET --pidfile $PUMA_PID_FILE -e $MODE
    fi

    echo "done"
    ;;

  stop)
    echo "Stopping puma..."
      kill -s SIGTERM `cat $PUMA_PID_FILE`
      rm -f $PUMA_PID_FILE
      rm -f $PUMA_SOCKET

    echo "done"
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
    bin/puma.sh start
    ;;

  *)
    echo "Usage: bin/puma.sh {start|stop|restart}" >&2
    ;;
esac