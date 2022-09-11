import echo/web
import gleam/io
import gleam/int
import gleam/string
import gleam/result
import gleam/erlang/process
import gleam/erlang/os
import gleam/http/elli

pub fn main() {
  let port =
    os.get_env("PORT")
    |> result.then(int.parse)
    |> result.unwrap(3000)

  // Start the web server process
  assert Ok(_) =
    web.stack()
    |> elli.start(on_port: port)

  ["Started listening on localhost:", int.to_string(port), " ✨"]
  |> string.concat
  |> io.println

  // Put the main process to sleep while the web server does its thing
  process.sleep_forever()
}
