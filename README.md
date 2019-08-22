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
./scripts/generate-certificates.sh
```
You need to add the generated certificate `etc/certificates/pontsun.rootCA.crt` to your browser authorities and trust related websites.

If you have [step-cli](https://smallstep.com/docs/cli/) or are on OS X, this should happen automatically.

### Setup local DNS 

See

- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)

for now.

###  Start pontsun with traefik and portainer

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

## Containers

- Traefik ([https://traefik.docker.lo](https://traefik.docker.lo)): reverse proxy and load balancer for containers
- Portainer ([https://portainer.docker.lo](https://portainer.docker.lo)): GUI for Docker management

## Resources
- [Docker installation for Mac](docs/docker-installation-for-mac.md)
- [Docker installation for Ubuntu](docs/docker-installation-for-ubuntu.md)
