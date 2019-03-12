defmodule RentsDb.Repo.Migrations.CreateAptTenants do
  use Ecto.Migration

  def change do
    create table(:apt_tenants, primary_key: false) do
      add :tenant_id, references(:tenants)
      add :apt_id, references(:appartments)

      timestamps()
    end
  end
end
