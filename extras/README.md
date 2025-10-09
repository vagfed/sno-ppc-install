# Utilities to setup environment outside OpenShift

## DNS on bastion host
OpenShift requires a valid DNS configuration to be provided before installation. You can find instaruction on RedHat's
[User-provisioned DNS requirements](https://docs.redhat.com/en/documentation/openshift_container_platform/4.19/html-single/installing_on_bare_metal/index#installation-dns-user-infra_installing-bare-metal-network-customizations)

You can use `dnsmasq` service on the bastion host to create a DNS service tailored for OpenShift. 
You can find a sample script in [Andre's repository](https://github.com/Andre1615113/sno-labs). 
The script has been copied for your convenince in the `extras` directory as file `setup-dnsmasq-sno.sh`.
