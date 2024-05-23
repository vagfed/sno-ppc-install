# sno-ppc-install

Automated install of OpenShift Single Node on IBM Power LPAR using Ansible.

The scripts must be copied on an IBM Power LPAR configured with RHEL 9 (for RHEL8 change EPEL link in include/playbook_install_services.yml).

## Initial setup
Create a new user called "ansible" and allow it to run as root with sudo. You can use the following commands as root:

```
useradd ansible
echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible
chmod 644 /etc/sudoers.d/ansible
```

Then switch as user ansible using `su - ansible`.

Now clone the repository as ansible user.

The required packages are installed running (once) the script `setup_ansible.sh`

## LPAR creation (optional)
You need to provide access to HMC and the LPAR configuration by editing the `lpar.yml` and `hmc.yml` files located into the `vars` directory. The files are already filled with sample data.

LPAR creation is done running `ansible-playbook create_sno_lpar.yml`.

The LPAR creation process will provide you the WWPNs of the LPAR's virtual fibre channel. You need to configure your SAN environment (storage and SAN switch) to provide a single LUN of at least 150GB to those WWPNs. You will need the WWN of that LUN for the installation.

## LPAR deletion (optional)
You can delete the LPAR reusing the data provided in the `lpar.yml` and `hmc.yml` files located into the `vars` directory.

LPAR deletion is done running `ansible-playbook delete_sno_lpar.yml`.

> WARNING: The deletion is immediate with no confirmation.

## OpenShift installation

Assuming that LPAR has been created, you must be sure that the LPAR configuration and HMC definitions are current in 
the `lpar.yml` and `hmc.yml` files located into the `vars` directory. 

> Make sure that slot_number is the slot number of the LPAR's network adapter

The partition where Ansible scripts are executed will be configured ad BOOTP, TFTP and HTTP servers. The OCP LPAR will be installed using those protocols and firewall must not stop them. 

The `network.yml` file located into the `vars` directory provides the network configuration of the network hosting the OCP LPAR and provide the IP address of the partition used for installation (bastion).

The `ocp.yml` file located into the `vars` directory provides the OpenShift installation data. You need to provide your pull secret.

The installation requires you to obtain the OpenShift Linux Installer (`openshift-install-inux*.tar`) from RedHat. You need to go on https://access.redhat.com/downloads and login. Select  "OpenShift COntainer Platform" and download the file. The tar file needs to be extracted, the file `openshift-install` has to made executable anc copied into the diretory `ocp`.

OpenShift SNO installation is done running `ansible-playbook install_sno.yml`.

Installation will take about 1 hour and the LPAR will be rebooted several times.

OpenShift credentials will be stored in the `sno_data` directory.

Once Ansible has completed the configuration steps, the actual installation takes place. If you want to have a feeling of the progress of the installation you have two options:
- open a virtual console from HMC. You can not login but you will see console logs
- use ssh to log on OpenShift as core user

In order to connect to the node during installation use the following command:

```
ssh -i sno_data/<lpar name>/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@<lpar ip>
```

You will see after logon a suggested `journalctl` command to use for logging purposes.




## Known installation issues

OpenShift code is not always configured with the proper authorization to run on a LPAR with virtual cores (it depends on OpenShift version). If you see on the HMC an error code BA060030 installation will not continue. In that case use HMC to modify the LPAR to use dedicated cores and restart the installation.

Once OpenShift is installed, you can power off the LPAR and change the configuration to use virtual cores. When you start the LPAR again OpenShift will correctly work.

If you use the provided Ansible script to create the LPAR, it will be created with dedicated cores even if you provide a virtual configuration as a workaround. Install and then change LPAR configuration if needed.


## Sample log output
You can find a sample installation log into file [sample_log.md](sample_log.md)


