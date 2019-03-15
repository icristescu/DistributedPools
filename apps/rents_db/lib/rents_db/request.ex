defmodule RentsDb.Request do
  use Ecto.Schema

  import Ecto.Changeset
  alias RentsDb.Appartment

  schema "requests" do

    belongs_to :apt, Appartment, type: :id

    field :status, :string
    field :description, :string

    timestamps()
  end

  @fields ~w(apt_id status description)a

  def changeset(req, params \\ %{}) do
    req
    |> cast(params, @fields)
    |> foreign_key_constraint(:apt_id, message: "Select a valid appartment")
    end
end
