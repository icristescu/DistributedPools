defmodule WorkerPool.PoolServer do
  use GenServer

  defmodule State do
    defstruct size: 0, free_workers: nil, workers_registry: nil
  end

  def start_link(ns) do
    pool_name =
      ns[:name]
      |> String.to_atom

    GenServer.start_link(__MODULE__, ns, name: pool_name)
  end

  def init(ns) do
    IO.puts "PoolServer #{ns[:name]} started..."

    #:ets.new(:workers_registry, [:named_table])
    # does not work, because there are more than one pool servers
    table = :ets.new(:workers_registry, [:set, :protected])

    {:ok, %State{size: ns[:size], free_workers: workers(ns),
		 workers_registry: table}}
  end

  def handle_call(:status, _from,
    state = %{size: size, free_workers: free_workers}) do
    {:reply, {size, Enum.count(free_workers)}, state}
  end

  def handle_call(:checkout, {pid, _tag},
    state = %{free_workers: [next | rest], workers_registry: reg}) do

    IO.inspect pid, label: "checkout from = "

    :ets.insert(reg, {pid, next})
    {:reply, next, %{state | free_workers: rest}}
  end

  def handle_call(:checkout, {pid, _tag},
    state = %{free_workers: []}) do
    IO.inspect pid, label: "checkout from = "

    {:reply, nil, state}
  end

  def handle_call(:checkin, {pid, _tag},
    state = %{free_workers: workers, workers_registry: reg}) do
    IO.inspect pid, label: "checkout from = "

    {_pid, worker} = :ets.lookup(reg, pid)
    {:reply, nil, %{state | free_workers: [worker | workers]}}
  end


  defp workers(ns) do
    1..ns[:size]
    |> Enum.map(fn i ->
      String.to_atom(ns[:name] <> "worker" <> Integer.to_string(i)) end)
  end

end
