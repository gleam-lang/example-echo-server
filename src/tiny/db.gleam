//
// A process that serves as an in-memory database of ids and urls.
//

import gleam/atom.{Atom}
import gleam/int
import gleam/map.{Map}
import gleam/otp/agent.{Reply, Continue}
import gleam/otp/process.{Pid}
import gleam/string

pub type Name {
  TinyDb
};

// TODO: use registration from agent module once supported
external fn register(Name, Pid(a)) -> Bool
  = "erlang" "register"

external fn unsafe_self() -> Pid(agent.Msg(Map(String, String)))
  = "erlang" "self"

external fn name_to_pid(Name) -> Pid(agent.Msg(Map(String, String)))
  = "gleam@dynamic" "unsafe_coerce"

pub fn start_link() {
  agent.start_link(fn() {
    register(TinyDb, unsafe_self())
    agent.Ready(map.new())
  })
}

fn singleton() {
  name_to_pid(TinyDb)
}

pub fn get(id) {
  let get_fn = fn(links) {
    let link = map.get(links, id)
    Reply(link, Continue(links))
  }
  agent.sync(singleton(), get_fn)
}

pub fn save(link) {
  let save_fn = fn(links) {
    let id = links |> map.size |> int.to_string
    let new_links = map.insert(links, id, link)
    Reply(id, Continue(new_links))
  }
  agent.sync(singleton(), save_fn)
}
