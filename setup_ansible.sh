sudo dnf -y install ansible-core libxml2-devel libxslt-devel gcc python3-devel python3-netaddr
ansible-galaxy collection install ibm.power_hmc ansible.utils ansible.posix community.general
