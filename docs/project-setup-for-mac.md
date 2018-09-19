# Project setup for Mac

Locate the folder that contains the `docker-compose.yml` file.

## Setup

Copy `.env.example` file to `.env` and adapt according to the needs.

Copy `docker-compose.override.mac.yml` to `docker-compose.override.yml`.

The `USER_ID` environment variable should be equivalent to your Mac user ID to avoid local permissions conflicts.

**Get user ID**

```
id -u
```

## Commands

All commands should be executed where the `docker-compose.yml` and `docker-sync.yml` are.

**Start the containers**

```
docker-sync start
docker-compose up -d
```

**Stop the containers**

```
docker-compose down
docker-sync stop
```

**Cleanup**

```
docker system prune
docker-sync clean
```

