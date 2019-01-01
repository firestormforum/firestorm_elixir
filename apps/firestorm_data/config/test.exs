use Mix.Config

config :firestorm_data, FirestormData.Repo,
  database: "firestorm_data_repo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 30_000

# Print only warnings and errors during test
config :logger, level: :warn

config :bcrypt_elixir, log_rounds: 4
