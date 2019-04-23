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

    table = new()
    {:ok, %State{size: ns[:size], free_workers: workers(ns),
		 workers_registry: table}}
  end

  def handle_call(:status, _from,
    state = %{size: size, free_workers: free_workers}) do
    {:reply, {size, Enum.count(free_workers)}, state}
  end

  def handle_call(:checkout, {pid, _tag},
    state = %{free_workers: [next | rest], workers_registry: reg}) do

    IO.inspect pid, label: "checkout from "

    ref = Process.monitor(pid)
    insert(reg, {next,ref})
    {:reply, next, %{state | free_workers: rest}}
  end

  def handle_call(:checkout, {pid, _tag},
    state = %{free_workers: []}) do
    IO.inspect pid, label: "checkout from "

    {:reply, nil, state}
  end

  def handle_call({:checkin, worker}, {pid, _tag},
    state = %{free_workers: workers, workers_registry: reg}) do
    IO.inspect pid, label: "checkin from "
    IO.inspect worker, label: "worker "

    {:ok, ref} = lookup_and_delete(reg, worker)
    Process.demonitor(ref)

    {:reply, :ok, %{state | free_workers: [worker | workers]}}
  end

  # if a consumer dies, the associated worker is freed
  def handle_info({:DOWN, ref, :process, _object, _reason},
    state = %{free_workers: workers, workers_registry: reg}) do
    {:ok, worker} = match_and_delete(reg, ref)

    {:noreply, %{state | free_workers: [worker | workers]}}
  end


  defp workers(ns) do
    1..ns[:size]
    |> Enum.map(fn i ->
      String.to_atom(ns[:name] <> "worker" <> Integer.to_string(i)) end)
  end

  defp new do
    #:ets.new(:workers_registry, [:named_table])
    # does not work, because there are more than one pool servers
    :ets.new(:workers_registry, [:set, :protected])
  end

  defp insert(table, {key, val}) do
    :ets.insert(table, {key, val})
  end

  defp lookup_and_delete(table, key) do
    case :ets.lookup(table, key) do
      [{^key, val}] ->
	:ets.delete(table, key)
	{:ok, val}
      [] -> :error
    end
  end

  defp match_and_delete(table, val) do
    case :ets.match(table, {'$1', val}) do
      [{key}] ->
	:ets.delete(table, key)
	{:ok, key}
      [] -> :error
    end
  end

end
