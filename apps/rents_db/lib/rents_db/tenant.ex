defmodule RentsDb.Tenant do
  use Ecto.Schema

  import Ecto.Changeset

  schema "tenants" do
    field :name, :string

    timestamps()
  end

  def changeset(tenant, params \\ %{}) do
    tenant
    |> cast(params, [:name])
    |> validate_required([:name])
  end

end
