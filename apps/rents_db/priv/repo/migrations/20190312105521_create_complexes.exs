defmodule RentsDb.Repo.Migrations.CreateComplexes do
  use Ecto.Migration

  def change do
    create table(:complexes) do
      add :name, :text

      timestamps()
    end
  end
end
