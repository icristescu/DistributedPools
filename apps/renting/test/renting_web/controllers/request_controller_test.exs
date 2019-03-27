defmodule RentingWeb.RequestControllerTest do
  use RentingWeb.ConnCase

  alias Renting.Req

  @create_attrs %{cost: 42, nbdays: 42, period: "some period", status: "some status"}
  @update_attrs %{cost: 43, nbdays: 43, period: "some updated period", status: "some updated status"}
  @invalid_attrs %{cost: nil, nbdays: nil, period: nil, status: nil}

  def fixture(user, :request) do
    {:ok, request} = Req.create_request(user, @create_attrs)
    request
  end

  describe "index" do
    setup [:log_user_in]

    test "lists all requests", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Requests"
    end
  end

  describe "new request" do
    setup [:log_user_in]

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.request_path(conn, :new))
      assert html_response(conn, 200) =~ "New Request"
    end
  end

  describe "create request" do
    setup [:log_user_in]

    test "redirects to show when data is valid", %{conn: conn, current_user: user} do
      conn = post(conn, Routes.request_path(conn, :create), request: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.request_path(conn, :show, id)

      conn = ensure_log_in(user)
      conn = get(conn, Routes.request_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Request"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.request_path(conn, :create), request: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Request"
    end
  end

  describe "edit request" do
    setup [:log_user_in]

    test "renders form for editing chosen request", %{conn: conn, current_user: user} do
      request = create_request(user)

      conn = get(conn, Routes.request_path(conn, :edit, request))
      assert html_response(conn, 200) =~ "Edit Request"
    end
  end

  describe "update request" do
    setup [:log_user_in]

    test "redirects when data is valid", %{conn: conn, current_user: user} do
      request = create_request(user)

      conn = put(conn, Routes.request_path(conn, :update, request), request: @update_attrs)
      assert redirected_to(conn) == Routes.request_path(conn, :show, request)

      conn = ensure_log_in(user)
      conn = get(conn, Routes.request_path(conn, :show, request))
      assert html_response(conn, 200) =~ "some updated period"
    end

    test "renders errors when data is invalid", %{conn: conn, current_user: user} do
      request = create_request(user)

      conn = put(conn, Routes.request_path(conn, :update, request), request: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Request"
    end
  end

  describe "delete request" do
    setup [:log_user_in]

    test "deletes chosen request", %{conn: conn, current_user: user} do
      request = create_request(user)

      conn = delete(conn, Routes.request_path(conn, :delete, request))
      assert redirected_to(conn) == Routes.request_path(conn, :index)

      conn = ensure_log_in(user)
      assert_error_sent 404, fn ->
        get(conn, Routes.request_path(conn, :show, request))
      end
    end
  end

  defp create_request(user) do
    request = fixture(user, :request)
    request
  end

  defp log_user_in(_) do
    {:ok, user} = insert_user(%{username: "ana"})
    conn = assign(build_conn(), :current_user, user)
    {:ok, conn: conn, current_user: user}
  end

  defp ensure_log_in(user) do #conn is not recycled in tests
    assign(build_conn(), :current_user, user)
  end

end
