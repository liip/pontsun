# Installation for Mac

This installation has been tested on:
* macOS Catalina

## Requirements

- Homebrew: [https://brew.sh/](https://brew.sh/)
- Ruby (install latest version with Homebrew as OS version is
  obsolete)

## Docker

Download Docker installer at
[https://download.docker.com/mac/stable/Docker.dmg](https://download.docker.com/mac/stable/Docker.dmg)\
Follow the installation procedure (the Docker installer may propose to
create a Docker account at some point but this is not required).

Once installed and launched, update preferences:

- Uncheck "Send usage statistics"
- File sharing: check that this checked-out project is below one of
  the exposed folder or add it

## Docker sync

Docker sync tends to solve bind mounts performance on Mac.

```
gem install docker-sync
```

## Dnsmasq

Dnsmasq will automatically forward any **\*.docker.test** domain to our
local docker infrastructure.

Install Dnsmasq
```
brew install dnsmasq
```

Configure Dnsmasq to automatically forward any **\*.docker.test** domain to the loopback local IPv4 interface.
```
mkdir -pv $(brew --prefix)/etc/
echo 'address=/docker.test/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
echo 'strict-order' >> $(brew --prefix)/etc/dnsmasq.conf
```

Start Dnsmasq on every startup and launch it now
```
sudo cp -v $(brew --prefix dnsmasq)/homebrew.mxcl.dnsmasq.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```

Create resolver
```
sudo mkdir -v /etc/resolver
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/docker.test'
```

## Trust certificates (to be done AFTER Pontsun install)

### Adding them to the system

You need to add the generated certificate
**certificates/docker.test.rootCA.crt** to your certificates:

- Double click on **docker.test.rootCA.crt**, this should open Keychain Access
- Add the certificate to **system**
- On the key chain, double click on the **docker.test** certificate under the system tab
- Trust \> When using this certificate, set **Always Trust**

### Firefox certificates configuration

You need to enable the enterprise root support so firefox can
import roots found in the MacOS system keychain:

- Open Firefox
- Type `about:config`
- Click the button `I accept the risk`
- Type `security.enterprise_roots.enabled` and press enter
- Double click to set true
 
Now firefox have access to your MacOS certificates

[Mozilla Documentation](https://wiki.mozilla.org/CA/AddRootToFirefox)
