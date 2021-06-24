# Echo

A tiny echo server written in Gleam! It'll reply with any body posted to
`/echo`.

More importantly it's also an example web application written in the
[Gleam](https://gleam.run) programming language!

## Run

```sh
# Start the web server locally
rebar3 shell
```

## Docker

Build with:

```sh
docker build -t gleam-echo:latest .
```

Run with:

```sh
docker run --rm -p 3000:3000 gleam-echo:latest
```

And load `http://localhost:3000` in your browser. You should see an instruction to interact with
the server by POST-ing to `http://localhost:3000/echo` which you can test with:

```sh
curl -X POST -d "hello gleam" http://localhost:3000/echo
```
