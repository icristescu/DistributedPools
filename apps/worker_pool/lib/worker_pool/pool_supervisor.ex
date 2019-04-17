defmodule WorkerPool.PoolSupervisor do
  use Supervisor

  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns)
  end


  ### callbacks ###

  def init(ns) do
    IO.puts "PoolSupervisor started..."

    children = [
      {WorkerPool.PoolServer, ns},
      # {WorkerPool.WorkerSupervisor, []}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end


end
