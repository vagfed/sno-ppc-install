# Installation log with description
When you start the installation using ansible close any console you have on the LPAR. It will be closed anyway by the installation procedure. Do not re-open console until ansible has completed network book: wait for ansible to try SSH connection (see later).

Start running `ansible-playbook install_sno.yml`. The procedure will configure services and start real installation.

Installation will take about one hour diring which the LPAR will download OpenShift code from the internet and will perform sevaral reboots. Effective installation time will depend also on internet connection transfer time.


## Log from ansible 
This is a complete sample output. Do not open a console on the LPAR until task `TASK [Boot LPAR and start network installation]` has completed. 

```
PLAY [Store known hosts of all HMCs] *******************************************************************************

TASK [Scan ssh public keys of HMC] *********************************************************************************
changed: [localhost]

TASK [Update known hosts for HMC 172.17.251.91] ********************************************************************
ok: [localhost] => (item=172.17.251.91 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEy4+G8KhdrzIJ/0Rb7FltYhpXNEahZJTEkKN42D/c6a)
ok: [localhost] => (item=172.17.251.91 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRvu/cT7CEFr+OMssg2Igr/nlSxukdN7S8VZ45mtgeOGETk1Cnex0RT8tyssVZOk9LP+89kPkDA1DR7avF8kfuqDe6DBlBhIO7MZk+SJW5beDQwmjnJHghxxlJI5WK7+gUwzRhdf4fc5Hte0ghhbcVsRLJlcZNQNoNj6+dewN0gYwIYnzJ3Jr1ryA7fq7Uq3+zzclryVFblm/RiZeuSXqmUDed6IndchRXYrjhbWUF35tc/s6YT+n0hK0cZikebq6vSMyi/qjZ16oosoYMHbSnfoTNwOwUlvmg1BH2eTAI6IF+ppAp4pUNGSJ6BF8sfmMi5CB+/TCIMlzVmgW4kNayyDY2m0amwfs8vwfHHobwxDW8pcpuHg6HXhdETRYtdcjTvcPciOojp32cQZojSWfmnMh4Gu4bGFdZfwlme2m/knhzAp2RuKzVwOHYrSVuy4x7nriBk2BGQrZGURRcJGjWZgvQkOZuQqMEV4cSm2h5h0lWbaskC5juMlfgYHm9+pk=)
ok: [localhost] => (item=172.17.251.91 ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFETg9vxcTrPro9nj1xpTeNaqm9JrggRTgeokTwmuUUQIxUlzvDPGjcTfgngJJWVmUTz5OgqUCBS6ulY+sFmqPQogA4/ozt0EvS3zIGGloTyMSZ1NgzbAfwg5mJRHSpKiYKqzawA9c1q/SDug5ie+nQtXXlhMb4S2gXq5xXaDhkOwrxcw==)

PLAY [Install services] ********************************************************************************************

TASK [Install EPEL] ************************************************************************************************
ok: [localhost]

TASK [Install Linux packages] **************************************************************************************
ok: [localhost]

TASK [Firewall enable tftp and httpd] ******************************************************************************
ok: [localhost] => (item=tftp)
ok: [localhost] => (item=http)

TASK [Build python prereqs for Ansible (WARNING: very long task on first execution!)] ******************************
changed: [localhost]

TASK [DHCP configuration prefix] ***********************************************************************************
ok: [localhost]

TASK [Prepare tftp boot structure] *********************************************************************************
changed: [localhost]

TASK [Activate and enable tftp, http and dhcp] *********************************************************************
ok: [localhost] => (item=tftp.socket)
ok: [localhost] => (item=httpd)
ok: [localhost] => (item=dhcpd)

PLAY [DNS check] ***************************************************************************************************

TASK [Check api DNS] ***********************************************************************************************
skipping: [localhost]

TASK [Check api-int DNS] *******************************************************************************************
skipping: [localhost]

TASK [Check domain DNS] ********************************************************************************************
skipping: [localhost]

TASK [Check reverse DNS resolution] ********************************************************************************
skipping: [localhost]

TASK [Show reverse resolution] *************************************************************************************
ok: [localhost] => {
    "msg": "172.17.227.58 is tfv-temp-sno.power.seg.it.ibm.com."
}

PLAY [Collect MAC address from LPAR] *******************************************************************************

TASK [Boot LPAR for MAC discovery] *********************************************************************************
changed: [localhost]

TASK [Identify MAC address] ****************************************************************************************
ok: [localhost]

TASK [Update LPAR structure] ***************************************************************************************
ok: [localhost]

TASK [Show MAC address] ********************************************************************************************
ok: [localhost] => {
    "msg": "LPAR tfv-temp-sno has MAC a2:a5:fe:1e:be:02"
}

PLAY [Setup DHCP, TFTP and GRUB] ***********************************************************************************

TASK [Setup DHCP on control node] **********************************************************************************
changed: [localhost]

TASK [Restart DHCP] ************************************************************************************************
changed: [localhost]

TASK [Create image directory] **************************************************************************************
ok: [localhost]

TASK [Download boot images] ****************************************************************************************
ok: [localhost] => (item=https://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/latest/rhcos-live-kernel-ppc64le)
ok: [localhost] => (item=https://mirror.openshift.com/pub/openshift-v4/ppc64le/dependencies/rhcos/latest/rhcos-live-initramfs.ppc64le.img)

TASK [Setup tftpboot Grub] *****************************************************************************************
ok: [localhost]

PLAY [Setup OCP installation] **************************************************************************************

TASK [Create directory for tfv-temp-sno data] **********************************************************************
ok: [localhost]

TASK [Create SSH key pair for OCP] *********************************************************************************
changed: [localhost]

TASK [Read public key] *********************************************************************************************
ok: [localhost]

TASK [Remove setup directory] **************************************************************************************
changed: [localhost]

TASK [Create setup directory] **************************************************************************************
changed: [localhost]

TASK [Create install-config.yaml] **********************************************************************************
changed: [localhost]

TASK [Create install-config.yaml.save] *****************************************************************************
changed: [localhost]

TASK [Create ignition config] **************************************************************************************
changed: [localhost]

PLAY [Setup Web server] ********************************************************************************************

TASK [Copy installation yaml] **************************************************************************************
changed: [localhost]

TASK [Create image directory] **************************************************************************************
ok: [localhost]

TASK [Download RHCOS root filesystem] ******************************************************************************
ok: [localhost]

PLAY [Start installation] ******************************************************************************************

TASK [Boot LPAR and start network installation] ********************************************************************
changed: [localhost]
```

Now you can safely open a console on the LPAR. You will do nothing on the console since you do not have a user/password to access, but it can be useful to have a look and understand the flow.

The ansible script performs additional steps. The first one is to connect using SSH to set bootlist. You will see failures, it is normal since it takes few seconds for SSH server to start.

```
TASK [Wait for SSH to be active] ***********************************************************************************
FAILED - RETRYING: [localhost]: Wait for SSH to be active (10 retries left).
changed: [localhost]

TASK [Check that we provided the right boot disk] ******************************************************************
changed: [localhost]

TASK [OCP BUG - set bootlist] **************************************************************************************
changed: [localhost]

PLAY [Clean DHCP entry] ********************************************************************************************

TASK [Setup DHCP on control node] **********************************************************************************
changed: [localhost]

TASK [Restart DHCP] ************************************************************************************************
changed: [localhost]

PLAY RECAP *********************************************************************************************************
localhost                  : ok=36   changed=19   unreachable=0    failed=0    skipped=4    rescued=0    ignored=0   
```

The actual output will be different on first installation. In this case many tasks were already performed in previous run and are just checked. This is the beauty of ansible!

Starting from now you need to wait about 1 hour for installation to complete and you will be able to access the OpenShift console.

If you want you can use the generated SSH keys to enter the LPAR and look at logs. It is not required but cqan be handy while waiting for completion. Only the first installation part is interesting.

The keys are in `sno_data` directory under a directory with the LPAR name. Use private key `ocp-rsa`. Once you login you are in the bootstrap node that will start actual setup. You receive the suggestion to use `journalctl` command to see the running status.

```
[ansible@tfv-temp sno7]$ ssh -i sno_data/tfv-temp-sno/ocp-rsa 172.17.227.58172.17.227.5-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@172.17.227.58-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@172.17.227.58

Warning: Permanently added '172.17.227.58' (ED25519) to the list of known hosts.
Red Hat Enterprise Linux CoreOS 415.92.202402130021-0
  Part of OpenShift 4.15, RHCOS is a Kubernetes native operating system
  managed by the Machine Config Operator (`clusteroperator/machine-config`).

WARNING: Direct SSH access to machines is not recommended; instead,
make configuration changes via `machineconfig` objects:
  https://docs.openshift.com/container-platform/4.15/architecture/architecture-rhcos.html

---
This is the bootstrap node; it will be destroyed when the master is fully up.

The primary services are release-image.service followed by bootkube.service. To watch their status, run e.g.

  journalctl -b -f -u release-image.service -u bootkube.service
[core@tfv-temp-sno ~]$ journalctl -b -f -u release-image.service -u bootkube.service
journalctl -b -f -u release-image.service -u bootkube.service

May 10 13:49:18 tfv-temp-sno etcd-render[3651]: Writing asset: /assets/etcd-bootstrap/etc-kubernetes/manifests/etcd-member-pod.yaml
May 10 13:49:18 tfv-temp-sno podman[3592]: 2024-05-10 13:49:18.380066826 +0000 UTC m=+9.155042010 container died 61965364cf03fe0dfdad1643caeb7d28791b9a864167cf9680bd4d6f94e29b89 (image=quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:4e1570120b98c4edaee873036a547048fe720159b59ea77b3dc3203c8040701a, name=etcd-render, io.openshift.build.commit.url=https://github.com/openshift/cluster-etcd-operator/commit/9d596e149a662ff77d235b3c7e4b69f34638c2ed, io.openshift.maintainer.component=Etcd, vendor=Red Hat, Inc., com.redhat.license_terms=https://www.redhat.com/agreements, io.openshift.maintainer.project=OCPBUGS, description=This is the base image from which all OpenShift Container Platform images inherit., io.openshift.build.source-location=https://github.com/openshift/cluster-etcd-operator, io.openshift.tags=openshift,base, io.k8s.display-name=OpenShift Container Platform RHEL 9 Base, release=202403050707.p0.g9d596e1.assembly.stream.el9, url=https://access.redhat.com/containers/#/registry.access.redhat.com/openshift/ose-cluster-etcd-rhel9-operator/images/v4.15.0-202403050707.p0.g9d596e1.assembly.stream.el9, io.openshift.build.commit.id=9d596e149a662ff77d235b3c7e4b69f34638c2ed, License=GPLv2+, com.redhat.component=cluster-etcd-operator-container, maintainer=Red Hat, Inc., distribution-scope=public, name=openshift/ose-cluster-etcd-rhel9-operator, io.buildah.version=1.29.0, vcs-ref=a35c6cbbf8ef5e7ed2d954e181ff9073770c7963, summary=Provides the latest release of the Red Hat Extended Life Base Image., version=v4.15.0, io.openshift.expose-services=, architecture=ppc64le, build-date=2024-03-05T08:21:56, vcs-type=git, io.openshift.release.operator=true, io.k8s.description=This is the base image from which all OpenShift Container Platform images inherit.)
May 10 13:49:18 tfv-temp-sno podman[3665]: 2024-05-10 13:49:18.589466256 +0000 UTC m=+0.203147543 container remove 61965364cf03fe0dfdad1643caeb7d28791b9a864167cf9680bd4d6f94e29b89 (image=quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:4e1570120b98c4edaee873036a547048fe720159b59ea77b3dc3203c8040701a, name=etcd-render, io.k8s.display-name=OpenShift Container Platform RHEL 9 Base, io.openshift.tags=openshift,base, maintainer=Red Hat, Inc., io.buildah.version=1.29.0, url=https://access.redhat.com/containers/#/registry.access.redhat.com/openshift/ose-cluster-etcd-rhel9-operator/images/v4.15.0-202403050707.p0.g9d596e1.assembly.stream.el9, build-date=2024-03-05T08:21:56, com.redhat.license_terms=https://www.redhat.com/agreements, vcs-type=git, summary=Provides the latest release of the Red Hat Extended Life Base Image., io.k8s.description=This is the base image from which all OpenShift Container Platform images inherit., io.openshift.expose-services=, io.openshift.build.commit.id=9d596e149a662ff77d235b3c7e4b69f34638c2ed, io.openshift.release.operator=true, distribution-scope=public, architecture=ppc64le, io.openshift.build.source-location=https://github.com/openshift/cluster-etcd-operator, io.openshift.maintainer.project=OCPBUGS, io.openshift.maintainer.component=Etcd, vcs-ref=a35c6cbbf8ef5e7ed2d954e181ff9073770c7963, License=GPLv2+, release=202403050707.p0.g9d596e1.assembly.stream.el9, description=This is the base image from which all OpenShift Container Platform images inherit., com.redhat.component=cluster-etcd-operator-container, vendor=Red Hat, Inc., name=openshift/ose-cluster-etcd-rhel9-operator, io.openshift.build.commit.url=https://github.com/openshift/cluster-etcd-operator/commit/9d596e149a662ff77d235b3c7e4b69f34638c2ed, version=v4.15.0)
May 10 13:49:18 tfv-temp-sno bootkube.sh[2213]: Rendering Kubernetes API server core manifests...
```

There will be a lot of lines. Do not be worried by warning/errors. As long as logs continue to flow the process is proceeding. At the end the node will perform the first reboot.

```
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Check if API and API-Int URLs are reachable during bootstrap
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Checking if api.snotest.power.seg.it.ibm.com of type API_URL reachable
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Unable to reach API_URL's https endpoint at https://api.snotest.power.seg.it.ibm.com:6443/version
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Unable to validate. https://api.snotest.power.seg.it.ibm.com:6443/version is currently unreachable.
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Checking if api-int.snotest.power.seg.it.ibm.com of type API_INT_URL reachable
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Unable to reach API_INT_URL's https endpoint at https://api-int.snotest.power.seg.it.ibm.com:6443/version
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: Unable to validate. https://api-int.snotest.power.seg.it.ibm.com:6443/version is currently unreachable.
May 10 13:54:09 tfv-temp-sno bootkube.sh[2213]: bootkube.service complete
May 10 13:54:09 tfv-temp-sno systemd[1]: bootkube.service: Deactivated successfully.
May 10 13:54:09 tfv-temp-sno systemd[1]: bootkube.service: Consumed 1min 55.794s CPU time.

Broadcast message from root@tfv-temp-sno (Fri 2024-05-10 13:54:59 UTC):

Bootstrap completed, server is going to reboot.
The system will reboot at Fri 2024-05-10 13:55:59 UTC!


Broadcast message from root@tfv-temp-sno (Fri 2024-05-10 13:55:59 UTC):

Bootstrap completed, server is going to reboot.
The system will reboot now!

Connection to 172.17.227.58 closed by remote host.
Connection to 172.17.227.58 closed.
```

You can connect again if you want. Installation will not be finished yet and additional reboots will happen.

```
[ansible@tfv-temp sno7]$ ssh -i sno_data/tfv-temp-sno/ocp-rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@172.17.227.58

Warning: Permanently added '172.17.227.58' (ED25519) to the list of known hosts.
Red Hat Enterprise Linux CoreOS 415.92.202402130021-0
  Part of OpenShift 4.15, RHCOS is a Kubernetes native operating system
  managed by the Machine Config Operator (`clusteroperator/machine-config`).

WARNING: Direct SSH access to machines is not recommended; instead,
make configuration changes via `machineconfig` objects:
  https://docs.openshift.com/container-platform/4.15/architecture/architecture-rhcos.html

---
[core@tfv-temp-sno ~]$ 
```

The process will be completed when you will be able to log on the console using a browser.
