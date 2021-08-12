#!/bin/bash

set -ex

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

source "${TOP_DIR}"/scripts/funcs.sh
source "${SCRIPT_DIR}"/config.sh
export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"

if [ ! -d "${CLUSTER_DIR}" ] ;
then

mkdir -p "${CLUSTER_DIR}"

# Template the install-config.yaml
sed -e "s/__DOMAIN__/${CLUSTER_DOMAIN}/" \
    -e "s/__CLUSTER_NAME__/${CLUSTER_NAME}/" \
    -e "s/__COMPUTE_FLAVOR__/${FLAVOR_SIZE}/" \
    -e "s/__PULL_SECRET__/${PULL_SECRET}/" \
    "${TOP_DIR}"/files/install-config.yaml > "${CLUSTER_DIR}"/install-config.yaml


# Add pullSecret section to the installer configuration file
#add_pull_secret

# Add additionalTrustBundle section to the installer configuration file
#add_additional_trust_bundle

# Custom modification to manifests
# Generate manifests
echo "Generate manifests"
"${BINARIES_DIR}/openshift-install" --dir "${CLUSTER_DIR}" create manifests

# Generate ISCSI Initiator, it is needed by kubevirt test suite.
echo "Generate ISCSI Initiator, it is needed by kubevirt test suite."
"${SCRIPT_DIR}"/ipsec-initiator.sh

# Deploy the cluster
echo "Deploying OCP ${OCP_RELEASE} cluster on AWS"
#"${BINARIES_DIR}/openshift-install" create cluster --dir "$CLUSTER_DIR" --log-level debug || true
#if [ -f "$KUBECONFIG" ]; then
#  "${BINARIES_DIR}/openshift-install" wait-for --dir "$CLUSTER_DIR" --log-level debug install-complete
#else
#  echo "Installation didn't get through break"
#  exit 1
#fi


# Add post installation changes
# "${TOP_DIR}"/ocp/common/post-create-cluster-scripts.sh
    exit 0
fi

echo "${CLUSTER_DIR} exists!!!! Please make sure you are not redeploying existing cluster. If you want to redeploy the cluster, please reprovision existing cluster!!"