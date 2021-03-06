#!/bin/bash

set -o nounset
set -o errexit

case $1 in

  test )
    docker-compose -f dc-test.yml stop
    docker-compose -f dc-test.yml rm -f
    docker-compose -f dc-test.yml run mockuna
    ;;
  stop )
    docker-compose ${devfiles} stop
    ;;
  logs )
    docker-compose ${devfiles} logs -f $2
    ;;
  * )
    echo 'unknown command, options are: start/stop/build/logs/test'
    ;;
esac
