#!/bin/bash

set -ex
#
# Check Nodes (Workers) Health
#
# Post OCP installation health check
#

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

source "${TOP_DIR}"/scripts/funcs.sh
source "${SCRIPT_DIR}"/config.sh

export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"

echo "Checking if all nodes are healthy"
${BINARIES_DIR}/oc get nodes

echo "Checking if all cluster operators are healthy"
${BINARIES_DIR}/oc get co

echo "Checking if desired cluster version is present"
${BINARIES_DIR}/oc get clusterversions

echo "Checking if HAProxy ingress controller PODs are present on  openshift-ingress namespace"
${BINARIES_DIR}/oc get pod -n openshift-ingress

echo "Check that all the cluster nodes are reporting usage metrics."
${BINARIES_DIR}/oc adm top node

echo "Ensure that all the etcd cluster members are healthy."
${BINARIES_DIR}/oc get pods -n openshift-etcd | grep etcd-ip

