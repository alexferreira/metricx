defmodule Metricx.Counter do
  use ExActor.GenServer, export: :metricx_counters

  @moduledoc """
  `Metricx.Counter` is a bi-directional counter that represents a single numerical value.
  
  A counter is typically used to count requests served, tasks completed, errors occurred, etc. 
  """

  @doc false
  defstart start_link, do: initial_state(Map.new)

  @doc """
  Retrieves a map with all counters.

  ## Examples

      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.increment("error_500")
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.all
      %{"error_404" => 2, "error_500" => 1}

  Returns `counters` where counters is a map of all the counters currently existing.
  """
  defcall all, state: state, do: reply(Enum.into(state, %{}))

  @doc """
  Retrieves a map with all counters.

  ## Examples

      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.increment("error_500")
      iex> Metricx.Counter.empty?
      false
      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.empty?
      true

  Returns `counters` where counters is a map of all the counters currently existing.
  """
  defcall empty?, state: state, do: reply(Enum.into(state, %{}) |> Enum.empty?)


  @doc """
  Clears all counters.

  ## Examples

      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.increment("error_500")
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.all
      %{"error_404" => 1, "error_500" => 1}
      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.all
      %{}

  Returns `:ok`.
  """
  defcast clear, do: new_state(Map.new)

  @doc """
  Clears the specified counter by key.

  ## Parameters
    * `key`: The name of the counter to clear.

  ## Examples

      iex> Metricx.Counter.clear
      :ok
      iex> Metricx.Counter.increment("error_500")
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.all
      %{"error_404" => 1, "error_500" => 1}
      iex> Metricx.Counter.clear("error_404")
      :ok
      iex> Metricx.Counter.all
      %{"error_500" => 1}

  Returns `:ok`.
  """
  defcast clear(key), state: state, do: new_state(Map.delete(state, key))

  @doc """
  Increments the counter by 1.

  ## Parameters
    * `key`: The name of the counter to increment.

  ## Examples

      iex> Metricx.Counter.get("error_500")
      nil
      iex> Metricx.Counter.increment("error_500")
      :ok
      iex> Metricx.Counter.get("error_500")
      1

  Returns `:ok`.
  """
  defcast increment(key), state: state, do: new_state(Map.update(state, key, 1, fn(count) -> count + 1 end))

  @doc """
  Increments the counter by value.

  ## Parameters
    * `key`: The name of the counter to increment.
    * `amount`: The amount to increment by.

  ## Examples

      iex> Metricx.Counter.increment("error_500", 13)
      :ok
      iex> Metricx.Counter.get("error_500")
      13

  Returns `:ok`.
  """
  defcast increment(key, amount), state: state, do: new_state(Map.update(state, key, amount, fn(count) -> count + amount end))

  @doc """
  Decrements the counter by 1.

  ## Parameters
    * `key`: The name of the counter to decrement.

  ## Examples

      iex> Metricx.Counter.decrement("error_404")
      :ok
      iex> Metricx.Counter.get("error_404")
      -1

  Returns `:ok`.
  """
  defcast decrement(key), state: state, do: new_state(Map.update(state, key, -1, fn(count) -> count + -1 end))

  @doc """
  Decrements the counter by value.

  ## Parameters
    * `key`: The name of the counter to decrement.
    * `amount`: The amount to decrement by.

  ## Examples

      iex> Metricx.Counter.decrement("error_404", 9)
      :ok
      iex> Metricx.Counter.get("error_404")
      -9

  Returns `:ok`.
  """
  defcast decrement(key, amount), state: state, do: new_state(Map.update(state, key, -amount, fn(count) -> count + -amount end))

  @doc """
  Retrieves the current value of the counter.

  ## Parameters
    * `key`: The name of the counter to retrieve.

  ## Examples

      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.increment("error_404")
      :ok
      iex> Metricx.Counter.get("error_404")
      2

  Returns `count` where count is an integer if the counter exists, else `nil`.
  """

  defcall get(key), state: state, do: reply(Map.get(state, key))

  @doc """
  Sets the value of a specified counter.

  ## Parameters
    * `key`: The name of the counter to set the value.
    * `value`: The value to set to the counter.

  ## Examples

      iex> Metricx.Counter.set("error_500", 5)
      :ok
      iex> Metricx.Counter.get("error_500")
      5

  Returns `:ok`.
  """
  defcast set(key, value), state: state, do: new_state(Map.put(state, key, value))
end
