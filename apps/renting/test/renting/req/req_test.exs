defmodule Renting.ReqTest do
  use Renting.DataCase

  alias Renting.Req

  describe "requests" do
    alias Renting.Req.Request

    @valid_attrs %{cost: 42, nbdays: 42, period: "some period", status: "some status"}
    @update_attrs %{cost: 43, nbdays: 43, period: "some updated period", status: "some updated status"}
    @invalid_attrs %{cost: nil, nbdays: nil, period: nil, status: nil}

    def request_fixture(attrs \\ %{}) do
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Req.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Req.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Req.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      assert {:ok, %Request{} = request} = Req.create_request(@valid_attrs)
      assert request.cost == 42
      assert request.nbdays == 42
      assert request.period == "some period"
      assert request.status == "some status"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Req.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, %Request{} = request} = Req.update_request(request, @update_attrs)
      assert request.cost == 43
      assert request.nbdays == 43
      assert request.period == "some updated period"
      assert request.status == "some updated status"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Req.update_request(request, @invalid_attrs)
      assert request == Req.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Req.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Req.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Req.change_request(request)
    end
  end
end
