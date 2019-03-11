#!/bin/sh

set -e
echo "$@"
for arg in "$@"; do
    echo " ------------- ./manage.py $arg ------------- "
    ./manage.py "$arg"
done

