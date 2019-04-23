defmodule WorkerPool.Worker do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  # an example of how to use the worker
  def work(pid, duration) do
    GenServer.cast(pid, {:duration, duration})
  end

  def init(name) do
    IO.puts "Worker #{name} started..."

    {:ok, %{}}
  end

  def handle_cast({:duration, duration}, state) do
    :timer.sleep(duration)
    IO.puts "finished work"

    {:noreply, state}
  end


end
