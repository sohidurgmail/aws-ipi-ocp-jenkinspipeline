#!/bin/bash

set -ex

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

source "${TOP_DIR}"/funcs.sh
source "${SCRIPT_DIR}"/config.sh
#source config.sh
#source funcs.sh
export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"


mkdir -p "${CLUSTER_DIR}"

# TODO: Deploydata.json

#/bin/bash "${TOP_DIR}"/ocp/common/download-ocp-tools.sh

# Template the install-config.yaml
sed -e "s/__DOMAIN__/${CLUSTER_DOMAIN}/" \
    -e "s/__CLUSTER_NAME__/${CLUSTER_NAME}/" \
    -e "s/__COMPUTE_FLAVOR__/${FLAVOR_SIZE}/" \
    -e "s/__PULL_SECRET__/${PULL_SECRET}/" \
    "${SCRIPT_DIR}"/install-config.yaml > "${CLUSTER_DIR}"/install-config.yaml

# Set networking.networkType field in the installer configuration file from
# NETWORK_TYPE environment variable typically set by Jenkins OCP deployment job
#set_network_type

# Add pullSecret section to the installer configuration file
#add_pull_secret

# Add additionalTrustBundle section to the installer configuration file
#add_additional_trust_bundle


# Custom modification to manifests
# Generate manifests
#"${BINARIES_DIR}/openshift-install" --dir "${CLUSTER_DIR}" create manifests

echo "Deploying cluster......."

# Generate ISCSI Initiator, it is needed by kubevirt test suite.
#"${SCRIPT_DIR}"/ipsec-initiator.sh

# Deploy the cluster
#"${BINARIES_DIR}/openshift-install" create cluster --dir "$CLUSTER_DIR" --log-level debug || true
#if [ -f "$KUBECONFIG" ]; then
#  "${BINARIES_DIR}/openshift-install" wait-for --dir "$CLUSTER_DIR" --log-level debug install-complete
#else
#  echo "Installation didn't get through break"
#  exit 1
#fi


# Add insecure registries
#"${TOP_DIR}"/ocp/common/add-registries.sh
# FIXME: https://issues.redhat.com/browse/CNV-12833
# "${TOP_DIR}"/ocp/common/post-create-cluster-scripts.sh
