defmodule RentsDb.Repo do
  use Ecto.Repo,
    otp_app: :rents_db,
    adapter: Ecto.Adapters.Postgres
end
