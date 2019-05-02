defmodule WorkerPool.MainSupervisor do
  use Supervisor

  def start_link(pools) do
    Supervisor.start_link(__MODULE__, pools, name: __MODULE__)
  end

  def init({pools, distributed}) do
    IO.puts "MainSupervisor started..."

    pools_supervisor = if distributed do WorkerPool.DistriPools
    else WorkerPool.PoolsSupervisor
    end

    children = [
      {WorkerPool.PoolsServer, pools},
      {pools_supervisor, pools},
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  def start_pools() do
    GenServer.call(:pools_supervisor, :start_pools)
  end

end
