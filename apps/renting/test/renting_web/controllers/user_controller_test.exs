defmodule RentingWeb.UserControllerTest do
  use RentingWeb.ConnCase


  alias Renting.Accounts

  @create_attrs %{name: "some name", password: "some_pass", username: "some username"}
  @update_attrs %{name: "some updated name", password: "updated", username: "updated username"}
  @invalid_attrs %{name: nil, password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    setup [:log_user_in]

    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_path(conn, :show, id)

      conn = get(conn, Routes.user_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end


  @tag :not_implemented
  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.user_path(conn, :show, user)

      conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  @tag :not_implemented
  describe "delete user" do
    setup [:create_user, :log_user_in]

    test "deletes chosen user", %{conn: conn, user: user, current_user: current_user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.user_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user.id))
      end
    end
  end

  test "requires user authentication on index and show", %{conn: conn} do
    Enum.each([
      get(conn, Routes.user_path(conn, :index)),
      get(conn, Routes.user_path(conn, :show, "1")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp log_user_in(_) do
    user = fixture(:user)
    conn = assign(build_conn(), :current_user, user)
    {:ok, conn: conn, current_user: user}
  end

end
