#!/bin/bash

#
# This script will deploy OCP 4 cluster on AWS. All env var will be sources from config.sh file
# OCP_RELEASE Var is to define the OCP version
#

set -ex

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

source "${TOP_DIR}"/openshift/aws-ocp-deployer/scripts/funcs.sh
source "${TOP_DIR}"/openshift/aws-ocp-deployer/scripts/config.sh

#Telus IT provided PATH for aws cli
export PATH="/work/staging/ITSuppt/tools/AWS:$PATH"

# Cheking OCP installation

echo "Checking OCP installation"
if [ -d "${CLUSTER_DIR}/auth/" ] ;
then
    echo "${CLUSTER_DIR}/auth/ directory exists. Checking if OCP is already installed and running with this auth"
    export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"
    ${BINARIES_DIR}/oc get nodes
    if [ $? -eq 0 ];
    then
      echo "OCP is already installed and running! Please deprovision existing cluster if you want to reinstall OCP"
      exit 0
    fi
fi

#Create Cluster directory
mkdir -p ${CLUSTER_DIR}

# Template the install-config.yaml
sed -e "s/__DOMAIN__/${CLUSTER_DOMAIN}/" \
    -e "s/__CLUSTER_NAME__/${CLUSTER_NAME}/" \
    -e "s/__COMPUTE_FLAVOR__/${WORKER_FLAVOR_SIZE}/" \
    -e "s/__MASTER_FLAVOR__/${MASTER_FLAVOR_SIZE}/" \
    -e "s/__OCP_REGION__/${REGION}/" \
    -e "s/__PULL_SECRET__/${PULL_SECRET}/" \
    "${TOP_DIR}"/openshift/aws-ocp-deployer/files/install-config.yaml > "${CLUSTER_DIR}"/install-config.yaml


# Copy install-config.yaml file to another location before consuming by openshift installer
cp "${CLUSTER_DIR}"/install-config.yaml "${TOP_DIR}"/

#Display the content of the install-config.yaml file

cat "${CLUSTER_DIR}"/install-config.yaml

# Add pullSecret section to the installer configuration file
#add_pull_secret

# Add additionalTrustBundle section to the installer configuration file
#add_additional_trust_bundle

#generate manifests for Manual mode with STS for Amazon Web Services (AWS).

##########################

#Get the CCO container image from the OpenShift Container Platform release image

#CCO_IMAGE=$(${BINARIES_DIR}oc adm release info --image-for='cloud-credential-operator' "${OCP_RELEASE}")

#add pull-secret to a file
#mkdir -p $CCO_MANIFEST_DIR

#touch $CCO_MANIFEST_DIR/pull-secret
#echo "${PULL_SECRET}" > $CCO_MANIFEST_DIR/pull-secret
#cat $CCO_MANIFEST_DIR/pull-secret

#Extract the ccoctl binary from the CCO container image within the OpenShift Container Platform release image
#cd ${BINARIES_DIR}

#${BINARIES_DIR}oc image extract $CCO_IMAGE --file="/usr/bin/ccoctl" -a $CCO_MANIFEST_DIR/pull-secret

#Change the permissions to make ccoctl executable
#chmod 775 ccoctl

#verify that ccoctl is ready to use
#"${BINARIES_DIR}"ccoctl aws --help

#Extract the list of CredentialsRequest objects from the OpenShift Container Platform release image
#${BINARIES_DIR}oc adm release extract --credentials-requests --cloud=aws --to=$CCO_MANIFEST_DIR/credrequests quay.io/openshift-release-dev/ocp-release:"${OCP_RELEASE}"-x86_64

#create directory to store CCO manifest
#mkdir -p $CCO_MANIFEST_DIR/cco_manifest
#Use the ccoctl tool to process all CredentialsRequest objects in the credrequests directory
#${BINARIES_DIR}ccoctl aws create-all --name=aws-ccoctl-all --region="${REGION}" --credentials-requests-dir=$CCO_MANIFEST_DIR/credrequests --output-dir $CCO_MANIFEST_DIR/cco_manifest

#verify that the OpenShift Container Platform secrets are created
#ll $CCO_MANIFEST_DIR/cco_manifest/manifests

#Copy the manifests that ccoctl generated to the manifests directory that the installation program created
#cp $CCO_MANIFEST_DIR/cco_manifest/manifests/* "${CLUSTER_DIR}"/manifests/

#Copy the private key that the ccoctl generated in the tls directory to the installation directory
#cp -a $CCO_MANIFEST_DIR/cco_manifest/tls "${CLUSTER_DIR}"

##########################


# Generate manifests
echo "Generate manifests"
"${BINARIES_DIR}/openshift-install" --dir "${CLUSTER_DIR}" create manifests

# Custom modification to manifests

# Generate IPSec Initiator.
echo "Generate IPSec Initiator"
"${TOP_DIR}"/openshift/aws-ocp-deployer/scripts/ipsec-initiator.sh


#Display directory structure
ls -la ${CLUSTER_DIR}

ls -la ${CLUSTER_DIR}/openshift


# Deploy the cluster
echo "Deploying OCP ${OCP_RELEASE} cluster on AWS"
"${BINARIES_DIR}/openshift-install" create cluster --dir "$CLUSTER_DIR" --log-level debug || true
if [ -f "$KUBECONFIG" ]; then
  "${BINARIES_DIR}/openshift-install" wait-for --dir "$CLUSTER_DIR" --log-level debug install-complete
else
  echo "Installation didn't get through break"
  exit 1
fi

# Copy install-config.yaml file back to CLUSTER_DIR for reference 
cp "${SCRIPT_DIR}"/install-config.yaml "${CLUSTER_DIR}"/

# Cluster health check after depolyment

export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"

if [ -d "${CLUSTER_DIR}/auth/" ] ;
then
    echo "${CLUSTER_DIR}/auth/ directory exists. Checking if OCP is already installed and running with this auth"
    export KUBECONFIG="${CLUSTER_DIR}/auth/kubeconfig"
    ${BINARIES_DIR}/oc get nodes
    if [ $? -ne 0 ];
    then
      echo "OCP is not installed"
      exit 0
    else
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
    fi
fi
