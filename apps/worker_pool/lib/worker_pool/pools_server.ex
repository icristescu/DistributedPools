defmodule WorkerPool.PoolsServer do
  use GenServer


  def start_link(pools) do
    GenServer.start_link(__MODULE__, pools, name: __MODULE__)
  end

  def checkout(pool_name) do
    worker =
      name(pool_name)
      |> GenServer.call(:checkout)

    if worker = nil do "no worker available"
    else "checkout #{worker}"
    end

  end

  def checkin(_pool_name,_worker_pid) do
    IO.puts "not implemented yet"
  end

  def status(pool_name) do
    {size, free} =
      name(pool_name)
      |> GenServer.call(:status)
    "status of #{pool_name} is #{free} free workers out of #{size}"
  end

  def init(_pools) do
    IO.puts "PoolsServer started..."
    {:ok, %{}}
  end

  defp name(pool_name) do
    pool_name
    |> String.to_atom
  end

end
