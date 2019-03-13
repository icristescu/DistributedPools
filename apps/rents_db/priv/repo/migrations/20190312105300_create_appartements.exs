defmodule RentsDb.Repo.Migrations.CreateAppartements do
  use Ecto.Migration

  def change do
    create table(:appartments) do
      add :unit_number, :text
      add :building_id, references(:buildings)
      add :rent_month, :integer
      add :rent_year, :integer

      timestamps()
    end
  end
end
