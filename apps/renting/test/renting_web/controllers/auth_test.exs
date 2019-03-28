defmodule RentingWeb.UserControllerTest do
  use RentingWeb.ConnCase

  alias Renting.Accounts
  alias Renting.Repo
  alias RentingWeb.Auth

  setup %{conn: conn} do
    conn =
      conn
      |> bypass_through(RentingWeb.Router, :browser)
      |> get("/")
    {:ok, %{conn: conn}}
  end

  test "authenticate_user halts when no current_user exists", %{conn: conn} do
    conn =
      conn
      |> Auth.authenticate([])
    assert conn.halted
  end

  test "authenticate_user continues when the current_user exists", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %Accounts.User{})
    |> Auth.authenticate([])
    refute conn.halted
  end

  test "login puts the user in the session", %{conn: conn} do
    login_conn =
      conn
      |> Auth.login(%Accounts.User{id: 1})
      |> send_resp(:ok, "")
    #next_conn = get(logout_conn, "/")
    #does not work, probably session is not recycled
    assert get_session(login_conn, :user_id) == 1
  end

  test "logout drops the session", %{conn: conn} do
    {:ok, user} = insert_user()

    logout_conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.logout()
      |> send_resp(:ok, "")
    #next_conn = get(logout_conn, "/")
    refute get_session(logout_conn, :user_id)
  end

  test "call puts user from session into assigns", %{conn: conn} do
    {:ok, user} = insert_user()
    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "call with no user sets current_user to nil", %{conn: conn} do
    conn = Auth.call(conn, Repo)
    refute conn.assigns.current_user
  end

  test "login_by_username_and_pass with correct credentials", %{conn: conn} do
    {:ok, user} = insert_user(%{username: "ana", password: "secret"})
    {:ok, conn} = Auth.login_by_username_and_pass(conn, "ana", "secret", Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "login_by_username_and_pass with incorrect username", %{conn: conn} do
    _ = insert_user(%{username: "ana", password: "secret"})

    assert {:error, :not_found, _conn} =
      Auth.login_by_username_and_pass(conn, "ana11", "secret", repo: Repo)

  end

    test "login_by_username_and_pass with incorrect password", %{conn: conn} do
    _ = insert_user(%{username: "ana", password: "secret"})

    assert {:error, :unauthorized, _conn} =
      Auth.login_by_username_and_pass(conn, "ana", "secret111", repo: Repo)

  end



end
