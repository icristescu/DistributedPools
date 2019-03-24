defmodule Renting.Appart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apparts" do
    field :description, :string
    field :rent_day, :integer

    timestamps()
  end

  @doc false
  def changeset(appart, attrs\\ %{}) do
    appart
    |> cast(attrs, [:rent_day, :description])
    |> validate_required([:rent_day, :description])
  end
end
