import Config

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.49.11",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger,
  handle_otp_reports: true,
  handle_sasl_reports: false,
  backends: [:console]

config :logger, :console,
  level: :notice,
  format: "$time $metadata[$level] $levelpad$message\n",
  metadata: [:request_id]

# Configures the endpoint
config :xiang_app, XiangWeb.Endpoint,
  # because of the iOS rebind - this is now a fixed port, but randomly selected
  http: [ip: {127, 0, 0, 1}, port: 10_000 + :rand.uniform(45_000)],
  render_errors: [view: XiangWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: XiangApp.PubSub,
  live_view: [signing_salt: "sWpG9ljX"],
  secret_key_base: :crypto.strong_rand_bytes(32),
  server: true

config :phoenix, :json_library, Jason

config :xiang_app,
  ecto_repos: [XiangApp.Repo]

# We're defining this at runtime
# config :xiang_app, XiangApp.Repo, database: "~/.config/xiang/database.sq3"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
