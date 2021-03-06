defmodule LohiUiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :lohi_ui

  use Plug.Debugger

  socket "/socket", LohiUiWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static, at: "/", from: :lohi_ui, gzip: false, only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [
      :urlencoded,
      {:multipart, read_timeout: 15_000 * 4},
      :json
    ],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library(),
    # 250 MB
    length: 262_144_000

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_lohi_ui_key",
    signing_salt: "yP9TlOpO"

  plug LohiUiWeb.Router
end
