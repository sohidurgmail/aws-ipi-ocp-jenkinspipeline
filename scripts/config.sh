#!/bin/bash

export CLUSTER_NAME="${CLUSTER_NAME}"
export CLUSTER_DOMAIN="${CLUSTER_DOMAIN}"
export CLUSTER_DIR="${HOME}/${CLUSTER_DOMAIN}/${CLUSTER_NAME}"
export BINARIES_DIR="${CLUSTER_DIR}/bin/"
export OCP_RELEASE=4.8.4
export MASTER_FLAVOR_SIZE=m4.xlarge
export WORKER_FLAVOR_SIZE=r5.2xlarge

export AWSKEY="${AWS_KEY}"
export AWSSECRETKEY="${AWS_SECRET}"
#export REGION=us-east-2
export REGION=ca-central-1