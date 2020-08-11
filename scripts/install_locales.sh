#!/bin/bash

if [ ! -d "aspace_locales" ]; then
  git clone https://github.com/pulibrary/aspace_locales.git
fi

cp aspace_locales/en.yml archivesspace/common/locales/en.yml
cp aspace_locales/es.yml archivesspace/common/locales/es.yml
cp aspace_locales/enums/en.yml archivesspace/common/locales/enums/en.yml
cp aspace_locales/enums/es.yml archivesspace/common/locales/enums/es.yml
