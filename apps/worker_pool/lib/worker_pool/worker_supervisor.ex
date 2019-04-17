defmodule WorkerPool.WorkerSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end


  ### callbacks ###

  def init(_init_arg) do
    children = [
      # {WorkerPool.Worker, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end


end
