defmodule RentingWeb.Auth do

  import Plug.Conn
  import Bcrypt

  use RentingWeb, :controller

  alias Renting.Accounts
#  alias Renting.Repo

  def init(default), do: default

  def call(conn, _default) do
    user_id = get_session(conn, :user_id)

    cond do
      _user = conn.assigns[:current_user] ->
	conn
      user = user_id && Accounts.get_user!(user_id) ->
	assign(conn, :current_user, user)
      true ->
	assign(conn, :current_user, nil)
    end
  end

  #function plugs

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_username_and_pass(conn, username, given_pass, _opts) do
    user = Accounts.get_user_by(username)

    cond do
      user && verify_pass(given_pass, user.password_hash) ->
	{:ok, login(conn, user)}
      user ->
	{:error, :unauthorized, conn}
      true ->
	no_user_verify()
	{:error, :not_found, conn}
    end
  end

  def logout(conn) do
    #conn = configure_session(conn, drop: true)
    #IO.inspect get_session(conn, :user_id), label: "logout = "
    clear_session(conn)
  end

end
