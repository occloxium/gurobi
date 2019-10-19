#!/bin/sh

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- gurobi "$@"
fi

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi
license=/home/gurobi/gurobi.lic
echo "Mounted scripts available are:"
ls -rAh
echo
if [ -z $MODEL ]; then
    RUN=$MODEL
else
    RUN=(./*/*model.py)
fi
echo "Running solver on $RUN"
if [ -f $license ]; then
    echo "Skipping license creation"
    gurobi.sh $RUN
else
    echo "Configure license $GUROBI_LICENSE"
    echo -ne '\n' | grbgetkey $GUROBI_LICENSE
    gurobi.sh $RUN
fi
