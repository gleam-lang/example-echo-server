import gleam/string
import gleam/atom
import gleam/list
import gleam/iodata
import gleam/elli
import gleam/http.{Get, Post}
import tiny/db
import tiny/html

fn home() {
  tuple(200, [], html.home())
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
      tuple(201, [], iodata.new(id))
    }

    Error(_) ->
      // TODO. HTML
      tuple(422, [], iodata.new("That doesn't look right."))
  }
}

fn get_link(id) {
  case db.get(id) {
    Ok(link) ->
      tuple(200, [], iodata.new(link))

    Error(_) ->
      tuple(404, [], html.not_found())
  }
}

fn not_found() {
  tuple(404, [], html.not_found())
}

pub fn handle(request, _args) {
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

pub type HandleEvent {
  Ok
}

pub fn handle_event(_event, _data, _args) -> HandleEvent {
  Ok
}
