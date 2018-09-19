# Project setup for Ubuntu

Locate the folder that contains the `docker-compose.yml` file.

## Setup

Copy `.env.example` file to `.env` and adapt according to the needs.

Copy `docker-compose.override.linux.yml` to `docker-compose.override.yml`.

The `USER_ID` environment variable should be equivalent to your Linux user ID to avoid local permissions conflicts.

**Get user ID**

```
id -u
```

## Commands

All commands should be executed where the docker-compose.yml is.

**Start the containers**

```
docker-compose up -d
```
**Stop the containers**

```
docker-compose down
```

**Cleanup**

```
docker system prune
```
