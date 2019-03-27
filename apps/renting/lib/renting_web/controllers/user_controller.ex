defmodule RentingWeb.UserController do
  use RentingWeb, :controller

  import RentingWeb.Auth, only: [authenticate: 2, login: 2]

  alias Renting.Accounts
  alias Renting.Accounts.User

  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> login(user)
	|> put_flash(:info, "User #{user.name} created successfully.")
	|> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    # if (is_binary(id)) do
    #   {id, _} = Integer.parse(id)
    #   user = Accounts.get_user!(id)
    #   render(conn, "show.html", user: user)
    # else
      user = Accounts.get_user!(id)
      render(conn, "show.html", user: user)
    #end
  end

  def edit(conn, %{"id" => id}) do
    # IO.puts "can you see this?"
    # id = Integer.parse(id)
    # IO.inspect id, label: "id in get user"
    user = Accounts.get_user!(id)
    #IO.puts "can you see this? x2"
    changeset = Accounts.change_user(user)
    #IO.puts "can you see this? x3"
    #render(conn, "show.html", user: user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
