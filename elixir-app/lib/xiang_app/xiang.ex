defmodule XiangApp.Xiang do
  @moduledoc """
    Repo for our XiangApp. Minimal data structure for a xiang item.
  """
  use Ecto.Schema
  alias XiangApp.Repo
  alias __MODULE__
  import Ecto.Changeset
  import Ecto.Query, only: [order_by: 2]

  schema "xiangs" do
    field(:text, :string)
    field(:status, :string)
  end

  @topic "xiangs"
  def toggle_xiang(id) do
    xiang = Repo.get(__MODULE__, id)

    status =
      case xiang.status do
        "xiang" -> "done"
        "done" -> "xiang"
      end

    change(xiang, %{status: status})
    |> Repo.update()

    Phoenix.PubSub.broadcast(XiangApp.PubSub, @topic, :changed)
  end

  def drop_xiang(id) do
    Repo.get(__MODULE__, id)
    |> Repo.delete()

    Phoenix.PubSub.broadcast(XiangApp.PubSub, @topic, :changed)
  end

  def add_xiang(text, status) do
    %Xiang{text: text, status: status}
    |> Repo.insert()

    Phoenix.PubSub.broadcast(XiangApp.PubSub, @topic, :changed)
  end

  def all_xiangs() do
    order_by(__MODULE__, asc: :id)
    |> Repo.all()
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(XiangApp.PubSub, @topic)
  end
end
