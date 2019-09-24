FROM elixir:1.9-alpine as releaser
    ENV MIX_ENV=prod

    RUN mkdir /opt/app  
    WORKDIR /opt/app

    # Get all needed project files, configs and source and other resources from priv
    COPY mix.exs mix.lock ./
    COPY lib/ ./lib
    COPY priv/ ./priv
    COPY config/ ./config
    
    # Install hex and rebar
    RUN mix local.hex --force
    RUN mix local.rebar --force
    # Get all dependencies
    RUN mix deps.get
    # Create release for next stage
    RUN mix release

FROM alpine:latest
    ENV LANG=C.UTF-8

    # Install openssl
    RUN apk update && apk add openssl ncurses-libs
    RUN mkdir /target
    WORKDIR /target
    
    # Get ready release from releaser stage
    COPY --from=releaser /opt/app/_build/prod/rel/football/ ./football

    # https://stackoverflow.com/a/49955098
    # Create a group and user to run application no as sudo
    RUN addgroup -S appgroup && adduser -S appuser -G appgroup
    
    RUN chown -R appuser: ./football
    # Tell docker that all future commands should run as the appuser user
    USER appuser

    # Run start command from release. Other possible commands:
    # https://elixir-lang.org/blog/2019/06/24/elixir-v1-9-0-released/ 
    CMD ["./football/bin/football", "start"]