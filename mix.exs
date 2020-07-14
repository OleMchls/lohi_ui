defmodule LohiUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :lohi_ui,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LohiUi.Application, []},
      extra_applications: [:logger, :runtime_tools],
      included_applications: [:paracusia, :tftp]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:cowboy, "~> 2.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:libcluster, "~> 3.2"},
      {:paracusia, "~> 0.2.4"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix, "~> 1.5"},
      {:plug_cowboy, "~> 2.1"},
      {:uuid, "~> 1.1"}
    ]
  end
end
