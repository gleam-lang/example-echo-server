//
// A gen_server that serves as an in-memory database of ids and urls.
//
// We don't have good gen_server bindings yet, so it includes some unsafe FFI.
//

import map_dict
import str
import atom

external type Charlist;
external fn int_to_charlist(Int) -> Charlist = "erlang" "integer_to_list";
external fn charlist_to_string(Charlist) -> String = "erlang" "list_to_binary";

fn int_to_string(i) {
  i |> int_to_charlist |> charlist_to_string
}

pub enum Response(reply, state) =
  | Reply(reply, state)
  | Noreply(state)

pub enum Call =
  | Save(String)
  | Get(String)

pub fn init(_arg) {
  let links = map_dict:new()
  Ok(links)
}

pub fn handle_call(call, _from, links) {
  case call {
  | Get(id) ->
      let link = map_dict:fetch(links, id)
      Reply(link, links)

  | Save(link) ->
      let id = links |> map_dict:size |> int_to_string
      let new_links = map_dict:put(links, id, link)
      Reply(Ok(id), new_links)
  }
}

pub fn handle_cast(_cast, links) {
  Noreply(links)
}

external fn gen_server_call(atom:Atom, Call) -> Result(String, map_dict:NotFound) =
  "gen_server" "call"

fn call(payload) {
  "tiny_db"
  |> atom:create_from_string
  |> gen_server_call(_, payload)
}

pub fn get(id) {
  call(Get(id))
}

pub fn save(link) {
  let Ok(i) = call(Save(link))
  i
}
