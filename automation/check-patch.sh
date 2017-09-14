#!/bin/bash -xe
[[ -d exported-artifacts ]] \
|| mkdir -p exported-artifacts

[[ -d tmp.repos ]] \
|| mkdir -p tmp.repos

SUFFIX=".$(date -u +%Y%m%d%H%M%S).git$(git rev-parse --short HEAD)"

autoreconf -ivf
./configure
make distcheck
rpmbuild \
    -D "_topdir $PWD/tmp.repos" \
    -D "release_suffix ${SUFFIX}" \
    -ta ovirt-release*.tar.gz

mv *.tar.gz exported-artifacts
find \
    "$PWD/tmp.repos" \
    -iname \*.rpm \
    -exec mv {} exported-artifacts/ \;
pushd exported-artifacts
    #Restoring sane yum environment
    rm -f /etc/yum.conf
    yum reinstall -y system-release yum
    [[ -d /etc/dnf ]] && dnf -y reinstall dnf-conf
    [[ -d /etc/dnf ]] && sed -i -re 's#^(reposdir *= *).*$#\1/etc/yum.repos.d#' '/etc/dnf/dnf.conf'
    yum install -y ovirt-release42-pre-4*noarch.rpm
    rm -f /etc/yum/yum.conf
    yum repolist enabled
    DISTVER="$(rpm --eval "%dist"|cut -c2-)"
    if [[ "${DISTVER}" == "fc26" ]]; then
        yum --downloadonly install --skip-broken *noarch.rpm
    else
        yum --downloadonly install *noarch.rpm
    fi
popd

