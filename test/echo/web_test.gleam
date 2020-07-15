import echo/web
import gleam/http.{Get, Post, Response}
import gleam/should
import gleam/should

pub fn not_found_test() {
  let resp = http.default_req()
    |> http.set_req_method(Get)
    |> http.set_req_path("/")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(404)

  resp.body
  |> should.equal(<<"There's nothing here. Try POSTing to /echo":utf8>>)
}

pub fn hello_nubi_test() {
  let resp = http.default_req()
    |> http.set_req_method(Get)
    |> http.set_req_path("/hello/Nubi")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Nubi!":utf8>>)
}

pub fn hello_joe_test() {
  let resp = http.default_req()
    |> http.set_req_method(Get)
    |> http.set_req_path("/hello/Mike")
    |> http.set_req_body(<<>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Joe!":utf8>>)
}

pub fn echo_1_test() {
  let resp = http.default_req()
    |> http.set_req_method(Post)
    |> http.set_req_path("/echo")
    |> http.set_req_body(<<1, 2, 3, 4>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<1, 2, 3, 4>>)
}

pub fn echo_2_test() {
  let resp = http.default_req()
    |> http.set_req_method(Post)
    |> http.set_req_path("/echo")
    |> http.set_req_body(<<"Hello, Gleam!":utf8>>)
    |> web.service()

  resp.status
  |> should.equal(200)

  resp.body
  |> should.equal(<<"Hello, Gleam!":utf8>>)
}
