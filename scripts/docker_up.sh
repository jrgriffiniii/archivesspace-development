#!/bin/bash

docker rm archivesspace-development_web_1
docker rm archivesspace-development_app_1
docker rm archivesspace-development_solr_1
docker rm archivesspace-development_db_1
docker-compose up
