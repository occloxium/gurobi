#!/bin/bash

solve () {
    echo "Running solver on $1"
    if [ -f $license ]; then
        echo "Skipping license creation"
        gurobi.sh $1
    else
        echo "Configure license $GUROBI_LICENSE"
        echo -ne '\n' | grbgetkey $GUROBI_LICENSE
        gurobi.sh $1
    fi
}

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
    solve $MODEL
else
    RUN=$(find . -name "*model.py")
    find . -name "*model.py"|while read model; do 
        solve $model
    done;
fi
