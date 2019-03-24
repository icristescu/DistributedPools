defmodule RentingWeb.Router do
  use RentingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RentingWeb.Auth, repo: Renting.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RentingWeb do
    pipe_through :browser

    resources "/users", UserController
    resources "/requests", RequestController
    resources "/apparts", AppartController, only: [:index]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    get "/", PageController, :index

  end

  # Other scopes may use custom stacks.
  # scope "/api", RentingWeb do
  #   pipe_through :api
  # end
end
