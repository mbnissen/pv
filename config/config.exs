# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pv,
  ecto_repos: [Pv.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :pv, PvWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GtUEBsU3y9BkHV4TiJMY6jDkExxCuWa448GYp2eICKctYteDAM8hfLF7j6B3ZVyN",
  render_errors: [view: PvWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pv.PubSub,
  live_view: [signing_salt: "vTaldm31"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
