defmodule WorkerPool.PoolServer do
  use GenServer

  # Client

  def start_link(ns) do
    pool_name =
      ns[:name]
      |> String.to_atom

    GenServer.start_link(__MODULE__, ns, name: pool_name)
  end

  def init(ns) do
    IO.puts "PoolServer #{ns[:name]} started..."

    {:ok, %{size: ns[:size]}}
  end

  def handle_call(:status, _from, state = %{size: size}) do
    {:reply, size, state}
  end

end
