defmodule Metricx do
  @moduledoc false

  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Metricx.Counter, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
