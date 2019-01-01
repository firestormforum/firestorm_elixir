use Mix.Config

config :firestorm_data, FirestormData.Repo,
  hostname: "localhost",
  username: "${DB_USER}",
  password: "${DB_PASSWORD}",
  database: "${DB_NAME}",
  pool_size: 10
