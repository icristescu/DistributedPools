defmodule RentsDb.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
     create table(:requests) do
       add :status, :text
       add :apt_id, references(:appartments)
       add :description, :text

       timestamps()
     end
  end
end
