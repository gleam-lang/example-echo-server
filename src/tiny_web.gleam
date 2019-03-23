import atom
import iodata
import tiny_db
import tiny_html
import gleam_elli

fn home() {
  {200, [], tiny_html:home()}
}

fn create_link(payload) {
  // TODO: parse form data
  let body =
    payload
    |> tiny_db:save
    |> iodata:new
  {201, [], body}
}

fn get_link(id) {
  case tiny_db:get(id) {
  | Ok(link) ->
      {200, [], iodata:new(link)}

  | Error(_) ->
      {404, [], tiny_html:not_found()}
  }
}

fn not_found() {
  {404, [], tiny_html:not_found()}
}

pub fn handle(request, _args) {
  let method = gleam_elli:method(request)
  let path = gleam_elli:path(request)

  case {method, path} {
  | {gleam_elli:Get, []} ->
      home()

  | {gleam_elli:Post, ["link"]} ->
      request |> gleam_elli:body |> create_link

  | {gleam_elli:Get, ["link", id]} ->
      get_link(id)

  | _ ->
      not_found()
  }
}


pub fn handle_event(_event, _data, _args) {
  atom:create_from_string("ok")
}
