defmodule RentsDb.Repo.Migrations.CreateAppartements do
  use Ecto.Migration

  def change do
    create table(:appartments) do
      add :unit_number, :text
      add :building_id, references(:buildings)

      timestamps()
    end
  end
end
