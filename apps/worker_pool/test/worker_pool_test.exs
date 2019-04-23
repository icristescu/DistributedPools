defmodule WorkerPoolTest do
  use ExUnit.Case
  doctest WorkerPool

  test "greets the world" do
    assert WorkerPool.hello() == :world
  end

  test "get status for pool name" do
    assert WorkerPool.Application.status("pool1") == "status of pool1 is 3 free out of 3"
  end

  test "get status for non existing pool name" do
    assert WorkerPool.Application.status("pool3") == "pool name not available"
  end

  test "checkout and checking" do
    w = WorkerPool.Application.checkout("pool1")
    assert w == :pool1worker1

    assert :ok == WorkerPool.Application.checkin("pool1", w)
  end

  test "checkout too many" do
    assert :pool1worker1 == WorkerPool.Application.checkout("pool1")
    assert :pool1worker2 == WorkerPool.Application.checkout("pool1")
    assert :pool1worker3 == WorkerPool.Application.checkout("pool1")
    assert WorkerPool.Application.checkout("pool1") == "no worker available"
  end


end
