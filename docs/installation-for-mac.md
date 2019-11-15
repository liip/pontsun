# Installation for Mac 

## Requirements

- Homebrew: [https://brew.sh/](https://brew.sh/)
- Ruby (install latest version with Homebrew as OS version is
  obsolete)

## Docker

Download Docker installer at
[https://download.docker.com/mac/stable/Docker.dmg](https://download.docker.com/mac/stable/Docker.dmg)\
Follow the installation procedure (the Docker installer may propose to
create a Docker account at some point but this is not required).\

Once installed and launched, update preferences:

- Uncheck "Send usage statistics"
- File sharing: check that this checked-out project is below one of
  the exposed folder or add it

## Docker sync

Docker sync tends to solve bins mounts performance on Mac.

```
gem install docker-sync
```

## Dnsmasq

Dnsmasq will automatically forward any **\*.docker.test** domain to our
local docker infrastructure.

```
brew install dnsmasq
chmod u+x ./scripts/install-dnsmasq-mac.sh
sudo ./scripts/install-dnsmasq-mac.sh
```

## Trust certificates

```
chmod u+x ./scripts/generate-certificates.sh
./scripts/generate-certificates.sh
```

You need to add the generated certificate
**certificates/docker.rootCA.crt** to your certificates:

- Double click on the certificate, this should open Keychain Access
- Add the certificate to **system**
- Double on the docker.lo certificate under the system tab to open the
  details
- Trust \> When using this certificate, set **Always Trust**
