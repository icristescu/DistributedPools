defmodule RentsDb do
  alias RentsDb.{Appartment, Complex, Repo}


  @moduledoc """
  Documentation for RentsDb.
  """

  @doc """
  Hello world.

  ## Examples

      iex> RentsDb.hello()
      :world

  """
  def hello do
    :world
  end

  def create(:complex,params) do
    Complex.changeset(%Complex{}, params)
    |> insert
  end
  def create(:appartement,params) do
    Appartment.changeset(%Appartment{}, params)
    |> insert
  end


  defp insert(cs) do
    if cs.valid? do
      Repo.insert(cs)
    else cs
    end
  end

end
