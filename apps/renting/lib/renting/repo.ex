defmodule Renting.Repo do
  use Ecto.Repo,
    otp_app: :renting,
    adapter: Ecto.Adapters.Postgres
end
