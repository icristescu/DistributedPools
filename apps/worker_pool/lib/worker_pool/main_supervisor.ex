defmodule WorkerPool.MainSupervisor do
  use Supervisor

  def start_link(pools) do
    Supervisor.start_link(__MODULE__, pools, name: __MODULE__)
  end


  ### callbacks ###

  def init(pools) do
    IO.puts "MainSupervisor started..."

    children = [
      {WorkerPool.PoolsServer, pools},
      {WorkerPool.PoolsSupervisor, pools},
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end


end
