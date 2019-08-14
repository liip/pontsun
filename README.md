# Pontsun

## Installation

### .env file

Copy and adjust `containers/.env.example` to `containers/.env`

```
cp containers/.env.example containers/.env
```

### Generate SSL certificate

Create certificates for HTTPS
```bash
./scripts/pontsun generate-cert
```
You need to add the generated certificate `etc/certificates/pontsun.rootCA.crt` to your browser authorities and trust related websites.
On OS X, this was automatically added to your keychain if the command above worked correctly. No need to do anything else.

### Setup local DNS 

See

- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)

for now.

###  Start pontsun with traefik and portainer

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
- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)
