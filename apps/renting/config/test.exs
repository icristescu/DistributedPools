use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :renting, RentingWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :renting, Renting.Repo,
  username: "icristes",
  password: "Sound1234",
  database: "renting_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
