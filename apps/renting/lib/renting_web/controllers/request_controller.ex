defmodule RentingWeb.RequestController do
  use RentingWeb, :controller

  alias Renting.Req
  alias Renting.Req.Request

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    requests = Req.list_requests(user)
    render(conn, "index.html", requests: requests)
  end

  def new(conn, _params, user) do
    changeset = Req.change_request(user, %Request{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"request" => request_params}, user) do
    case Req.create_request(user, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request created successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    request = Req.get_request!(user,id)
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}, user) do
    request = Req.get_request!(user,id)
    changeset = Req.change_request(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}, user) do
    request = Req.get_request!(user,id)

    case Req.update_request(request, request_params) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: Routes.request_path(conn, :show, request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    request = Req.get_request!(user, id)
    {:ok, _request} = Req.delete_request(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: Routes.request_path(conn, :index))
  end

end
