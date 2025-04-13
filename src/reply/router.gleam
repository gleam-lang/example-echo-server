import reply/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    ["echo"] -> web.reply(req)
    ["hello", name] -> web.hello(name)
    _ -> web.not_found()
  }
}
