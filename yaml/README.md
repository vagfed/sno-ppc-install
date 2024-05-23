# Configuration tips
The provided scripts install OpenShift SNO with default settings. The server needs to be customized to provide the required services and capabilities. 
Here you can find some sample yaml files for initial setup.

## Multipath
Normally the LPAR will have SAN access to boot and data LUNs, either through a single or a double VIOS partition. In both cases multipath should be enabled (it is not configured by default). The `multipath.yml` file provides multipath setup to the server.

```
oc apply -f multipath.yml
```

## LVM Storage
You can exploit LVM Storage to create a StorageClass for persistent storage. This requires the installation of LVMStorage Operator and the availability of physical storage available to the server.
Here you can find some yaml files to make initial setup. Customize them to suit your needs.

| File | Description |
| -- | -- |
| LVMOperator.yml | Install LVM Operator. It can be used as it is |
| LVMCluster.yml | Setup storage configuration using a specific set of provided disks. Customization required |

Sample usage:

1. Be sure that multipath has been enabled
```
oc apply -f multipath.yml
```

2. Install LVM Operator
```
oc apply -f LVMOperator.yml
```

3. Check that LVM Operator has completed installation
```
oc get csv -n openshift-storage -o custom-columns=Name:.metadata.name,Phase:.status.phase
```
You should see something similar to:
```
Name                         Phase
4.13.0-202301261535          Succeeded
```

4. Provide one or more LUNs to the server
5. Make OpenShift rescan storage to see new LUNs.
Connect to the node and run `rescan-scsi-bus.sh` command.
```
[root@tfv-rhel8 sno]# oc debug node/tfv-sno.power.seg.it.ibm.com
Starting pod/tfv-snopowersegitibmcom-debug ...
To use host binaries, run `chroot /host`
Pod IP: 172.17.227.53
If you don't see a command prompt, try pressing enter.
sh-4.4# chroot /host
sh-5.1# rescan-scsi-bus.sh
```
6. Edit `LVMCluster.yml` file providing the WWPN of data LUNs

Remember to provide LUN identifier in **lowercase** or it will not work. You need to provide the full device path that is made by `/dev/disk/by-id/wwn-0x` followed by LUN identifier.

In the following examples there are two LUNs with identifiers `60050768108102d0d8000000000002be` and `60050768108102d0d8000000000002bf`.

```
kind: LVMCluster
apiVersion: lvm.topolvm.io/v1alpha1
metadata:
  name: lvmcluster
  namespace: openshift-storage
spec:
  storage:
    deviceClasses:
      - fstype: xfs
        thinPoolConfig:
          sizePercent: 90
          name: thin-pool-1
          overprovisionRatio: 10
        name: vg1
        default: true
        deviceSelector:
          paths:
          - /dev/disk/by-id/wwn-0x60050768108102d0d8000000000002be
          - /dev/disk/by-id/wwn-0x60050768108102d0d8000000000002bf
```

7. Apply the configuration using the updated file
```
oc apply -f LVMCluster-modified.yml
```

8. Show the generated StorageClass
```
oc get sc
```
