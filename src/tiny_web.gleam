import str
import atom
import list
import iodata
import tiny_db
import tiny_html
import gleam_elli

fn home() {
  {200, [], tiny_html.home()}
}

fn extract_link(formdata) {
  formdata
  |> str.split(_, "\n")
  |> list.map(_, str.split(_, "="))
  |> list.find(_, fn(parts) {
    case parts {
    | ["link", link] -> link |> gleam_elli.uri_decode |> Ok
    | _other -> Error(0)
    }
  })
}

fn create_link(payload) {
  case extract_link(payload) {
  | Ok(link) ->
      let id = link |> tiny_db.save |> iodata.new
      {201, [], id} // TODO. HTML

  | Error(_) ->
      {422, [], iodata.new("That doesn't look right.")} // TODO. HTML
  }
}

fn get_link(id) {
  case tiny_db.get(id) {
  | Ok(link) ->
      {200, [], iodata.new(link)}

  | Error(_) ->
      {404, [], tiny_html.not_found()}
  }
}

fn not_found() {
  {404, [], tiny_html.not_found()}
}

pub fn handle(request, _args) {
  let method = gleam_elli.method(request)
  let path = gleam_elli.path(request)

  case {method, path} {
  | {gleam_elli.Get, []} ->
      home()

  | {gleam_elli.Post, ["link"]} ->
      request |> gleam_elli.body |> create_link

  | {gleam_elli.Get, ["link", id]} ->
      get_link(id)

  | _ ->
      not_found()
  }
}

pub fn handle_event(_event, _data, _args) {
  atom.create_from_string("ok")
}
