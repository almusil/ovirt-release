#!/bin/bash -xe
[[ -d exported-artifacts ]] \
|| mkdir -p exported-artifacts

[[ -d tmp.repos ]] \
|| mkdir -p tmp.repos



autoreconf -ivf
./configure
make distcheck
rpmbuild \
    -D "_topdir $PWD/tmp.repos" \
    -ta ovirt-release*.tar.gz

mv *.tar.gz exported-artifacts
find \
    "$PWD/tmp.repos" \
    -iname \*.rpm \
    -exec mv {} exported-artifacts/ \;
pushd exported-artifacts
    #Restoring sane yum environment
    yum reinstall -y system-release yum
    [[ -d /etc/dnf ]] && dnf -y reinstall dnf-conf
    [[ -d /etc/dnf ]] && sed -i -re 's#^(reposdir *= *).*$#\1/etc/yum.repos.d#' '/etc/dnf/dnf.conf'
    yum install -y ovirt-release41-4*noarch.rpm
    rm -f /etc/yum/yum.conf
    yum repolist enabled
    yum --downloadonly install *noarch.rpm
popd

# Create a link to a predefined rpm name for easier consumption on el7 only.
# yum-repos has a symlink pointing to the el7 rpm.
if rpm --eval "%dist" | grep -qFi 'el'; then
    pushd exported-artifacts
    cp -vfl ovirt-release41-4*.noarch.rpm ovirt-release41.rpm
    cp -vfl ovirt-release41-pre-4*.noarch.rpm ovirt-release41-pre.rpm
    cp -vfl ovirt-release41-snapshot-4*.noarch.rpm ovirt-release41-snapshot.rpm
    popd
fi
