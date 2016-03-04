Summary: oVirt 3.5 packages from the CentOS Virtualization SIG repository
Name: centos-release-ovirt35
Version: 1.0
Release: 2%{?dist}
License: GPLv2
URL: http://wiki.centos.org/SpecialInterestGroup/Virtualization
Source0: CentOS-oVirt-3.5.repo
Source1: COPYING

BuildArch: noarch

Requires: centos-release-virt-common
Requires: centos-release-qemu-ev

%description
yum configuration and basic docs for oVirt 3.5 packages as delivered via the 
CentOS Virtualization SIG.

%prep
cp %{SOURCE1} .

%install
install -D -m 644 %{SOURCE0} %{buildroot}%{_sysconfdir}/yum.repos.d/CentOS-oVirt-3.5.repo

%files
%defattr(-,root,root)
%config(noreplace) %{_sysconfdir}/yum.repos.d/CentOS-oVirt-3.5.repo
%license COPYING

%changelog
* Tue Oct  6 2015 Sandro Bonazzola <sbonazzo@redhat.com> - 1.0-2
- Update dependencies

* Fri Sep  4 2015 Sandro Bonazzola <sbonazzo@redhat.com> - 1.0-1
- Initial version based on centos-release-openstack
