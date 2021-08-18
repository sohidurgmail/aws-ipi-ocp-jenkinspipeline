#!/bin/bash

set -ex

readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

source "${TOP_DIR}"/scripts/config.sh

# Download the latest AWS Command Line Interface
#echo " Downlod the latest AWS Command Line Interface"
#curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
#unzip -o awscli-bundle.zip

# Install the AWS CLI into /bin/aws
#./awscli-bundle/install -i /usr/local/aws -b ${BINARIES_DIR}/aws

# Validate that the AWS CLI works
aws --version

# Clean up downloaded files
#sudo rm -rf /root/awscli-bundle /root/awscli-bundle.zip

if [ ! -d "$HOME/.aws" ] ;
then
mkdir -p $HOME/.aws
cat << EOF >>  $HOME/.aws/credentials
[default]
aws_access_key_id = "${AWS_KEY}"
aws_secret_access_key = "${AWS_SECRETKEY}"
region = ${REGION}
EOF
fi

if [ -d "${BINARIES_DIR}" ] ;
then
    echo "${BINARIES_DIR} already exist."
    ${BINARIES_DIR}/oc version
    if [ $? -eq 0 ];
    then
      echo "oc binary is installed, No need to install again. Moving to the next step"
      exit 0
    fi
fi

mkdir -p ${CLUSTER_DIR}/bin
# Download and extract the OpenShift CLI, or oc client
echo "Download and extract the OpenShift CLI, or oc client"
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-client-linux-$OCP_RELEASE.tar.gz
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-install-linux-$OCP_RELEASE.tar.gz

# extract it to a location that will make it easy to use.
echo "extract it to a location that will make it easy to use."
tar xzf openshift-client-linux-$OCP_RELEASE.tar.gz -C ${BINARIES_DIR} oc kubectl
${BINARIES_DIR}oc version

tar xzf openshift-install-linux-$OCP_RELEASE.tar.gz -C ${BINARIES_DIR}


#oc completion bash | sudo tee /etc/bash_completion.d/openshift > /dev/null
#. /usr/share/bash-completion/bash_completion
