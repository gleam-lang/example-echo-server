import gleam/bit_builder.{BitBuilder}
import gleam/bit_string
import gleam/result
import gleam/elli
import gleam/http.{Post}

pub fn echo(body: BitString) {
  http.response(200)
  |> http.set_resp_body(body)
}

pub fn not_found() {
  let body = "There's nothing here. Try POSTing to /echo"
    |> bit_string.from_string

  http.response(200)
  |> http.set_resp_body(body)
}

pub fn router(req: http.Request(BitString)) {
  let path = http.req_segments(req)

  case req.method, path {
    Post, ["echo"] -> echo(req.body)
    _, _ -> not_found()
  }
}

pub fn service(req: http.Request(BitString)) {
  req
  |> router
  |> http.prepend_resp_header("made-with", "Gleam")
  |> http.map_resp_body(bit_builder.from_bit_string)
}

pub fn start() {
  elli.start(service, on_port: 3000)
  |> result.map_error(fn(_) { "failed to start" })
}
