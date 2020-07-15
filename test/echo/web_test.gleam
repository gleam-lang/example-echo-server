import echo/web
import gleam/http.{Get, Post, Response}
import gleam/should
import gleam/should

pub fn not_found_test() {
  let resp = http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(404)

  resp.body
  |> should.equal(<<"There's nothing here. Try POSTing to /echo":utf8>>)
}

pub fn hello_nubi_test() {
  let resp = http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/hello/Nubi")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Nubi!":utf8>>)
}

pub fn hello_joe_test() {
  let resp = http.default_req()
    |> http.set_method(Get)
    |> http.set_path("/hello/Mike")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Joe!":utf8>>)
}

pub fn echo_1_test() {
  let resp = http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<1, 2, 3, 4>>)
    |> http.prepend_req_header("content-type", "application/octet-stream")
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<1, 2, 3, 4>>)

  resp
  |> http.get_resp_header("content-type")
  |> should.equal(Ok("application/octet-stream"))
}

pub fn echo_2_test() {
  let resp = http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<"Hello, Gleam!":utf8>>)
    |> http.prepend_req_header("content-type", "text/plain")
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Gleam!":utf8>>)

  resp
  |> http.get_resp_header("content-type")
  |> should.equal(Ok("text/plain"))
}

pub fn echo_3_test() {
  let resp = http.default_req()
    |> http.set_method(Post)
    |> http.set_path("/echo")
    |> http.set_req_body(<<"Hello, Gleam!":utf8>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Gleam!":utf8>>)

  resp
  |> http.get_resp_header("content-type")
  |> should.equal(Ok("application/octet-stream"))
}
