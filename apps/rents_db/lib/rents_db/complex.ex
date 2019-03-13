defmodule RentsDb.Complex do
  use Ecto.Schema

  import Ecto.Changeset

  schema "complexes" do
    field :name, :string

    timestamps()
  end

  def changeset(complex, params \\ %{}) do
    complex
    |> cast(params, [:name])
    |> validate_required([:name])
  end

end
