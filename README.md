# Pontsun

This project will help you to:

- Access docker containers via [Traefik](https://traefik.io/): reverse proxy and load balancer for containers
- Manage and inspect docker via [Portainer](https://www.portainer.io/)
  - using user `admin` and password `1234567891011`.

## Prerequisite

- Docker compose: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- A local DNS resolver to point some test domains to localhost

See [Resources](#resources).

## Installation

Clone the `liip/pontsun` repository anywhere. Then `cd` to the working copy:

```sh
git clone https://github.com/liip/pontsun.git
cd pontsun
```

### Create certificates for HTTPS

Create the certificates:

```sh
cd containers/
USER_ID=$(id -u) docker compose -p pontsun_sslkeygen -f docker-compose.certificates.yml up
```

You can add the fake root CA authority certificate `certificates/docker.test.rootCA.crt`
to your browser authorities in order to let it trust the concerned local development instances.

## Start

### Default

Start Traefik and Portainer

```sh
cd containers
docker compose up -d
```

### With SSH agent

#### Linux

On Linux, you don't especially need a dedicated SSH agent container
and you could simply use it in your compose file like this:

```yaml
services:
  service_name:
    ...
    environment:
        SSH_AUTH_SOCK: /ssh-agent
    ...
    volumes:
        - $SSH_AUTH_SOCK:/ssh-agent
```

#### Mac

##### Start the ssh_agent container

To use an SSH key from your host in your docker container, start the SSH agent with

```sh
cd containers
docker compose -f docker-compose.yml -f docker-compose.ssh-agent.yml up -d
```

You can also add the following to your `containers/.env` file instead

```
COMPOSE_FILE=docker-compose.yml:docker-compose.ssh-agent.yml
```

##### Add your ssh keys

```sh
KEY=id_rsa
docker run --rm --volumes-from=pontsun_sshagent -v ~/.ssh/$KEY:/root/.ssh/$KEY -it docksal/ssh-agent:latest ssh-add /root/.ssh/$KEY
```

As the key is stored in memory, you need to add it every time the SSH agent container is restarted.

##### Update your docker-compose

Update your service definition to use the SSH agent.

```yaml
services:
  service_name:
    ...
    environment:
        SSH_AUTH_SOCK: /.ssh-agent/proxy-socket
    ...
    volumes:
        - pontsun_sshagent_socket_dir:/.ssh-agent
...
volumes:
    pontsun_sshagent_socket_dir:
        external: true
```

#### Troubleshooting

Forwarding an SSH agent requires using an existing user in your container for libpam to accept the connection
otherwise you will get the error `No user exists for uid [uid]`.

If you don't, you can either create the user on the fly or use `nss_wrapper` if the image allows it,
otherwise you need to create a derivative image.

## Access the containers

- Traefik: reverse proxy and load balancer for containers
  - https://traefik.docker.test/
- Portainer: GUI for Docker management
  - https://portainer.docker.test/

## Use with your project

To use this with your project, you simply need to update your `docker-compose.yml`.

First add an external network:

```yaml
networks:
  pontsun:
    name: pontsun
    external: true
```

Then for every services which needs a url:

```yaml
services:
  my-service:
    # ... your service definition

    # You need the pontsun network
    networks:
      # You can add this default network if you do not have any configured
      - default
      # Add the pontsun network
      - pontsun

    # As well as those labels
    labels:
      - traefik.enable=true
      # Notice the url defined here, you can change it needs to fit the format "*.docker.test"
      - traefik.http.routers.liippdf.rule=Host(`MY-SERVICE.docker.test`)
      - traefik.http.routers.liippdf.entrypoints=http,https
      # If your dockerfile exposes multiple ports, you need to precise which one is to be used
      # - traefik.http.services.liippdf.loadbalancer.server.port=8000

    # Exposing ports is not needed anymore as you will access services by name
    # ports:
    #   - 8000

  my-other-service:
    # ... make the same changes as for my-service
```

## Resources

### For Linux (Debian/Ubuntu)

- [Installation](docs/installation-for-debian.md)

### For macOS

- [Installation](docs/installation-for-mac.md)
