defmodule RentsDb.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :name, :text

      timestamps()
    end
  end
end
