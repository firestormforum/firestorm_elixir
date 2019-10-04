defmodule FirestormData.MixProject do
  use Mix.Project

  def project do
    [
      app: :firestorm_data,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      dialyzer: [plt_add_deps: :transitive],
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FirestormData.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, "~> 0.14"},
      # We use bcrypt to hash passwords
      {:bcrypt_elixir, "~> 1.1.1"},
      # We interact with bcrypt via comeonin
      {:comeonin, "~> 4.0"},
      # We want to paginate queries
      {:scrivener_ecto, "~> 2.0"},
      # EctoAutoslugField
      {:ecto_autoslug_field, "~> 2.0"},
      # We'd like as much type safety as we can get
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false}
    ]
  end
end
