defmodule Metricx.Mixfile do
  use Mix.Project

  def project do
    [app: :metricx,
     version: "0.1.0",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [ 
      mod: {Metricx, []},
      applications: [
        :logger
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:earmark, "~> 1.0", only: :docs},
      {:ex_doc, "~> 0.14", only: :docs},
      {:inch_ex, "~> 0.5", only: :docs},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:exactor, "~> 2.2"}
    ]
  end
end
