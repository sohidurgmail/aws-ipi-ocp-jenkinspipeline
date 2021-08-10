#!/bin/bash

set -ex

#readonly SCRIPT_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
#readonly TOP_DIR=$(cd "${SCRIPT_DIR}"; git rev-parse --show-toplevel)

#source "${TOP_DIR}"/config.sh
source config.sh


#sudo bash

# Download the latest AWS Command Line Interface
echo " Downlod the latest AWS Command Line Interface"
#sudo curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
#sudo unzip awscli-bundle.zip

# Install the AWS CLI into /bin/aws
#sudo ./awscli-bundle/install -i /usr/local/aws -b /bin/aws

# Validate that the AWS CLI works
#aws --version

# Clean up downloaded files
#sudo rm -rf /root/awscli-bundle /root/awscli-bundle.zip


mkdir -p $HOME/.testaws
cat << EOF >>  $HOME/.testaws/credentials
[default]
aws_access_key_id = ${AWSKEY}
aws_secret_access_key = ${AWSSECRETKEY}
region = $REGION
EOF


# Download and extract the OpenShift CLI, or oc client
#wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-client-linux-$OCP_RELEASE.tar.gz
#wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_RELEASE/openshift-install-linux-$OCP_RELEASE.tar.gz

# extract it to a location that will make it easy to use.
#sudo tar xzf openshift-client-linux-$OCP_RELEASE.tar.gz -C /usr/bin/ oc kubectl
#which oc; oc version

#sudo tar xzf openshift-install-linux-$OCP_RELEASE.tar.gz -C /usr/bin/


#oc completion bash | sudo tee /etc/bash_completion.d/openshift > /dev/null
#. /usr/share/bash-completion/bash_completion
