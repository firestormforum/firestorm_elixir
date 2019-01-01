# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :firestorm_data,
  ecto_repos: [FirestormData.Repo]

config :firestorm_data, FirestormData.Repo, migration_timestamps: [type: :naive_datetime_usec]

import_config "#{Mix.env()}.exs"
