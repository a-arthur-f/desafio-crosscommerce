import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_challenge, TodoChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Je26Lt/RRv3/FnsUsIIbgPlWRnmPlQbL2LruW9GXDiuj9EEjy6m8I77suxs+mo9F",
  server: false

# In test we don't send emails.
config :todo_challenge, TodoChallenge.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
