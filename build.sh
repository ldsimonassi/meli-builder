#!/bin/bash

# Usage ./build.sh user repository version

if [ $# -ne 3 ]
  then
    echo "Usage $0 <User> <Repository> <Version>"
    echo "  User: the github & dockhub user account."
    echo "  Repository: the github & dockhub repository"
    echo "  Version: the version that is about to be created"
    exit 1
fi

USERID=$1
REPOSITORY=$2
VERSION=$3
BUILDID=$USERID-$REPOSITORY-$VERSION-$RANDOM
SOURCES="$(pwd)/sources/$BUILDID"
OUTPUTS="$(pwd)/outputs/$BUILDID"
REPO="git@github.com:$USERID/$REPOSITORY.git"

echo "Initianting building process..."
echo "************************"
echo "User........: $USERID"
echo "Repository..: $REPOSITORY"
echo "Version.....: $VERSION"
echo "BuldId......: $BUILDID"
echo "Sources.....: $SOURCES"
echo "Outputs.....: $OUTPUTS"
echo "Repo........: $REPO"
echo "************************"

# Clone source code repository


mkdir -p $WORKDIR/output
cd $WORKDIR

git clone $REPO $WORKDIR
if [ $? -ne 0 ]; then
  echo "Error cloning repository $REPO"
  exit $?
fi

# Build the building docker image
sudo docker build -t $BUILDID .
if [ $? -ne 0 ]; then
  echo "Error building the building image"
  exit $?
fi

sudo docker run -v $OUTPUTS:/outputs $BUILDID
if [ $? -ne 0 ]; then
  echo "Error running build for $BUILDID"
  exit $?
fi



