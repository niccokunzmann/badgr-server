#!/bin/bash

set -e

if [ "$DATABASES_default_ENGINE" == "django.db.backends.mysql" ] && [ -n "$CREATE_DB_IF_NOT_EXISTS" ]; then
  echo "mysql chosen, setting up database"
  if mysql -u $DATABASES_default_USER -p$DATABASES_default_PASSWORD -h $DATABASES_default_HOST -P $DATABASES_default_PORT -D $DATABASES_default_NAME; then
    echo "database $DATABASES_default_NAME exists."
  else
    echo "CREATE DATABASE $DATABASES_default_NAME; exit;" | mysql -u $DATABASES_default_USER -p$DATABASES_default_PASSWORD -h $DATABASES_default_HOST -P $DATABASES_default_PORT  
  fi
fi

if [ -n "$1" ]; then
  for command in "$@"; do
    echo " -------- $command -------- "
    ./manage.py "$command"
  done
else
  1>&2 echo "no arguments given: $@"
  exit 1
fi

