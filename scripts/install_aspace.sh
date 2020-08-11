#!/bin/bash

export ARCHIVES_SPACE_VERSION=$(cat VERSION)
if [ ! -d "archivesspace" ]; then
  git clone --branch v$ARCHIVES_SPACE_VERSION https://github.com/archivesspace/archivesspace.git
fi
