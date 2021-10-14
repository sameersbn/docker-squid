[![Circle CI](https://circleci.com/gh/sameersbn/docker-squid.svg?style=shield)](https://circleci.com/gh/sameersbn/docker-squid) [![Docker Repository on Quay.io](https://quay.io/repository/sameersbn/squid/status "Docker Repository on Quay.io")](https://quay.io/repository/sameersbn/squid)

<!-- omit in toc -->
# sameersbn/squid:3.5.27-2

- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Command-line arguments](#command-line-arguments)
  - [Persistence](#persistence)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Logs](#logs)
- [Maintenance](#maintenance)
  - [Upgrading](#upgrading)
  - [Shell Access](#shell-access)

## Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Squid proxy server](http://www.squid-cache.org/).

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

### Contributing

If you find this image useful here's how you can help:

- Send a pull request with your awesome features and bug fixes
- Help users resolve their [issues](../../issues?q=is%3Aopen+is%3Aissue).
- Support the development of this image with a [donation](http://www.damagehead.com/donate/)

### Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/get-docker/) for instructions.

If the above documentation does not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Docker Desktop](https://www.docker.com/products/docker-desktop), [VirtualBox](https://www.virtualbox.org), etc.

## Getting started

### Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/sameersbn/squid) and is the recommended method of installation.

> **Note**: Builds are also available on [Quay.io](https://quay.io/repository/sameersbn/squid)

```bash
docker pull sameersbn/squid:4.13-10
```

Alternatively you can build the image yourself.

```bash
docker build -t squid github.com/sameersbn/docker-squid
```

### Quickstart

Start Squid using:

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  sameersbn/squid:4.13-10
```

*Alternatively, you can use the sample [docker-compose.yml](docker-compose.yml) file to start the container using [Docker Compose](https://docs.docker.com/compose/)*

### Command-line arguments

You can customize the launch command of the Squid server by specifying arguments to `squid` on the `docker run` command. For example the following command prints the help menu of `squid` command:

```bash
docker run --name squid -it --rm \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  sameersbn/squid:4.13-10 -h
```

### Persistence

For the cache to preserve its state across container shutdown and startup you should mount a volume at `/var/spool/squid`.

> *The [Quickstart](#quickstart) command already mounts a volume for persistence.*

SELinux users should update the security context of the host mountpoint so that it plays nicely with Docker:

```bash
mkdir -p /srv/docker/squid
chcon -Rt svirt_sandbox_file_t /srv/docker/squid
```

### Configuration

Squid is a full featured caching proxy server and a large number of configuration parameters. To configure Squid as per your requirements mount your custom configuration at `/etc/squid/squid.conf`.

```bash
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /path/to/squid.conf:/etc/squid/squid.conf \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  sameersbn/squid:4.13-10
```

To reload the Squid configuration on a running instance you can send the `HUP` signal to the container.

```bash
docker kill -s HUP squid
```

**IMPORTANT NOTE:** Some required configuration options are stored at `/etc/squid/conf.d` and need to be included in any custom config. These are needed so that the image can be run as a non root user.

To make sure these options are loaded add the following line to the configuration.

```squid.conf
include /etc/squid/conf.d/*
```

Alternatively you can also add the required configuration options in your own config.

```squid.conf
pid_filename /var/run/squid/squid.pid

logfile_rotate 0
cache_log stdio:/dev/null
access_log stdio:/dev/stdout
cache_store_log stdio:/dev/stdout
```

### Usage

Configure your web browser network/connection settings to use the proxy server which is available at `172.17.0.1:3128`

If you are using Linux then you can also add the following lines to your `.bashrc` file allowing command line applications to use the proxy server for outgoing connections.

```bash
export ftp_proxy=http://172.17.0.1:3128
export http_proxy=http://172.17.0.1:3128
export https_proxy=http://172.17.0.1:3128
```

To use Squid in your Docker containers add the following line to your `Dockerfile`.

```dockerfile
ENV http_proxy=http://172.17.0.1:3128 \
    https_proxy=http://172.17.0.1:3128 \
    ftp_proxy=http://172.17.0.1:3128
```

### Logs

The default configuration will log to stdout so the logs can be viewed via `docker logs`.

```bash
docker logs squid
```

## Maintenance

Using the `latest` tag is discouraged for any production or stable usage so using a specific version is recommended, for example `sameersbn/squid:4.13`.
### Upgrading

Example process for updating between versions. If you are running for example 4.13 and want to update to 4.14:

To upgrade to newer releases:

  1. Download the updated Docker image:

  ```bash
  docker pull sameersbn/squid:4.13-10
  ```

  2. Stop the currently running image:

  ```bash
  docker stop squid
  ```

  3. Remove the stopped container

  ```bash
  docker rm -v squid
  ```

  4. Start the updated image

  ```bash
  docker run -name squid -d \
    [OPTIONS] \
    sameersbn/squid:4.14-10
  ```

### Shell Access

For debugging and maintenance purposes you may want access the containers shell. You can access a running containers shell by starting `bash` using `docker exec`:

```bash
docker exec -it squid bash
```
