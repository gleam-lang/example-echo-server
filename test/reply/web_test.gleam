import gleeunit/should
import reply/router
import wisp/testing

pub fn not_found_test() {
  let response =
    testing.get("/", [])
    |> router.handle_request()

  response.status
  |> should.equal(404)

  response
  |> testing.string_body
  |> should.equal("There's nothing here. Try POSTing to /echo")
}

pub fn hello_nubi_test() {
  let response =
    testing.get("/hello/Nubi", [])
    |> router.handle_request()

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> should.equal("Hello, Nubi!")
}

pub fn hello_joe_test() {
  let response =
    testing.get("/hello/Mike", [])
    |> router.handle_request()

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> should.equal("Hello, Joe!")
}

pub fn echo_1_test() {
  let response =
    testing.post("/echo", [], "Hello, Gleam!")
    |> testing.set_header("content-type", "text/plain")
    |> router.handle_request()

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> should.equal("Hello, Gleam!")

  response.headers
  |> should.equal([#("content-type", "text/plain"), #("made-with", "Gleam")])
}

pub fn echo_2_test() {
  let response =
    testing.post("/echo", [], "Hello, Gleam!")
    |> testing.set_header("content-type", "application/octet-stream")
    |> router.handle_request()

  response.status
  |> should.equal(200)

  response
  |> testing.string_body
  |> should.equal("Hello, Gleam!")

  response.headers
  |> should.equal([
    #("content-type", "application/octet-stream"),
    #("made-with", "Gleam"),
  ])
}
