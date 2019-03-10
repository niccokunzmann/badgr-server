#!/bin/sh

for arg in "$@"; do
    ./manage.py "$arg"
done

