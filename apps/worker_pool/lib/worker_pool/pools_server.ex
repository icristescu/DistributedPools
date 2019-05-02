defmodule WorkerPool.PoolsServer do
  use GenServer


  def start_link(pools) do
    GenServer.start_link(__MODULE__, pools, name: __MODULE__)
  end

  def checkout(pool_name) do
    worker =
      name(pool_name)
      |> GenServer.call(:checkout) #calls PoolServer


    if worker == nil do "no worker available"
    else
      IO.puts "checkout #{Atom.to_string(worker)}"
      worker
    end

  end

  def checkin(pool_name, worker_pid) do
    name(pool_name)
    |> GenServer.call({:checkin, worker_pid})
  end

  def status(pool_name) do
    {size, free} =
      name(pool_name)
      |> GenServer.call(:status) #calls PoolServer
    "status of #{pool_name} is #{free} free out of #{size}"
  end

  def init(_pools) do
    IO.puts "PoolsServer started..."
    {:ok, %{}}
  end

  defp name(pool_name) do
    name = pool_name
    |> String.to_atom
    {:global, name}
  end

end
