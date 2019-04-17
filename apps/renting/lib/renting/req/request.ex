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
    |> cast(attrs, [:appart_id, :nbdays, :period])
    |> validate_required([:nbdays])
    |> foreign_key_constraint(:user_id, message: "Select a valid user id")
    |> foreign_key_constraint(:appart_id, message: "Select a valid appart id")
    |> set_cost(request)
    |> set_status
  end

  defp set_cost(cs, request) do
    nbdays =
      case cs.changes[:nbdays] do
	nil -> request[:nbdays]
	nbdays -> nbdays
      end
    appart_id =
      case cs.changes[:appart_id] do
	nil -> request[:appart_id]
	appart_id -> appart_id
      end
    IO.inspect nbdays, label: "nbdays ="
    IO.inspect appart_id, label: "appart_id ="

    q = from a in Renting.Appart,
      where: a.id == ^appart_id,
      select: {a.rent_day}

    [{day}|_] = Renting.Repo.all q
    cost =day*nbdays

    IO.inspect cost, label: "cost ="

    put_change(cs, :cost, cost)
  end

  defp set_status(cs) do
    put_change(cs, :status, "pending")
  end

end
