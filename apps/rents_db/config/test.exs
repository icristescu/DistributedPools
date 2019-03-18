use Mix.Config

config :rents_db, RentsDb.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "rents_db_test",
  username: "icristes",
  password: "Sound1234",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
