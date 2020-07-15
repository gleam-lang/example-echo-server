import gleam/atom.{Atom}
import gleam/dynamic.{Dynamic}
import gleam/otp/basic_supervisor.{OneForAll, Permanent, Spec, WorkerSpec}
import gleam/otp/application.{StartType}
import echo/web

pub fn start(_start: StartType, _arg: Dynamic) {
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

pub fn stop(_state: Dynamic) {
  atom.create_from_string("ok")
}
