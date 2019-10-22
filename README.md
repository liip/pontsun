# Pontsun

This project will help you to:

* Access docker containers via Traefik ([https://traefik.docker.lo](https://traefik.docker.test)): reverse proxy and load balancer for containers
* Manage and inspect docker via Portainer ([https://portainer.docker.lo](https://portainer.docker.test))

## Prerequisite

- docker-compose
- A local DNS resolver to point some test domains to localhost

See [#resources](#Resources).

## Installation
Clone the liip/pontsun repository anywhere. Then `cd` to the working copy.

Create an envfile

```bash
cp ./containers/.env.example ./containers/.env
```

Adapt the `./containers/.env` file as needed.

Create certificates for HTTPS

```bash
chmod u+x ./scripts/generate-certificates.sh
./scripts/generate-certificates.sh
```

You can add the fake root CA authority certificate `certificates/docker.rootCA.crt` to your browser authorities in order to let it trust the concerned local developement instances.

## Start Traefik and Portainer

```bash
cd containers
docker-compose up -d
```

## Access the containers

- Traefik: reverse proxy and load balancer for containers
  - https://traefik.docker.test/
- Portainer: GUI for Docker management
  - https://portainer.docker.test/

## Resources

### For Linux

- [Installation](docs/installation-for-ubuntu.md)
- [Project setup](docs/project-setup-for-ubuntu.md)

### For Mac OS

- [Installation](docs/installation-for-mac.md)
- [Project setup](docs/project-setup-for-mac.md)
