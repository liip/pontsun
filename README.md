# Pontsun

## Installation

Create certificates for HTTPS
```bash
chmod u+x ./scripts/generate-certificates.sh
./scripts/generate-certificates.sh
```
You need to add the generated certificate `certificates/docker.rootCA.crt` to your browser authorities and trust related websites.

### Setup local DNS

To be able to resolve all DNS lookup to *.pontsun.test (or other configured domains), we need a local dns server.
There's 2 options to do that, either in the provided docker container. Or in a locally installed dns server like dnsmasq.


#### 1) Use the included dns server container

Do use the included dnsmasq container, start pontsun with 
 
```bash
cd containers
docker-compose -f docker-compose.yml -f docker-compose.dns.yml up -d
```

You can also add the following to your `containers/.env` file instead

```
COMPOSE_FILE=docker-compose.yml:docker-compose.dns.yml
```

#### or 3) Use a locally installed dns server

See

- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)

for detilas

#### Add domain to your dns config

After you have set the dns server up, do:

```bash
. containers/.env
./scripts/pontsun add-host $PROJECT_DOMAIN
```

do add your default domain (by default pontsun.test) to the dns server.

###  Start pontsun with traefik and portainer

Start Traefik and Portainer
```bash
cd containers
docker-compose up -d
```

## Containers

- Traefik ([https://traefik.docker.lo](https://traefik.docker.lo)): reverse proxy and load balancer for containers
- Portainer ([https://portainer.docker.lo](https://portainer.docker.lo)): GUI for Docker management

## Resources
- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)
