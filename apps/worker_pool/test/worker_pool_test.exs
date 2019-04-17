defmodule WorkerPoolTest do
  use ExUnit.Case
  doctest WorkerPool

  test "greets the world" do
    assert WorkerPool.hello() == :world
  end

  test "get status for pool name" do
    assert WorkerPool.Application.status("pool1") == "status of pool1 is 3"
  end

  test "get status for non existing pool name" do
    assert WorkerPool.Application.status("pool3") == "pool name not available"
  end
end
