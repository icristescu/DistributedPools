defmodule RentsDb.Queries do
  alias RentsDb.{Appartment, Complex, Building, Tenant, Repo}

  import Ecto.Query

  def create(:complex,params) do
    Complex.changeset(%Complex{}, params)
    |> insert
  end
  def create(:appartement,params) do
    Appartment.changeset(%Appartment{}, params)
    |> insert
  end
  def create(:tenant, name) do
    Tenant.changeset(%Tenant{}, %{name: name})
    |> insert
  end

  defp insert(cs) do
    if cs.valid? do
      Repo.insert(cs)
    else cs
    end
  end

  def print_all(:complex) do
    q = from(i in Complex, select: %{name: i.name}, order_by: i.name)
    Repo.all(q)
  end
  def print_all(:building) do
    from(b in Building, select: {b.name, b.id})
    |> Repo.all
  end
  def print_all(:appartments) do
    from(a in Appartment, select: {a.id, a.unit_number, a.building_id, a.rent_month})
    |> Repo.all
  end
  def print_all(:tenants) do
    from Tenant
    |> Repo.all
  end
  def print_all(:requests) do
    "requests"
    |> select([:id, :apt_id])
  end


  def min_rent(rent) do
    from(a in Appartment,
      where: a.rent_month > ^rent,
      select: {a.id, a.building_id, a.rent_month})
    |> Repo.all
  end

  def buildings_complex(c_id) do
    q = from b in Building,
      join: c in Complex, where: b.complex_id == c.id

    q = from [b, c] in q,
      where: c.id == ^c_id,
      select: {b.id, c.name}
    Repo.all q
  end



end
