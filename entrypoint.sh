#!/usr/bin/env bash

set -e

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ ! -z "$EXTRA_PIP_PACKAGES" ]; then
  echo "+pip install $EXTRA_PIP_PACKAGES"
  pip install $EXTRA_PIP_PACKAGES
fi

if [ -z "$*" ]; then
  echo "\
  ___ ___ ___ ___ ___ ___ _____
 | _ \ _ \ __| __| __/ __|_   _|
 |  _/   / _|| _|| _| (__  | |
 |_| |_|_\___|_| |___\___| |_|

"
  exec bash --login
else
  exec "$@"  #& sleep 5 # & python /home/prefect/flows/example-flow.py
  # Execute all Python files in the flows directory
  # for script in ../../opt/prefect/flows/*.py; do
  #   echo "Running $script..."
  #   python $script
  # done
fi

