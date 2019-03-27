ExUnit.start()
ExUnit.configure(exclude: [not_implemented: true])
Ecto.Adapters.SQL.Sandbox.mode(Renting.Repo, :manual)
