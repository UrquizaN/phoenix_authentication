# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir_auth,
  ecto_repos: [ElixirAuth.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :elixir_auth, ElixirAuthWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: ElixirAuthWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ElixirAuth.PubSub,
  live_view: [signing_salt: "Z1Qd8QlH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :elixir_auth, ElixirAuthWeb.Auth.Guardian,
  issuer: "elixir_auth",
  secret_key: "4T2qq/IL1H4sHGCjOvzMX6S5v/MWXW09Eq6nFWQTqvMiKEcPdBlHNN3GYG45ME/R"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
  repo: ElixirAuth.Repo,
  schema_name: "account_tokens",
  sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
