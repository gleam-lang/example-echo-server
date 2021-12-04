import echo/web
import gleam/http.{Get, Post}

pub fn not_found_test() {
  let resp =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/")
    |> http.set_req_body(<<>>)
    |> web.service()

  assert 404 = resp.status
  assert <<"There's nothing here. Try POSTing to /echo":utf8>> = resp.body
}

pub fn hello_nubi_test() {
  let resp =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/hello/Nubi")
    |> http.set_req_body(<<>>)
    |> web.service()

  assert 200 = resp.status
  assert <<"Hello, Nubi!":utf8>> = resp.body
}

pub fn hello_joe_test() {
  let resp =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/hello/Mike")
    |> http.set_req_body(<<>>)
    |> web.service()

  assert 200 = resp.status
  assert <<"Hello, Joe!":utf8>> = resp.body
}

pub fn echo_1_test() {
  let resp =
    http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<1, 2, 3, 4>>)
    |> http.prepend_req_header("content-type", "application/octet-stream")
    |> web.service()

  assert 200 = resp.status
  assert <<1, 2, 3, 4>> = resp.body
  assert Ok("application/octet-stream") =
    http.get_resp_header(resp, "content-type")
}

pub fn echo_2_test() {
  let resp =
    http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<"Hello, Gleam!":utf8>>)
    |> http.prepend_req_header("content-type", "text/plain")
    |> web.service()

  assert 200 = resp.status
  assert <<"Hello, Gleam!":utf8>> = resp.body
  assert Ok("text/plain") = http.get_resp_header(resp, "content-type")
}

pub fn echo_3_test() {
  let resp =
    http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<"Hello, Gleam!":utf8>>)
    |> web.service()

  assert 200 = resp.status
  assert <<"Hello, Gleam!":utf8>> = resp.body
  assert Ok("application/octet-stream") =
    http.get_resp_header(resp, "content-type")
}
