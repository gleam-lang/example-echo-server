import atom
import iodata
import tiny_db
import tiny_html

pub external type Request;

pub external fn request_path(Request) -> List(String) = "elli_request" "path";
pub external fn request_body(Request) -> String = "elli_request" "body";

pub fn handle(request, _args) {
  case request_path(request) {
  | [] ->
    {200, [], tiny_html:home()}

  | ["link"] ->
      let body = request
        |> request_body
        |> tiny_db:save
        |> iodata:new
      {201, [], body}

  | ["link", id] ->
      case tiny_db:get(id) {
      | Ok(link) ->
          {200, [], iodata:new(link)}

      | Error(_) ->
          {404, [], tiny_html:not_found()}
      }

  | _ ->
      {404, [], tiny_html:not_found()}
  }
}


pub fn handle_event(_event, _data, _args) {
  atom:create_from_string("ok")
}
