# Echo

A tiny echo server written in Gleam! It'll reply with any body posted to
`/echo`.

More importantly it's also an example web application written in the
[Gleam](https://gleam.run) programming language!

## Run

```sh
# Start the web server locally
gleam run

# Send a request to the server
curl -X POST -d "Hello, Gleam!" http://localhost:3000/echo
```
