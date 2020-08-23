import gleam/http
import gleam/int
import gleam/io
import gleam/string
import gleam/string_builder

fn format_log_line(req: http.Request(a), resp: http.Response(b)) -> String {
  req.method
  |> http.method_to_string
  |> string.uppercase
  |> string_builder.from_string
  |> string_builder.append(" ")
  |> string_builder.append(int.to_string(resp.status))
  |> string_builder.append(" ")
  |> string_builder.append(req.path)
  |> string_builder.to_string
}

pub fn middleware(service: http.Service(a, b)) -> http.Service(a, b) {
  fn(req) {
    let resp = service(req)
    io.println(format_log_line(req, resp))
    resp
  }
}
