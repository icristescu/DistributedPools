defmodule Renting.TestHelpers do

  alias Renting.Accounts

  def insert_user(attrs\\ %{}) do
    changes = Map.merge(
      %{name: "name",
	username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
	password: "secretpass"}, attrs)
    Accounts.create_user(changes)
  end

end
