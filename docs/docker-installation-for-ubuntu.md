# Docker installation for Ubuntu 

## Docker

Follow the installation procedure: [https://docs.docker.com/install/linux/docker-ce/ubuntu/](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

## Docker compose

Default compose binary shipped with Docker is the not the latest.

Follow the installation procedure: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Dnsmasq

Dnsmasq will automatically forward any **\*.docker.lo** domain to our local docker infrastructure.

```
sudo apt-get update
sudo apt-get install dnsmasq
```
  
```
mkdir -pv /etc/dnsmasq.d/
echo 'address=/docker.lo/127.0.0.1'  | sudo tee /etc/dnsmasq.d/docker
echo 'strict-order'  | sudo tee --append /etc/dnsmasq.d/docker
```
## Pontsun

Pontsun provides the base setup for Docker environments.  

```
git clone --recurse-submodules git@github.com:liip/pontsun.git
cd pontsun
```

```
chmod u+x ./scripts/generate-certificates.sh
./scripts/generate-certificates.sh
```
You need to add the generated certificate **certificates/docker.rootCA.crt** to your browser authorities and trust related websites.

```
cd containers
docker-compose up -d
```
