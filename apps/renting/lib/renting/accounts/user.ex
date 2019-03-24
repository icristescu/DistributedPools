defmodule Renting.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt


  schema "users" do
    field :name, :string
    field :password, :string
    field :password_hash, :string
    field :username, :string
    has_many :requests, Renting.Req.Request

    timestamps()
  end

  @doc false
  def changeset(user, attrs\\ %{}) do
    user
    |> cast(attrs, [:name, :username, :password, :password_hash])
    |> validate_required([:name, :username, :password])
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:password, min: 4, max: 10)
    |> put_pass_hash
    |> IO.inspect
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
				     %{password: password}} = changeset) do
    change(changeset, add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

end
