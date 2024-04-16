# sno-ppc-install

Automated install of OpenShift Single Node on IBM Power LPAR using Ansible.

The scripts must be copied on an IBM Power LPAR configured with RHEL 8.7 or higher. Do not use RHEL 9!

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



