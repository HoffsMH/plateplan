use Mix.Config

port = String.to_integer(System.get_env("PORT") || "4000")
default_secret_key_base = :crypto.strong_rand_bytes(43) |> Base.encode64

config :plateplan, PlateplanWeb.Endpoint,
  http: [port: port],
  url: [host: System.get_env("PHX_HOST") || "localhost", port: port],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || default_secret_key_base
