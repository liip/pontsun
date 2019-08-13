# Docker Toolbox

## Installation

Create certificates for HTTPS
```bash
./scripts/pontsun generate-cert
```
You need to add the generated certificate `etc/certificates/docker.rootCA.crt` to your browser authorities and trust related websites.

add your host to dnsmasq

```bash
. containers/.env
./scripts/pontsun add-host $PROJECT_DOMAIN
```

Start Traefik and Portainer
```bash
./scripts/pontsun up
```

or

```bash
cd containers
docker-compose up -d
```

## Containers

- Traefik ([https://traefik.docker.lo](https://traefik.docker.lo)): reverse proxy and load balancer for containers
- Portainer ([https://portainer.docker.lo](https://portainer.docker.lo)): GUI for Docker management

## Resources
- [Docker installation for Mac](https://wiki.liip.ch/display/DRUIDS/Docker+installation+for+Mac)
- [Docker installation for Ubuntu](https://wiki.liip.ch/display/DRUIDS/Docker+installation+for+Ubuntu)


## Project setup

Generate a docker-compose.yml and label your frontend controllers for traefik. Don't forget to use
the correct docker network for connecting to traefik.

eg:

```bash
version: '3.5'
services:

    server:
      image: node:10-slim
      command: npm run start
      user: node
      working_dir: /home/node/app
      volumes:
        - .:/home/node/app:delegated #delegated may help on OS X for better performance
      labels:
        - "traefik.frontend.rule=Host:charts.docker.lo"
        - "traefik.docker.network=pontsun"
        - "traefik.enable=true"
        - "traefik.port=3001"
        - "traefik.frontend.passHostHeader=false" #optional, depending what you need
      networks:
        - pontsun
      ports:
        - 3001:3001
networks:
    pontsun:
      external: true
      name: pontsun
```



