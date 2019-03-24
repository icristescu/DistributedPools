defmodule Renting.Repo.Migrations.CreateApparts do
  use Ecto.Migration

  def change do
    create table(:apparts) do
      add :rent_day, :integer
      add :description, :string

      timestamps()
    end

  end
end
