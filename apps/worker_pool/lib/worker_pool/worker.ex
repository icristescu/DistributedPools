defmodule WorkerPool.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    IO.puts "Worker #{name} started..."

    {:ok, %{}}
  end
end
