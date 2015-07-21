[![Circle CI](https://circleci.com/gh/sameersbn/docker-squid.svg?style=svg)](https://circleci.com/gh/sameersbn/docker-squid)

# Table of Contents

- [Introduction](#introduction)
- [Contributing](#contributing)
- [Reporting Issues](#reporting-issues)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Shell Access](#shell-access)
- [Upgrading](#upgrading)

# Introduction

Dockerfile to build a squid image.

# Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Help new users with [Issues](https://github.com/sameersbn/docker-squid/issues) they may encounter
- Support the development of this image with a [donation](http://www.damagehead.com/donate/)

# Reporting Issues

Docker is a relatively new project and is active being developed and tested by a thriving community of developers and testers and every release of docker features many enhancements and bugfixes.

Given the nature of the development and release cycle it is very important that you have the latest version of docker installed because any issue that you encounter might have already been fixed with a newer docker release.

For ubuntu users I suggest [installing docker](https://docs.docker.com/installation/ubuntulinux/) using docker's own package repository since the version of docker packaged in the ubuntu repositories are a little dated.

Here is the shortform of the installation of an updated version of docker on ubuntu.

```bash
sudo apt-get purge docker.io
curl -s https://get.docker.io/ubuntu/ | sudo sh
sudo apt-get update
sudo apt-get install lxc-docker
```

Fedora and RHEL/CentOS users should try disabling selinux with `setenforce 0` and check if resolves the issue. If it does than there is not much that I can help you with. You can either stick with selinux disabled (not recommended by redhat) or switch to using ubuntu.

If using the latest docker version and/or disabling selinux does not fix the issue then please file a issue request on the [issues](https://github.com/sameersbn/docker-squid/issues) page.

In your issue report please make sure you provide the following information:

- The host ditribution and release version.
- Output of the `docker version` command
- Output of the `docker info` command
- The `docker run` command you used to run the image (mask out the sensitive bits).

# Installation

Pull the latest version of the image from the docker index. This is the recommended method of installation as it is easier to update image in the future. These builds are performed by the **Docker Trusted Build** service.

```bash
docker pull sameersbn/squid:latest
```

Alternately you can build the image locally.

```bash
git clone https://github.com/sameersbn/docker-squid.git
cd docker-squid
docker build --tag="$USER/squid" .
```

# Quick Start

Run the image

```bash
docker run --name='squid' -it --rm -p 3128:3128 \
  sameersbn/squid:latest
```

You now have a squid proxy server listening on port 3128. Just configure your browser / applications to use the proxy and your good to go.

Additionally you can mount a volume at the `/var/spool/squid3` path to have a persistent cache, else the cache will be purged when the container is removed. For example, `-v /opt/squid/cache:/var/spool/squid3` will store the cache at the `/opt/squid/cache` path on the host.

# Configuration

Squid is a full featured caching proxy server and has hundreds of configuration parameters.

The proper way to configure squid to your liking is by editing the `squid.conf` file and volume mounting the updated configuration at the `/etc/squid3/squid.user.conf` path in the container by specifying the `-v /path/on/host/to/squid.conf:/etc/squid3/squid.user.conf` flag in the docker run command. You can use the `squid.conf` from the repository as a template to base your configurations.

# Shell Access

For debugging and maintenance purposes you may want access the containers shell. If you are using docker version `1.3.0` or higher you can access a running containers shell using `docker exec` command.

```bash
docker exec -it squid bash
```

If you are using an older version of docker, you can use the [nsenter](http://man7.org/linux/man-pages/man1/nsenter.1.html) linux tool (part of the util-linux package) to access the container shell.

Some linux distros (e.g. ubuntu) use older versions of the util-linux which do not include the `nsenter` tool. To get around this @jpetazzo has created a nice docker image that allows you to install the `nsenter` utility and a helper script named `docker-enter` on these distros.

To install `nsenter` execute the following command on your host,

```bash
docker run --rm -v /usr/local/bin:/target jpetazzo/nsenter
```

Now you can access the container shell using the command

```bash
sudo docker-enter squid
```

For more information refer https://github.com/jpetazzo/nsenter

# Upgrading

To upgrade the image simply follow this 3 step upgrade procedure.

- **Step 1**: Update the docker image.

```bash
docker pull sameersbn/squid:latest
```

- **Step 2**: Stop and remove the currently running image

```bash
docker stop squid
docker rm squid
```

- **Step 3**: Start the image

```bash
docker run --name=squid -d [OPTIONS] sameersbn/squid:latest
```
