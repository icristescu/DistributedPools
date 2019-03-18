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
end
