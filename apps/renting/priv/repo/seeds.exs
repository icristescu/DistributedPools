# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Renting.Repo.insert!(%Renting.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Renting.Repo
alias Renting.Appart

Repo.insert!(%Appart{rent_day: 100, description: "small"})
Repo.insert!(%Appart{rent_day: 100, description: "small"})
Repo.insert!(%Appart{rent_day: 200, description: "pretty"})
Repo.insert!(%Appart{rent_day: 300, description: "nice"})
Repo.insert!(%Appart{rent_day: 500, description: "very nice"})
