defmodule WorkerPool.WorkerSupervisor do

  use DynamicSupervisor
  # use a dynamic supervisor because we need to control the death
  # and rebirth of workers

  def start_link(name) do
    DynamicSupervisor.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    IO.puts "WorkerSupervisor #{Atom.to_string(name)} started..."
    DynamicSupervisor.init(strategy: :one_for_one, restart: :temporary)
  end

end
