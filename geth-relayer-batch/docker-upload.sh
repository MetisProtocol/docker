#!/bin/bash
set -ex

# --no-cache
echo 'Building metis_l2_geth image'
image=$(docker build --no-cache -f ./Dockerfile -t metis_l2_geth ../geth-relayer-batch)

ecr_login=$(aws --profile default ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 950087689901.dkr.ecr.us-east-2.amazonaws.com)

echo 'Pushing metis_l2_geth'
tag=$(docker tag metis_l2_geth:latest 950087689901.dkr.ecr.us-east-2.amazonaws.com/metis-l2-geth:latest)
push=$(docker push  950087689901.dkr.ecr.us-east-2.amazonaws.com/metis-l2-geth:latest)
