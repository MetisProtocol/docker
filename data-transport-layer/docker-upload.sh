#!/bin/bash
set -ex

# --no-cache
echo 'Building data-transport-layer image'
image=$(docker build --no-cache -f ./Dockerfile -t metis-dtl ../data-transport-layer)

echo 'Pushing data-transport-layer'
tag=$(docker tag metis-dtl:latest 950087689901.dkr.ecr.us-east-2.amazonaws.com/metis-dtl:latest)
push=$(docker push 950087689901.dkr.ecr.us-east-2.amazonaws.com/metis-dtl:latest)
