# Pontsun

## Installation

Create certificates for HTTPS
```bash
chmod u+x ./scripts/generate-certificates.sh
./scripts/generate-certificates.sh
```
You need to add the generated certificate `certificates/docker.rootCA.crt` to your browser authorities and trust related websites.

Start Traefik and Portainer
```bash
cd containers
docker-compose up -d
```

## Containers

- Traefik ([https://traefik.docker.test](https://traefik.docker.test)): reverse proxy and load balancer for containers
- Portainer ([https://portainer.docker.test](https://portainer.docker.test)): GUI for Docker management

## Resources
- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)
