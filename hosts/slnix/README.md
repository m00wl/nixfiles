# Additional Bootstrap

This document describes the additional bootstrap process for `slnix`.

## Provision Storage Pool

Create ZFS data pool:

```bash
zpool create -O mountpoint=none \
             -O atime=off \
             -O compression=lz4 \
             -O xattr=sa \
             -O acltype=posixacl \
             -oashift=12 \
             dpool raidz1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
```

Create ZFS datasets. Be sure to adapt the size of the `reserved` dataset
appropriately:

```bash
zfs create -o mountpoint=none \
           -o encryption=aes-256-gcm \
           -o keyformat=passphrase \
           dpool/root
zfs create -o mountpoint=legacy \
           -o com.sun:auto-snapshot=true \
           dpool/root/data
zfs create -o mountpoint=none \
           -o reservation=64G \
           dpool/reserved
```

Prepare mountpoint:

```bash
mkdir /data
```

Mount ZFS data root to `/data`

```bash
mount -t zfs dpool/root/data /data
```
