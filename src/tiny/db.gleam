//
// A gen_server that serves as an in-memory database of ids and urls.
//
// We don't have good gen_server bindings yet, so it includes some unsafe FFI.
//

import gleam/map
import gleam/string
import gleam/atom
import gleam/int

pub type Response(reply, state) {
  Reply(reply, state)
  Noreply(state)
}

pub type Call {
  Save(String)
  Get(String)
}

pub fn init(_arg) {
  let links = map.new()
  Ok(links)
}

pub fn handle_call(call, _from, links) {
  case call {
    Get(id) -> {
      let link = map.get(links, id)
      Reply(link, links)
    }

    Save(link) -> {
      let id = links |> map.size |> int.to_string
      let new_links = map.insert(links, id, link)
      Reply(Ok(id), new_links)
    }
  }
}

pub fn handle_cast(_cast, links) {
  Noreply(links)
}

external fn gen_server_call(atom.Atom, Call) -> Result(String, Nil) =
  "gen_server" "call"

fn call(payload) {
  "tiny_db"
  |> atom.create_from_string
  |> gen_server_call(_, payload)
}

pub fn get(id) {
  call(Get(id))
}

pub fn save(link) {
  let Ok(i) = call(Save(link))
  i
}
