defmodule RentingWeb.AppartController do

  use RentingWeb, :controller

  alias Renting.Repo
  alias Renting.Appart

  def index(conn, _params) do
    apparts = Repo.all(Appart)
    render(conn, "index.html", apparts: apparts)
  end


end
