defmodule WorkerPool.PoolSupervisor do
  use Supervisor

  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns)
  end

  def init(ns) do
    IO.puts "PoolSupervisor started..."

    worker_sup = supervisor_name(ns[:name])

    children = [
      {WorkerPool.WorkerSupervisor, worker_sup},
      {WorkerPool.PoolServer, {ns, worker_sup}}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

   defp supervisor_name(name) do
    String.to_atom(name <> "_worker_supervisor")
  end

end
