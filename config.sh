#!/bin/bash

export CLUSTER_NAME="${CLUSTER_NAME}"
export CLUSTER_DOMAIN="${CLUSTER_DOMAIN}"
export CLUSTER_DIR="${HOME}/${CLUSTER_DOMAIN}/${CLUSTER_NAME}"
export BINARIES_DIR="${CLUSTER_DIR}/bin"
#export SCRIPT_DIR="/home/aws-ipi"
export OCP_RELEASE=4.8.4
export COMPUTE_FLAVOR=m5.xlarge

export AWSKEY="${AWS_KEY}"
export AWSSECRETKEY="${AWS_SECRET}"
#export REGION=us-east-2