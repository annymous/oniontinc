# Setup for peering with host "one"

These instructions and scripts are for Debian stretch x64. I've verified them for KVM VPS and VirtualBox VM. But MPTCP won't work on VPS that don't allow custom kernels.

Upgrade your system, and install needed and useful software.

```bash
# apt-get update
# apt-get -y dist-upgrade
# reboot
...
# apt-get -y install apt-transport-https bmon curl dirmngr iperf3 iptables-persistent net-tools procps python3 python-pip sudo tinc w3m
# nano /etc/apt/sources.list.d/my-sources.list
  deb https://deb.torproject.org/torproject.org stretch main
  deb-src https://deb.torproject.org/torproject.org stretch main
  deb https://dl.bintray.com/cpaasch/deb stretch main
# curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
# gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add&nbsp;-
# apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 379CE192D401AB61
# apt-get update
# apt-get -y install tor deb.torproject.org-keyring linux-mptcp
# apt-get -y dist-upgrade
# reboot
...
# uname -r
