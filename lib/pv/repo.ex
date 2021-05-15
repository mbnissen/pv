defmodule Pv.Repo do
  use Ecto.Repo,
    otp_app: :pv,
    adapter: Ecto.Adapters.Postgres
end
