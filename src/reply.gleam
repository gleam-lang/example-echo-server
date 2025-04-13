import envoy
import gleam/erlang/process
import gleam/int
import gleam/result
import mist
import reply/router
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  let port =
    envoy.get("PORT")
    |> result.then(int.parse)
    |> result.unwrap(3000)

  let secret_key_base = wisp.random_string(64)

  // Start the web server process
  let assert Ok(_) =
    wisp_mist.handler(router.handle_request, secret_key_base)
    |> mist.new
    |> mist.port(port)
    |> mist.start_http

  // Put the main process to sleep while the web server does its thing
  process.sleep_forever()
}
