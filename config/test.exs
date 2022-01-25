import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plateplan, PlateplanWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "sVfbwGS7fY6nZrC4pPtP4KYlcOtuGLjM6fxz36HCcu5Djr9K278rn0SkIh5BuXHf",
  server: false

# In test we don't send emails.
config :plateplan, Plateplan.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
