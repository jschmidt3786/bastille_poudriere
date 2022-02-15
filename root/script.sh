#!/bin/sh
echo creating an RSA keypair for signing packages
cd /usr/local/etc/poudriere.d || exit
openssl genrsa -out repo.key 2048
chmod 0400 repo.key
openssl rsa -in repo.key -out repo.pub -pubout

echo "TODO:"
echo "  - self-signed keypair for nginx at /usr/local/etc/nginx/tls/"
echo
echo "  enforce_statfs = 1;
  exec.poststart = '/sbin/zfs jail packages zroot/data/poudriere';
  securelevel = -1;
  allow.mount;
  allow.mount.devfs;
  allow.mount.nullfs;
  allow.mount.tmpfs;
  allow.mount.linprocfs;
  allow.mount.procfs;
  allow.mount.zfs;
  children.max = 30;
"

echo "zfs create -o mountpoint=/data -o canmount=off zroot/data
zfs create -o jailed=on -o mountpoint=/poudriere zroot/data/poudriere
zfs jail packages zroot/data/poudriere # jail needs to be up - needs to be run each time jail is started
"

