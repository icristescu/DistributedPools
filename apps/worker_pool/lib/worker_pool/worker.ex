defmodule WorkerPool.Worker do
  use GenServer

  def start_link([name]) do
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
  def handle_cast(msg, state) do
    IO.puts "Worker received unexpected cast message: #{inspect(msg)}"
    {:noreply, state}
  end

  def handle_info({:EXIT, pid, reason}, state) do
    IO.puts "Worker #{pid} died: #{reason}"
    {:noreply, state}
  end
  def handle_info(msg, state) do
    IO.puts "Worker received unexpected info message: #{inspect(msg)}"
    {:noreply, state}
  end



end
