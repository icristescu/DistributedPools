defmodule WorkerPool.WorkerSupervisor do
  use Supervisor

  def start_link(ns) do
    Supervisor.start_link(__MODULE__, ns)
  end


  ### callbacks ###

  def init(ns) do
    IO.puts "WorkerSupervisor started..."

    range = 1..ns[:size]

    children =
      Enum.map(range, fn i ->
	id = String.to_atom(ns[:name] <> "worker" <> Integer.to_string(i))
	IO.inspect id, label: "worker name = "
	Supervisor.child_spec({WorkerPool.Worker, id}, id: id) end)

    Supervisor.init(children, strategy: :one_for_one)
  end


end
