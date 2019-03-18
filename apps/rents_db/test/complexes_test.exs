defmodule RentsDb.ComplexesTest do
  use ExUnit.Case

  alias RentsDb.Queries

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RentsDb.Repo)
  end

  test "adding and retrieving complexes" do
    assert [%{name: "ComplexA"}] == Queries.print_all(:complex)

    Queries.create(:complex, %{name: "ComplexB"})
    Queries.create(:complex, %{name: "ComplexC"})

    assert [%{name: "ComplexA"}, %{name: "ComplexB"}, %{name: "ComplexC"}] == Queries.print_all(:complex)
  end

  test "create appartament in wrong building" do
    {:error, cs} = Queries.create(:appartement, %{unit_number: "appA", building_id: 32})
    assert cs.errors == [building_id: {"Select a valid building",
      [constraint: :foreign, constraint_name: "appartments_building_id_fkey"]}]
  end
end
