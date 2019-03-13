defmodule RentsDb.Building do
  use Ecto.Schema

  import Ecto.Changeset
  alias RentsDb.Complex


  schema "buildings" do
    belongs_to :complex, Complex, type: :id
    field :name, :string
    field :address, :string

    timestamps()
  end

  @fields ~w(complex_id name address)a

  def changeset(building, params \\ %{}) do
    building
    |> cast(params, @fields)
    |> validate_required([:complex_id, :name])
    |> validate_inclusion(:complex_id, 1..10)
    |> foreign_key_constraint(:complex_id, message: "Select a valid complex")
  end

end
