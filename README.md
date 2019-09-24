<!-- PROJECT LOGO -->

<br />
<p align="center">
  <h3 align="center">Football</h3>

  <p align="center">
    Service serving football leagues seasons results
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Docker deployment](#docker-deployment)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

To run `Football` locally, one needs elixir and erlang to be installed. One of the easiest way is to use [asdf](https://asdf-vm.com/#/https://asdf-vm.com/#/) manager to install elixir and erlang. Preferable version of elixir:

* 1.9

### Installation

`Football` is using submodule for `.proto` definition file. [Submodule can be found here: proto-definitions](https://github.com/Keedix/proto-definitions)

1.  Clone the repository

```sh
git clone https://github.com/Keedix/football.git
```

2.  Fetch the submodule. `Football` is using submodule for `.proto` definition file. [Submodule can be found here: proto-definitions](https://github.com/Keedix/proto-definitions)

```sh
git submodule update --init
```

4.  Fetch dependencies

```sh
mix deps.get
```

4.  Run in interactive mode

```sh
iex -S mix phx.server
```

## Docker deployment

This section describes how to build and run the `Football` project in docker environment.

### Prerequisites

To build and run docker image one needs to have [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/) installed.

### Installation

Assuming that `docker` and `docker-compose` are installed there are simple steps to run application in container.

1.  Run as multi instance with [HAproxy](http://www.haproxy.org/) in front of N instances.

```sh
docker-compose up -d --scale web=3
```

The `docker-compose.yml` contains configuration describing the port on which the HAproxy is running on top of `Football` instances.

2.  Run only `Football`

```sh
docker-compose up -d web
```
