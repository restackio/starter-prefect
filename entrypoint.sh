#!/usr/bin/env bash

set -e

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ ! -z "$EXTRA_PIP_PACKAGES" ]; then
  echo "+pip install $EXTRA_PIP_PACKAGES"
  pip install $EXTRA_PIP_PACKAGES
fi

cp -r /opt/prefect/flows /home/prefect/flows

exec prefect server start --port 4200 & sleep 30 & python ./flows/main.py
