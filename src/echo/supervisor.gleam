import gleam/atom.{Atom}
import gleam/dynamic.{Dynamic}
import gleam/otp/basic_supervisor.{OneForAll, Permanent, Spec, WorkerSpec}
import echo/web

pub external type Node

pub type StartType {
  Normal
  Takeover(Node)
  Failover(Node)
}

pub fn start(_: StartType, _: Dynamic) {
  let web = WorkerSpec(
    id: "web",
    start: web.start,
    restart: Permanent,
    shutdown: 2000,
  )

  basic_supervisor.start_link(
    Spec(strategy: OneForAll, intensity: 1, period: 5, children: [web]),
  )
}

pub fn stop(_: Dynamic) {
  atom.create_from_string("ok")
}
