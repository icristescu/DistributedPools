defmodule WorkerPool.PoolsServer do
  use GenServer


  def start_link(pools) do
    GenServer.start_link(__MODULE__, pools)
  end

  def checkout(_pool_name) do
    IO.puts "not implemented yet"
  end

  def checkin(_pool_name,_worker_pid) do
    IO.puts "not implemented yet"
  end

  def status(pool_name) do
    size =
      pool_name
      |> String.to_atom
      |> GenServer.call(:status)
    "status of #{pool_name} is #{size}"
  end

  def init(_pools) do
    IO.puts "PoolsServer started..."
    {:ok, %{}}
  end


end
