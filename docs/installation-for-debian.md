# Installation for Debian

This installation has been tested on:
* Debian Buster
* Ubuntu 19.10

## Docker

Follow the installation procedure: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Docker compose

Default compose binary shipped with Docker is not the latest.

Follow the installation procedure: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Network Manager 
You need to configure your network manager to resolve domains *.docker.test to localhost. To do so there is two options:
+ Using Dnsmasq (recommended)
+ Using systemd

### DnsMask

Dnsmasq will automatically forward any **\*.docker.test** domain to our
local docker infrastructure.

We recommend installing only the `dnsmasq` binaries, not the full daemon.
```bash
sudo apt update
sudo apt install dnsmasq-base
```

Configure Network Manager to use `dnsmasq` and `dnsmasq` to automatically forward any **\*.docker.test** domain to the loopback local IPv4 interface.
```bash
cat <<EOF | sudo tee /etc/NetworkManager/conf.d/dnsmasq.conf
[main]
dns=dnsmasq
EOF

cat <<EOF | sudo tee /etc/NetworkManager/dnsmasq.d/local-domains
address=/docker.test/127.0.0.1
strict-order
EOF
```

Stop the current DNS daemon
```bash
sudo systemctl stop systemd-resolved
```

Restart the networking daemon
```bash
sudo systemctl restart NetworkManager
```

Let Network Manager manage /etc/resolv.conf
```bash
sudo mv /etc/resolv.conf /etc/resolv.conf.bck
sudo ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
```

Test
```bash
host foobar.docker.test

# Should get you: 
foobar.docker.test has address 127.0.0.1
```

### Systemd-resolved
> Untested yet

Configure systemd to resolve your dns via systemd-resolved instead of DnsMask
```bash
cat <<EOF | sudo tee /etc/NetworkManager/dispatcher.d/99-pontsun.conf
#!/bin/sh
export LC_ALL=C
systemd-resolve --set-dns=127.0.0.1 --set-domain=docker.test
exit 0
```
You will need to adapt `<default>` to your NC.

Start the deamon:
> sudo systemctl start systemd-resolved
