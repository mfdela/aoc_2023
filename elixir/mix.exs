defmodule Aoc2023.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc2023,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:libgraph, "~> 0.16.0"},
      {:qex, "~> 0.5"},
      {:nx, "~> 0.5"},
      {:matrix_operation, "~> 0.5.0"}
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
