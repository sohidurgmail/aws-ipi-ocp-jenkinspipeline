#!/bin/bash

#
# Generate an IPSec Initiator to inject to the manifest
#

set -ex

cat > "${CLUSTER_DIR}/manifests/cluster-network-03-config.yml" << __EOF__
apiVersion: operator.openshift.io/v1
kind: Network
metadata:
  name: cluster
spec:
  defaultNetwork:
    ovnKubernetesConfig:
      ipsecConfig: {}
__EOF__
