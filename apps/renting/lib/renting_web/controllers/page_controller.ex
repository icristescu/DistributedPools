defmodule RentingWeb.PageController do
  use RentingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
