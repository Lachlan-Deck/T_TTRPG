# lib/Roller/Routers/router.ex
defmodule Roller.Routers.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug :match 
  plug :dispatch

    
  forward "/graphql",
    to: Absinthe.Plug,
    init_opts: [schema: Roller.Schema]

  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: Roller.Schema]
  
  match _ do
    send_resp(conn, 404, "Not Found")
    end
end
