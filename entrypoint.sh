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


exec prefect server start --port 4200 #& sleep 30 & python /home/prefect/flows/example-flow.py
# exec "$@" & sleep 30 #& python /home/prefect/flows/example-flow.py
# Execute all Python files in the flows directory
# for script in ../../opt/prefect/flows/*.py; do
#   echo "Running $script..."
#   python $script
# done

