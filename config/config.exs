# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :lohi_ui, LohiUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6OwWB9eToPRsuRnviepHudRwtc6z4AZ89iqTqiISMQQWtf0hLQxJOpgZMCGTMkka",
  render_errors: [view: LohiUiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LohiUi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :paracusia,
  hostname: "127.0.0.1",
  port: 6697,
  # if connecting to MPD failed, try again after x milliseconds
  retry_after: 2000,
  # Give up if no connection could be established after x attempts.
  max_retry_attempts: 20

config :lohi_ui,
  music_directory: "/Users/ole/.mpd/music",
  playlist_directory: "/Users/ole/.mpd/playlists",
  max_volume: 100

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
