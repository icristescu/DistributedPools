defmodule Renting.Req.Request do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query


  schema "requests" do
    field :cost, :integer
    field :nbdays, :integer
    field :period, :string
    field :status, :string
    belongs_to :user, Renting.Accounts.User
    field :appart_id, :id

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:nbdays, :cost, :status, :period])
    |> validate_required([:nbdays])
    #|> foreign_key_constraint(:user_id, message: "Select a valid user id")
    #|> foreign_key_constraint(:appart_id, message: "Select a valid appart id")
    #|> set_cost
  end

  defp set_cost(cs) do
    case cs.changes[:nbdays] do
      nil -> cs
      nbdays ->

	case cs.changes[:appart_id] do
	  nil -> cs
	  a_id ->
	    q = from a in Renting.Appart,
	      where: a.id == ^a_id,
	      select: {a.rent_day}

	    [{day}|_] = Renting.Repo.all q
	    cost =day*nbdays
	    put_change(cs, :cost, cost)
	end
    end
  end
end
