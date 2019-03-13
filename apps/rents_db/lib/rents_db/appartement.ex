defmodule RentsDb.Appartment do
  use Ecto.Schema

  import Ecto.Changeset
  alias RentsDb.Building

  schema "appartments" do
    belongs_to :building, Building, type: :id

    field :unit_number, :string
    field :rent_month, :integer
    field :rent_year, :integer

    timestamps()
  end

  @fields ~w(building_id unit_number rent_month rent_year)a

  def changeset(appart, params \\ %{}) do
    appart
    |> cast(params, @fields)
    |> foreign_key_constraint(:building_id, message: "Select a valid building")
    |> validate_number(:rent_month, greater_than_or_equal_to: 0)
    |> set_rent_year
  end

  defp set_rent_year(cs) do
    case cs.changes[:rent_month] do
      nil -> cs
      rent -> put_change(cs, :rent_year, rent*12)
    end
  end

end
