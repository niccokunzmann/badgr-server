#!/bin/bash

set -e

if [ -n "$DATABASES_default_HOST" ] && [ -n "$DATABASES_default_PORT" ]; then
  for i in `seq 1 60`; do
    echo -n .
    if python -c "import socket; socket.socket().connect(('$DATABASES_default_HOST', $DATABASES_default_PORT))" 2> /dev/null; then
      echo
      echo "INFO: Database up at $DATABASES_default_HOST:$DATABASES_default_PORT."
      break
    fi
    sleep 1
  done
else
  echo "INFO: set the environment variables DATABASES_default_HOST and DATABASES_default_PORT to wait for the database to come up."
fi

if [ "$DATABASES_default_ENGINE" == "django.db.backends.mysql" ] && [ -n "$CREATE_DB_IF_NOT_EXISTS" ]; then
  echo "INFO: mysql chosen"
  if mysql -u $DATABASES_default_USER -p$DATABASES_default_PASSWORD -h $DATABASES_default_HOST -P $DATABASES_default_PORT -D $DATABASES_default_NAME; then
    echo "INFO: database \"$DATABASES_default_NAME\" exists."
  else
    echo "INFO: setting up database \"$DATABASES_default_NAME\"."
    echo "CREATE DATABASE $DATABASES_default_NAME; exit;" | mysql -u $DATABASES_default_USER -p$DATABASES_default_PASSWORD -h $DATABASES_default_HOST -P $DATABASES_default_PORT  
  fi
fi

if [ -n "$1" ]; then
  for command in "$@"; do
    echo " -------- $command -------- "
    ./manage.py $command
  done
else
  1>&2 echo "ERROR: no arguments given: $@"
  exit 1
fi

