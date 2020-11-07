import gleam/otp/supervisor.{ApplicationStartMode, add, worker}
import gleam/otp/process
import gleam/dynamic.{Dynamic}
import gleam/result
import echo/web

fn init(children) {
  children
  |> add(worker(fn(_) { web.start() }))
}

pub fn start(_mode: ApplicationStartMode, _args: List(Dynamic)) {
  init
  |> supervisor.start
  |> result.map(process.pid)
}

pub fn stop(_state: Dynamic) {
  supervisor.application_stopped()
}
