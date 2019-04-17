defmodule WorkerPool.Worker do
  use GenServer

  def start_link(_default) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, %{}}
  end
end
