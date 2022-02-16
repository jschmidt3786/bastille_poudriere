#!/bin/sh
echo creating an RSA keypair for signing packages

mkdir -p /usr/local/etc/ssl/certs
mkdir -p /usr/local/etc/ssl/keys
chmod 0600 /usr/local/etc/ssl/keys
openssl genrsa -out /usr/local/etc/ssl/keys/poudriere.key 4096
openssl rsa -in /usr/local/etc/ssl/keys/poudriere.key -pubout -out /usr/local/etc/ssl/certs/poudriere.cert

echo changing:
grep PKG_REPO_SIGNING_KEY /usr/local/etc/poudriere.conf
sed -i '' 's:#PKG_REPO_SIGNING_KEY.*:PKG_REPO_SIGNING_KEY=/usr/local/etc/ssl/keys/poudriere.key:' /usr/local/etc/poudriere.conf
echo
echo to:
grep PKG_REPO_SIGNING_KEY /usr/local/etc/poudriere.conf
echo


cd /usr/local/etc/poudriere.d || exit
openssl genrsa -out repo.key 2048
chmod 0400 repo.key
openssl rsa -in repo.key -out repo.pub -pubout

echo "TODO:"
echo
echo "  - run this: sed -i '' 's:txt;:txt log;:' /usr/local/etc/nginx/mime.types"
echo "    to read logs rather than download them"
echo
echo "  - tls keypair for nginx at /usr/local/etc/nginx/tls/ is self-signed."
echo "    don't leave it that way and be That Guy..."
echo
echo "  - and/change these in /bastille/jails/<jail>/jail.conf"
echo "    note the hostname here is listed as 'poudriere'"
echo
echo "  enforce_statfs = 1;
  exec.poststart = '/sbin/zfs jail poudriere virt/data/poudriere';
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

echo "zfs create -o mountpoint=/data -o canmount=off virt/data
zfs create -o jailed=on -o mountpoint=/poudriere virt/data/poudriere
zfs jail poudriere virt/data/poudriere # jail needs to be up - needs to be run each time jail is started
"
echo "and edit /usr/local/etc/poudriere.conf"
