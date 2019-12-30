import gleam/iodata

fn layout(content) {
  let top = "<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"utf-8\">
    <meta name=\"viewport\" content=\"width=device-width\">
    <title>Tiny - A Gleam URL shortener</title>
  </head>
  <body>"
  let bottom = "
  </body>
</html>"

  iodata.new(top)
  |> iodata.append(_, content)
  |> iodata.append(_, bottom)
  |> iodata.to_string
}

pub fn home() {
  let content = "<h1>Tiny</h1>

<form action=\"/link\" method=\"post\" accept-charset=\"utf-8\">
  <input type=\"text\" name=\"link\">
  <input type=\"submit\">
</form>"

  layout(content)
}

pub fn not_found() {
  let content = "<h1>There's nothing here...</h1>
<a href=\"/\">Return to home</a>"

  layout(content)
}
