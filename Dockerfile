# Build image
FROM erlang:23.1-alpine AS build

run mkdir /downloads
add https://github.com/gleam-lang/gleam/releases/download/v0.14.4/gleam-v0.14.4-linux-amd64.tar.gz /downloads
workdir /downloads
run tar zxf ./gleam-v0.14.4-linux-amd64.tar.gz
run cp gleam /usr/bin/gleam
run chmod +x /usr/bin/gleam

copy . /src
workdir /src

run rebar3 release

# Release image
FROM alpine:3.9 AS app

RUN apk add --no-cache bash openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /src/_build/default/rel/echo ./

ENV HOME=/app

EXPOSE 3000

CMD ["/app/bin/echo", "foreground"]
