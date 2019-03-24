defmodule Renting.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :nbdays, :integer
      add :cost, :integer
      add :status, :string
      add :period, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :appart_id, references(:apparts, on_delete: :nothing)

      timestamps()
    end

    create index(:requests, [:user_id])
    create index(:requests, [:appart_id])
  end
end
