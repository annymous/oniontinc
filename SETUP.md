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

If you don't see "4.14.110.mptcp", the MPTCP kernel didn't get installed. And it's needed for this setup to work properly. Once that succeeds, specify the fq (fair queuing) scheduler, which seems to work best for MPTCP. Also disable multipath for eth0 (or whatever it's named on your system) and disable systemd management of Tor (because it seems to work better just using command line).

```bash
# sysctl net.core.default_qdisc=fq
# echo 'net.core.default_qdisc=fq' &#62;&#62; /etc/sysctl.conf
# ip link set dev eth0 multipath off
# systemctl stop tor
# systemctl disable tor

Clone or download stuff. Then add your host(s) to the information table. You can include all of the hosts in your planned network. The hostname serves as an index. So you can run the same scripts in all of the hosts, and they will be configured to connect with each other.

```bash
# nano ~/host-information.txt

The columns:

| Column   | Value                                                                    |
| -------- | ------------------------------------------------------------------------ |
|HOSTNAME  | hostname of the machine                                                  |
|HOSTIP    | final octet of the tinc IPv4 address (i.e., "10.101.$SUBNET.$HOSTIP/32") |
|TINC      | name of the tinc network (i.e., "/etc/tinc/$TINC/")                      |
|TINCHOST  | name of the tinc host (i.e., "/etc/tinc/$TINC/hosts/$TINCHOST")          |
|SUBNET    | third octet of the tinc IPv4 subnet (i.e., "10.101.$SUBNET.0/24")        |
|TOR       | Tor instance (i.e., "/var/lib/$TOR/")                                    |
|TORRC     | torrc for Tor instance (i.e., "/etc/tor/$TORRC")                         |
|SOCKSPORT | SocksPort for Tor instance                                               |
|TINCPORT  | port that tinc instance listens on                                       |
|TINCONION | Tor v3 onion address for the tinc instance                               |

I am using SUBNETs 10-15 and 20, and HOSTIPs 1-30. See [ChaosVPN:IPRanges](https://wiki.hamburg.ccc.de/ChaosVPN:IPRanges), in the section for American and other hackerspaces, to check what others may be using. And please update that wiki with your choices.

Create Tor instances, review the torrc files, and start them.

```bash
# ~/create-tor-instances.sh
# cat /etc/tor/torrc0
...
# cat /etc/tor/torrc5
# ~/start-tor-instances.sh

Get tinc onion hostnames, and add them to the host information table.

```bash
# ~/get-tinc-onion-hostnames.sh
# nano ~/host-information.txt

Create tinc config files, and review them.

```bash
# ~/create-full-mesh-tinc-conf.sh
# cat /etc/tinc/tinc0/tinc.conf
...
# cat /etc/tinc/tinc5/tinc.conf

Create tinc keys, add necessary lines to host files, and review them.

```bash
# ~/create-full-mesh-tinc-keys.sh
# ~/tweak-full-mesh-tinc-hosts.sh
# cat /etc/tinc/tinc0/hosts/yh0 [placeholder]
...
# cat /etc/tinc/tinc5/hosts/yh5 [placeholder]

Create tinc-up and tinc-down scripts, review them, and update nets.boot.

```bash
# ~/create-full-mesh-tinc-up.sh
# ~/create-full-mesh-tinc-down.sh
# cat /etc/tinc/tinc0/tinc-up
...
# cat /etc/tinc/tinc5/tinc-up
# cat /etc/tinc/tinc0/tinc-down
...
# cat /etc/tinc/tinc5/tinc-down
# ~/update-nets-boot.sh

Collect host files.

```bash
# mkdir /tmp/hosts && cp /etc/tinc/tinc*/hosts/yh* /tmp/hosts/
# cd /tmp/hosts
# tar -cf yh-hosts.tar yh*

Copy "yh-hosts.tar" to /tmp/hosts/ in other hosts that you want to include. If you're adding a new host to an existing network, you must update the other "tinc.conf" files with "ConnectTo" lines for the new one. If you want to peer with my host "one", send your hosts archive to <annobrown@protonmail.com>, and copy my [one-hosts.tar](./one-hosts.tar) to /tmp/hosts/ in your host.

```bash
# rm yh*
# tar -xf one-hosts.tar
# rm one-hosts.tar
# cp one* /etc/tinc/tinc0/hosts/
# cp one* /etc/tinc/tinc1/hosts/
# cp one* /etc/tinc/tinc2/hosts/
# cp one* /etc/tinc/tinc3/hosts/
# cp one* /etc/tinc/tinc4/hosts/
# cp one* /etc/tinc/tinc5/hosts/
# rm one*
# cd ~/

Start tinc instances, and set multipath on for them, and off for eth0 (or equivalent).

```bash
# ~/start-tinc-instances.sh
# ~/set-multipath.sh

If you need to stop tinc instances:

   # ~/stop-tinc-instances.sh

Update iptables rules.

```bash
# cp ~/tinc-rules.v4 /etc/iptables/
# iptables-restore &#60; /etc/iptables/tinc-rules.v4

The IPv6 rules drop everything. The IPv4 rules allow ssh login via all interfaces, but allow icmp, iperf3, and http/https traffic only via tinc interfaces. They allow outgoing traffic via eth0 (or equivalent) only for tor. That is, they allow tinc traffic only via tor. They allow all outgoing traffic via tinc interfaces, but no other outgoing traffic via eth0 or equivalent. And they do not allow any other unrelated/unestablished incoming traffic. You may need to change "eth0" to whatever your system uses. Once you're satisfied that these rules work, and don't lock you out, you can rename them to rules.v6 and rules.v4, respectively. That way, they will load at boot.

Test connectivity.

```bash
# ping -fc 10 10.101.10.1
# ping -fc 10 10.101.10.2
# ping -fc 10 10.101.10.3
# ping -fc 10 10.101.10.6
# ping -fc 10 10.101.10.7

Those should all succeed, with rtt on the order of 300-800 msec.

```bash
# ping -fc 10 10.101.20.6
# ping -fc 10 10.101.20.10
# ping -fc 10 1.1.1.1
# ping -fc 10 194.36.190.113

But these should fail, with 100% packet loss. The addresses of "gateway6" are 194.36.190.113/32, 10.101.10.6/32 and 10.101.20.6/32. So only 10.101.10.6/32 should be reachable from 10.101.10.0/24. Using 10.101.20.6/32 as gateway, you can reach both 10.101.10.0/24 and 10.101.20.0/24.

You can also test bandwidth using iperf3.

```bash
# iperf3 -P 1 -c 10.101.10.1
# iperf3 -P 2 -c 10.101.10.1
# iperf3 -P 5 -c 10.101.10.1
# iperf3 -P 10 -c 10.101.10.1

Once you're satisfied that the setup is working, you can have the tor and tinc instances start at boot. The simplest way is adding the scripts to /etc/rc.local (after, if necessary, creating it):

```bash
# nano /etc/rc.local
  #!/bin/sh -e
  /root/start-tor-instances.sh
  /root/start-tinc-instances.sh
  exit 0
# chmod a+x /etc/rc.local
