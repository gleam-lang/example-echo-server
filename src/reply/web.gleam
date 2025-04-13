import gleam/http.{Post}
import gleam/http/request
import gleam/http/response
import gleam/result
import gleam/string
import wisp.{type Request, type Response}

pub fn middleware(
  req: Request,
  handle_request: fn(Request) -> Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  use <- default_responses

  handle_request(req)
}

pub fn default_responses(handle_request: fn() -> Response) {
  let response = handle_request()

  response.set_header(response, "made-with", "Gleam")
}

pub fn reply(request: Request) {
  case request.method {
    Post -> reply_post_response(request)
    _ -> wisp.method_not_allowed([Post])
  }
}

fn reply_post_response(request: Request) {
  use body <- wisp.require_string_body(request)

  let content_type =
    request.get_header(request, "content-type")
    |> result.unwrap("application/octet-stream")

  wisp.ok()
  |> wisp.set_header("content-type", content_type)
  |> wisp.string_body(body)
}

pub fn hello(name) {
  let reply = case string.lowercase(name) {
    "mike" -> "Hello, Joe!"
    _ -> string.concat(["Hello, ", name, "!"])
  }

  wisp.ok()
  |> wisp.set_header("content-type", "text/plain")
  |> wisp.string_body(reply)
}

pub fn not_found() {
  wisp.not_found()
  |> wisp.set_header("content-type", "text/plain")
  |> wisp.string_body("There's nothing here. Try POSTing to /echo")
}
