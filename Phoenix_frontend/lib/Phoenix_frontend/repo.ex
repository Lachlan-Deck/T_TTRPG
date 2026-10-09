defmodule PhoenixFrontend.Repo do
  use Ecto.Repo,
    otp_app: :Phoenix_frontend,
    adapter: Ecto.Adapters.Postgres
end
