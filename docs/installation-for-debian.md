# Installation for Debian (and derivatives)

This installation has been tested on:

- Debian 12 Bookworm
- Ubuntu 19.10
- Fedora Workstation 40

## Docker

Follow the installation procedure: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Docker compose

The latest version of docker ships with `compose`.
If you are running an older version of docker, you can follow the documentation below to install it :

- [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Local DNS resolver

There are two ways to forward the local domain;

- `unbound` (recommended)
- `dnsmasq` (historic)

### `Unbound` (recommended)

#### WARNING

As of 2024-11, the `unbound` setup doesn't work on recent Ubuntu.

> Unbound is a validating, recursive and caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards.

Let's install `unbound`;

```bash
sudo apt update
sudo apt install -y unbound
```

Configure NetworkManager to avoid using any name service:

```bash
cat <<EOF | sudo tee /etc/NetworkManager/conf.d/dns.conf
[main]
dns=none
rc-manager=unmanaged
EOF

sudo rm -f /etc/resolv.conf
cat <<EOF | sudo tee /etc/resolv.conf
# Local unbound resolver
nameserver 127.0.0.1
EOF
```

And configure unbound to resolve `docker.test` to localhost:

```bash
sudo mkdir /etc/unbound/unbound.conf.d
cat <<EOF | sudo tee /etc/unbound/unbound.conf.d/pontsun.conf
server:
  local-zone: "docker.test" redirect
  local-data: "docker.test. 3600 IN A 127.0.0.1"
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

Done

### `Dnsmasq` (historic)

Here's how to configure `dnsmasq` to automatically forward any **\*.docker.test** domain to our
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

### Test

Test direct resolution

```bash
host foobar.docker.test
```

… should get you something like:

```bash
foobar.docker.test has address 127.0.0.1
```

Test DNS resolution

```bash
docker run busybox nslookup pypi.python.org
```

… should get you something like:

```bash
Server:         172.17.0.1
Address:        172.17.0.1:53

Non-authoritative answer:
pypi.python.org canonical name = dualstack.python.map.fastly.net
Name:   dualstack.python.map.fastly.net
Address: 2a04:4e42:54::223

Non-authoritative answer:
pypi.python.org canonical name = dualstack.python.map.fastly.net
Name:   dualstack.python.map.fastly.net
Address: 199.232.80.223
```
