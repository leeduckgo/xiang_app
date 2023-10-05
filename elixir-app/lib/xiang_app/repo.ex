defmodule XiangApp.Repo do
  use Ecto.Repo, otp_app: :xiang_app, adapter: Ecto.Adapters.SQLite3

  def initialize() do
    Ecto.Adapters.SQL.query!(__MODULE__, """
        CREATE TABLE IF NOT EXISTS xiangs (
          id INTEGER PRIMARY KEY,
          text TEXT,
          status TEXT
        )
    """)
  end
end
