# Installation for Ubuntu 

## Docker

Follow the installation procedure: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Docker compose

Default compose binary shipped with Docker is the not the latest.

Follow the installation procedure: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Dnsmasq

Dnsmasq will automatically forward any **\*.docker.test** domain to our local docker infrastructure.

```
sudo apt-get update
sudo apt-get install dnsmasq
```

```
mkdir -pv /etc/dnsmasq.d/
echo 'address=/docker.test/127.0.0.1'  | sudo tee /etc/dnsmasq.d/docker
echo 'strict-order'  | sudo tee --append /etc/dnsmasq.d/docker
```
