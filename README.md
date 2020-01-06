# Pontsun

This project will help you to:

* Access docker containers via [Traefik](https://traefik.io/): reverse proxy and load balancer for containers
* Manage and inspect docker via [Portainer](https://www.portainer.io/)

## Prerequisite

- Docker compose: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- A local DNS resolver to point some test domains to localhost

See [Resources](#resources).

## Installation

Clone the liip/pontsun repository anywhere. Then `cd` to the working copy.

### Create an envfile

```sh
cp ./containers/.env.example ./containers/.env
```

Adapt the `./containers/.env` file as needed.

### Create certificates for HTTPS

```sh
cd containers/
USER_ID=$(id -u) docker-compose -f docker-compose.certificates.yml up
```

You can add the fake root CA authority certificate `certificates/docker.test.rootCA.crt`
to your browser authorities in order to let it trust the concerned local development instances.

## Start

### Default

Start Traefik and Portainer
```sh
cd containers
docker-compose up -d
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
docker-compose -f docker-compose.yml -f docker-compose.ssh-agent.yml up -d
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

## Resources

### For Linux (Debian/Ubuntu)

- [Installation](docs/installation-for-debian.md)

### For macOS

- [Installation](docs/installation-for-mac.md)
