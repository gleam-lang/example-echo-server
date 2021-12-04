import echo/web
import gleam/io
import gleam/erlang
import gleam/http/elli

pub fn main() {
  // Start the web server process
  assert Ok(_) = elli.start(web.stack(), on_port: 3000)

  io.println("Started listening on localhost:3000 ✨")

  // Put the main process to sleep while the web server does its thing
  erlang.sleep_forever()
}
