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

```sh
cp ./containers/.env.example ./containers/.env
```

Adapt the `./containers/.env` file as needed.

Create certificates for HTTPS

```sh
USER_ID=$(id -u) docker-compose -f docker-compose.certificates.yml up
```

You can add the fake root CA authority certificate `certificates/docker.test.rootCA.crt` to your browser authorities in order to let it trust the concerned local developement instances.

## Start Traefik and Portainer

```sh
cd containers
docker-compose up -d
```

## SSH keys

To use an ssh key from your host in your docker container, start the ssh-agent with

```bash
cd containers
docker-compose -f docker-compose.yml -f docker-compose.ssh-agent.yml up -d
```

You can also add the following to your `containers/.env` file instead

```
COMPOSE_FILE=docker-compose.yml:docker-compose.ssh-agent.yml
```

This may only be needed on OS X.

It assumes, you don't run your stuff as root. If you do, you can leave the socat stuff out.

```bash
KEY=id_rsa

docker run --rm --volumes-from=pontsun_ssh_agent -v ~/.ssh/$KEY:/.ssh/$KEY -it nardeas/ssh-agent ssh-add -l 
if [[ $? == 1 ]]; then
    docker run --rm --volumes-from=pontsun_ssh_agent -v ~/.ssh/$KEY:/.ssh/$KEY -it nardeas/ssh-agent ssh-add /root/.ssh/id_rsa
fi

docker-compose exec -d $YOUR_CONTAINER ./socat.sh
docker-compose exec  $YOUR_CONTAINER sudo chown $YOUR_USER /home/$YOUR_USER/.ssh/socket
```

and socat.sh is:
```bash
sudo killall socat 2&> /dev/null
sudo rm -f $HOME/.ssh/socket
sudo socat UNIX-LISTEN:$HOME/.ssh/socket,fork UNIX-CONNECT:/.ssh-agent/socket
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
