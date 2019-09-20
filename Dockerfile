FROM elixir:1.9-alpine

ENV MIX_ENV=prod

WORKDIR /opt/app

    COPY mix.exs mix.lock ./

RUN mix release --env=${MIX_ENV}

ENTRYPOINT [ "/opt/app/bin/football" ]
CMD ["foreground"]