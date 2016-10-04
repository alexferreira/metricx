defmodule Metricx.CounterTest do
  use ExUnit.Case
  doctest Metricx.Counter

  alias Metricx.Counter

  setup do
    on_exit fn ->
      Counter.clear
    end
  end

  test "Counter.all returns an empty map if there are no counters" do
    assert Counter.all == %{}
  end

  test "Counter.all returns a map with all counters" do
    assert Counter.increment("errors") == :ok
    assert Counter.increment("success") == :ok
    assert Counter.increment("success") == :ok
    assert Counter.all == %{"errors" => 1, "success" => 2}
  end

  test "Counter.empty? returns true if counters is clean" do
    assert Counter.empty?
    assert Counter.increment("errors") == :ok
    refute Counter.empty?
  end

  test "Counter.clear(key) returns :ok and clears the specified counter" do
    assert Counter.increment("errors") == :ok
    assert Counter.increment("success") == :ok
    assert Counter.all |> Map.keys == ["errors", "success"]
    assert Counter.clear("errors") == :ok
    assert Counter.all |> Map.keys == ["success"]
  end

  test "Counter.increment(key) increments the counter by 1" do
    key = "error_500"

    assert Counter.increment(key) == :ok
    assert Counter.get(key) == 1
    assert Counter.increment(key) == :ok
    assert Counter.get(key) == 2
  end

  test "Counter.increment(key, num) increments the counter by num" do
    key = "error_500"
    num = 3

    assert Counter.increment(key, num) == :ok
    assert Counter.get(key) == num
  end

  test "Counter.decrement(key) decrements the counter by 1" do
    key = "error_500"

    assert Counter.decrement(key) == :ok
    assert Counter.get(key) == -1
  end

  test "Counter.decrement(key, num) decrements the counter by num" do
    key = "error_500"
    num = 2

    assert Counter.decrement(key, num) == :ok
    assert Counter.get(key) == -num
  end

  test "Counter.get(key) returns nil if key is not found" do
    assert Counter.get("non-existent") == nil
  end

  test "Counter.get(key) returns the stored value in the counter" do
    key = "error_500"

    assert Counter.set(key, 10) == :ok
    assert Counter.get(key) == 10
  end

  test "Counter.set(key, value) sets the counter to the value" do
    assert Counter.set("errors", 13) == :ok
    assert Counter.set("success", 7) == :ok
    assert Counter.get("errors") == 13
    assert Counter.get("success") == 7
  end
end
