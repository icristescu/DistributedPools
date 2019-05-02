defmodule WorkerPool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @pools [
    %{name: "pool1", size: 3},
    %{name: "pool2", size: 2},
  ]
  @distributed true

  def start(_type, _args) do
    children = [
      {WorkerPool.MainSupervisor, {@pools, @distributed}}
    ]
    opts = [strategy: :one_for_one, name: WorkerPool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_pools do
    if @distributed do
      WorkerPool.MainSupervisor.start_pools
    end
  end

  def checkout(pool_name) do
    WorkerPool.PoolsServer.checkout(pool_name)
  end

  def checkin(pool_name,worker_pid) do
    WorkerPool.PoolsServer.checkin(pool_name,worker_pid)
  end

  def status(pool_name) do
    if pool_name in Enum.map(@pools, fn ns -> ns[:name] end) do
      WorkerPool.PoolsServer.status(pool_name)
    else "pool name not available"
    end
  end

end
