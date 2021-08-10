#!/hint/bash

# Add pullSecret section to the installer configuration file.
#
# The secrets are copied from pull-secret.json file.
add_pull_secret()
{
    # The sed snippet is used to have a proper YAML indentation by
    # adding two spaces at the beginning of each line from the json
    # file.
    cat >> "${CLUSTER_DIR}/install-config.yaml" << __EOF__
pullSecret: |-
$(sed -e 's/^/  /' pull-secret.json)
__EOF__
}

