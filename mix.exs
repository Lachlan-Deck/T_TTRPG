defmodule TTtrpg.MixProject do
  use Mix.Project

  def project do
    [
      app: :t_ttrpg,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TTtrpg, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
    defp deps do
    [
      {:absinthe, "~>1.12"},
      {:absinthe_plug, "~>1.5"},
      {:jason, "~>1.4.5"},
      {:bandit, "~>1.12"},
      {:plug_cowboy, "~>2.9.0"},
    ]

  end
end
