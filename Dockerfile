# Build image
FROM erlang:23.1-alpine AS build

ARG version=0.14.4

RUN mkdir /downloads
ADD https://github.com/gleam-lang/gleam/releases/download/v${version}/gleam-v${version}-linux-amd64.tar.gz /downloads
WORKDIR /downloads
RUN tar zxf ./gleam-v${version}-linux-amd64.tar.gz
RUN cp gleam /usr/bin/gleam
RUN chmod +x /usr/bin/gleam

COPY . /src
WORKDIR /src

RUN rebar3 release

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
