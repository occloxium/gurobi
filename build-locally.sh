#!/bin/bash
build () {
    echo "Please enter a tag for the image:"
    read TAG
    docker build -t "docker-gurobi:$TAG" .
    if [[ $? == 0 ]]; then
        echo "Image has been built."
    else
        echo "An error occured while building docker image. Check log for details."
        echo "Exiting without building image."
    fi
}

echo "Currently on git branch $(git branch | grep \* | cut -d ' ' -f2)"
echo "Do you want to build the docker-gurobi image from current branch? [y|N]"
read CONFIRM
if [[ $CONFIRM =~ ^[y|Y|j|J]$ ]] || [[ $CONFIRM == "" ]]; then
    echo "Building image from branch $(git branch | grep \* | cut -d ' ' -f2)"
    build
else
    echo "Please enter the branch to switch to or switch branches by yourself (quit script with Ctrl+C)"
    read BRANCH
    git checkout $BRANCH
    if [[ $? == 0 ]]; then
        echo "Building image from branch $(git branch | grep \* | cut -d ' ' -f2)"
        build
    else
        echo
        echo "An error occured while switching branches. Check log for details"
        echo "Exiting without building image."
    fi
fi