import gleam/string
import gleam/atom
import gleam/list
import gleam/iodata
import gleam/elli.{Response}
import gleam/http.{Get, Post}
import tiny/db
import tiny/html

fn home() {
  Response(200, [], html.home())
}

fn extract_link(formdata) {
  formdata
  |> string.split(_, "\n")
  |> list.map(_, string.split(_, "="))
  |> list.find_map(_, fn(parts) {
    case parts {
      ["link", link] -> link |> elli.uri_decode |> Ok
      _other -> Error(0)
    }
  })
}

fn create_link(payload) {
  case extract_link(payload) {
    Ok(link) -> {
      let id = db.save(link)
      // TODO. HTML
      Response(201, [], id)
    }

    Error(_) ->
      // TODO. HTML
      Response(422, [], "That doesn't look right.")
  }
}

fn get_link(id) {
  case db.get(id) {
    Ok(link) ->
      Response(200, [], link)

    Error(_) ->
      Response(404, [], html.not_found())
  }
}

fn not_found() {
  Response(404, [], html.not_found())
}

pub fn handle(request) {
  let method = elli.method(request)
  let path = elli.path(request)

  case method, path {
    Get, [] ->
      home()

    Post, ["link"] ->
      request |> elli.body |> create_link

    Get, ["link", id] ->
      get_link(id)

    _, _ ->
      not_found()
  }
}

pub fn start_link() {
  elli.start_link(3000, handle)
}
