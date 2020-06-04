Summary: oVirt 4.4 packages from the CentOS Virtualization SIG repository
Name: centos-release-ovirt44
Version: 1.0
Release: 1%{?dist}
License: GPLv2
URL: http://wiki.centos.org/SpecialInterestGroup/Virtualization
Source0: CentOS-oVirt-4.4.repo
Source1: COPYING

BuildArch: noarch

Requires: centos-release-virt-common
Requires: centos-release-advanced-virtualization
Requires: centos-release-gluster
Requires: centos-release-opstools
Requires: centos-release


%description
yum configuration and basic docs for oVirt 4.4 packages as delivered via the
CentOS Virtualization SIG.

%prep
cp %{SOURCE1} .

%build
# nothing to build

%install
install -D -m 644 %{SOURCE0} %{buildroot}%{_sysconfdir}/yum.repos.d/CentOS-oVirt-4.4.repo

%files
%config(noreplace) %{_sysconfdir}/yum.repos.d/CentOS-oVirt-4.4.repo
%license COPYING

%changelog
* Thu Jun 04 2020 Sandro Bonazzola <sbonazzo@redhat.com> - 1.0-1
- Initial packaging
