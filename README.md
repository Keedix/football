<!-- PROJECT LOGO -->

<br />
<p align="center">
  <h3 align="center">Football</h3>

  <p align="center">
    Service serving football leagues seasons results
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Docker deployment](#docker-deployment)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Api documentation](#api-documentation)

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

To run `Football` locally, one needs elixir and erlang to be installed. One of the easiest way is to use [asdf](https://asdf-vm.com/#/https://asdf-vm.com/#/) manager to install elixir and erlang. Required version of elixir: `1.9.X`.

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

To create release locally, shipped with erts and set as production env, run:

```
MIX_ENV=prod mix release
```

```
Release created at _build/prod/rel/football!

    # To start your system
    _build/prod/rel/football/bin/football start

Once the release is running:

    # To connect to it remotely
    _build/prod/rel/football/bin/football remote

    # To stop it gracefully (you may also send SIGINT/SIGTERM)
    _build/prod/rel/football/bin/football stop

To list all commands:

    _build/prod/rel/football/bin/football
```

### Other usful tasks

- Run tests

````

mix test

```

- Run static types analysis (may take a while first time)

```

mix dialyzer

```

- Run tests coverage

```

mix coveralls

```

- Run credo, static analysis for code consistency

```

mix credo -a

````

## Docker deployment

This section describes how to build and run the `Football` project in docker environment.

### Prerequisites

To build and run docker image one needs to have [docker](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [docker-compose](https://docs.docker.com/compose/) installed.
Docker compose schema in version `3` must be supported. For additonal information there is a table of versions supporting schema `3` and higher https://docs.docker.com/compose/compose-file/.

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

## Api documentation

### Leagues

- **PATH**

  `/api/1.0/leagues`

- **METHOD**

  `GET`

- **HEADERS**

  `Accept: application/json`

  or

  `Accept: application/vnd.google.protobuf`

  If no `Accept` header provided, `application/json` content-type will be provided.

- **Success Response**

  - JSON

    Code: 200
    
    Content:

    ```json
    {
      "data": {
        "leagues_seasons": [{ "league": "SP1", "season": "2015-2016" }]
      }
    }
    ```

  - PROTOBUF

    Code: 200

    Content: Binary

    ```
    message LeagueSeason {
      optional string league = 1;
      optional string season = 2;
    }

    message LeaguesSeasons {
      repeated LeagueSeason leaguesSeasons = 1;
      optional int32 statusCode = 2;
      optional string message = 3;
    }
    ```

- **Error Response**

  - JSON

    Code: 500

    Content:

    ```json
    {
      "error": {
        "code": 500,
        "message": "Internal Server Error"
      }
    }
    ```

  - PROTOBUF

    Code: 500

    Content: Binary


    ```
    message LeagueSeason {
    optional string league = 1;
      optional string season = 2;
    }

    message LeaguesSeasons {
      repeated LeagueSeason leaguesSeasons = 1;
      optional int32 statusCode = 2;
      optional string message = 3;
    }
    ```

- **Example**

For JSON body response:

```sh

curl -XGET http://localhost:4004/api/1.0/leagues -H "Accept: application/json"
```

For protobuf encoded body response:

```sh
curl -XGET http://localhost:4004/api/1.0/leagues -H "Accept: application/vnd.google.protobuf"
```

---

- **PATH**

  `/api/1.0/leagues/:league/seasons/:season`

- **METHOD**

  `GET`

* **HEADERS**

  `Accept: application/json`

  or

  `Accept: application/vnd.google.protobuf`

  If no `Accept` header provided, `application/json` content-type will be provided.

* **Success Response**

  - JSON

    Code: 200

    Content:

    ```json
    {
      "data": {
        "game_results": [
          {
            "away_team": "Levante",
            "date": "15/05/2016",
            "ftag": "1",
            "fthg": "3",
            "ftr": "H",
            "home_team": "Vallecano",
            "htag": "0",
            "hthg": "2",
            "htr": "H",
            "league": "SP1",
            "season": "2015-2016"
          }
        ]
      }
    }
    ```

  - PROTOBUF

    Code: 200

    Content: Binary

    ```
    message GameResult {
      optional string league = 1;
      optional string season = 2;
      optional string date = 3;
      optional string homeTeam = 4;
      optional string awayTeam = 5;
      optional string fthg = 6;
      optional string ftag = 7;
      optional string ftr = 8;
      optional string hthg = 9;
      optional string htag = 10;
      optional string htr = 11;
    }

    message GameResults {
      repeated GameResult gameResults = 1;
      optional int32 statusCode = 2;
      optional string message = 3;
    }
    ```

- **Error Response**

  - JSON

    Code: 404

    Content:

    ```json
    {
      "error": {
        "code": 404,
        "message": "League 'PS1' in season '2017-2018' wasn't found"
      }
    }
    ```

  - PROTOBUF

    Code: 404

    Content: Binary


    ```
    message GameResult {
      optional string league = 1;
      optional string season = 2;
      optional string date = 3;
      optional string homeTeam = 4;
      optional string awayTeam = 5;
      optional string fthg = 6;
      optional string ftag = 7;
      optional string ftr = 8;
      optional string hthg = 9;
      optional string htag = 10;
      optional string htr = 11;
    }

    message GameResults {
      repeated GameResult gameResults = 1;
      optional int32 statusCode = 2;
      optional string message = 3;
    }
    ```
