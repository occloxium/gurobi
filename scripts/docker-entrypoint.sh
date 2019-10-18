#!/bin/sh

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- gurobi "$@"
fi

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi
license=/home/gurobi/gurobi.lic
echo "Please enter filename to run"
echo "Mounted scripts available are:"
ls -Ah
echo "Choose your model file to run:"
read FILENAME
echo
if [ -f $license ]; then
    echo "Skipping license creation"
    gurobi.sh $FILENAME
else
    echo "Configure license $GUROBI_LICENSE"
    echo -ne '\n' | grbgetkey $GUROBI_LICENSE
    gurobi.sh $FILENAME
fi
