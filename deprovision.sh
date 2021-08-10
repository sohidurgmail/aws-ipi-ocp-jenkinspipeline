#!/bin/bash

set -ex

# Set Environment and get configuration needed
#source cnv-qe-automation/ocp/aws-ipi/config.sh
source config.sh

export CLUSTER_DIR="${HOME}/${CLUSTER_DOMAIN}/${CLUSTER_NAME}"
export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"
#readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
#readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)
#readonly BINARIES_DIR="${CLUSTER_DIR}/bin"


if [ ! -d "${CLUSTER_DIR}" ] ;
then
    echo "Nothing to clean up, the ${CLUSTER_DIR} doesn't exist."
    exit 0
fi

"${BINARIES_DIR}/openshift-install" destroy cluster --dir "${CLUSTER_DIR}" --log-level debug && rm -rf "${CLUSTER_DIR}" || true
