# lib/systems/server/router_system.ex
defmodule Systems.Router do
  use Plug.Router

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug :match 
  plug :dispatch

    
  forward "/graphql",
    to: Absinthe.Plug,
    init_opts: [schema: Systems.Schema]

  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [schema: Systems.Schema]
  
  match _ do
    send_resp(conn, 404, "Not Found")
    end
end
