defmodule XiangWeb.Sup do
  use Supervisor

  @moduledoc """
    Supervisor for the WebApp
  """

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      {Phoenix.PubSub, name: XiangApp.PubSub},
      XiangWeb.Endpoint
    ]

    :session = :ets.new(:session, [:named_table, :public, read_concurrency: true])
    Supervisor.init(children, strategy: :one_for_one, max_restarts: 1000)
  end
end
