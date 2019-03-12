defmodule RentsDb.Repo.Migrations.CreateBuildings do
  use Ecto.Migration

  def change do
    create table(:buildings) do
      add :complex_id, :integer
      add :name, :text
      add :address, :text

      timestamps()
    end

  end
end
