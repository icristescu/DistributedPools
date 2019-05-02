defmodule WorkerPool.PoolServer do
  use GenServer

  defmodule State do
    defstruct size: 0,
      free_workers: nil,
      workers_registry: nil, #ets table of {workers_name, consumer_ref}
      worker_sup: nil,
      workers_name_pid: nil
  end

  def start_link({ns,_} = args) do
    GenServer.start_link(__MODULE__, args,
      name: {:global, String.to_atom(ns[:name])})
  end

  def init({ns, worker_sup}) do
    IO.puts "PoolServer #{ns[:name]} started..."
    Process.flag(:trap_exit, true)

    workers_name = workers_name(ns)
    workers_name_pid = start_workers(worker_sup, workers_name)

    IO.inspect (Process.info(self(), :links)), label: "links "

    {:ok, %State{size: ns[:size], free_workers: workers_name,
		 workers_registry: new(:workers_registry),
		 worker_sup: worker_sup, workers_name_pid: workers_name_pid}}
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

  def handle_call(msg, _from, state) do
    IO.puts "PoolServer received unexpected call message: #{inspect(msg)}"
    {:noreply, state}
  end


  # if a consumer dies, the associated worker is freed
  def handle_info({:DOWN, ref, :process, _object, reason},
    state = %{free_workers: workers, workers_registry: reg}) do
    IO.puts "A consumer died: #{reason}"
    {:ok, worker} = match_and_delete(reg, ref)
    {:noreply, %{state | free_workers: [worker | workers]}}
  end

  #if a worker dies, alert the consumer
  def handle_info({:EXIT, pid, reason},
    state = %{workers_registry: reg, workers_name_pid: pid_name,
	      worker_sup: sup}) do

    IO.puts "Worker #{inspect pid} died: #{reason}"

    {:ok, name} = lookup_and_delete(pid_name, pid)

    case lookup_and_delete(reg, name) do
      {:ok, ref} ->
	Process.demonitor(ref)
	IO.puts "the worker died, please make a new checkout"
      :error -> nil
    end


    {:ok, pid} = start_worker(sup, name)
    insert(pid_name, {pid, name})

    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts "PoolServer received unexpected info message: #{inspect(msg)}"
    {:noreply, state}
  end

  def handle_cast(msg, state) do
    IO.puts "PoolServer received unexpected cast message: #{inspect(msg)}"
    {:noreply, state}
  end


  defp worker_name(name, i) do
    String.to_atom(name <> "worker" <> Integer.to_string(i))
  end

  defp workers_name(ns) do
    nb = 1..ns[:size]
    Enum.map(nb, &(worker_name(ns[:name],&1)))
  end

  defp start_workers(worker_sup, workers) do
    table = new(:workers_name_pid)

    Enum.each(workers, fn name ->
      {:ok, pid} = start_worker(worker_sup, name)
      insert(table, {pid, name})
    end)

    table
  end

  defp start_worker(worker_sup, name) do
    spec = Supervisor.child_spec({WorkerPool.Worker, [name]},
      id: name, restart: :temporary)
    {:ok, pid} = DynamicSupervisor.start_child(worker_sup, spec)
    Process.link(pid)
    {:ok, pid}
  end


  defp new(table) do
    #:ets.new(:workers_registry, [:named_table])
    # does not work, because there are more than one pool servers
    :ets.new(table, [:set, :protected])
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
