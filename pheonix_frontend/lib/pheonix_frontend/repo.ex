defmodule PheonixFrontend.Repo do
  use Ecto.Repo,
    otp_app: :pheonix_frontend,
    adapter: Ecto.Adapters.Postgres
end
