defmodule XiangWeb.XiangLive do
  @moduledoc """
    Main live view of our XiangApp. Just allows adding, removing and checking off
    xiang items
  """
  use XiangWeb, :live_view

  @impl true

  def mount(_args, _session, socket) do

    {
      :ok, 
      assign(socket, 
      xiang_is_running: false,
      length_xiang: 400
      )}
  end

  def handle_info(:update_xiang, socket) do
    # TODO: control by the selected time.
    length_xiang = socket.assigns.length_xiang - 10
    if length_xiang >= 0 and (socket.assigns.xiang_is_running == true)do
      Process.send_after(self(), :update_xiang, 1000)
      send(self(), :update_xiang_graph)
      {
        :noreply, 
        assign(socket,
        length_xiang: length_xiang
        )
      }
    else
      {
        :noreply, 
        assign(socket,
          xiang_is_running: false
        )
      }
    end

  end

  def handle_info(:update_xiang_graph, socket) do
    length_xiang = socket.assigns.length_xiang
    {:noreply, push_event(socket, "update-xiang-graph", %{length_xiang: length_xiang})}
  end

  def handle_info(:reset_xiang_graph, socket) do
    length_xiang = socket.assigns.length_xiang
    {:noreply, push_event(socket, "reset-xiang-graph", %{})}
  end

  @impl true
  def handle_event("submit", _, socket) do
    {:noreply, socket}      
  end

  @impl true
  def handle_event("dian_xiang", _params, socket) do
    if socket.assigns.xiang_is_running == false do
      send(self(), :update_xiang)
      {
        :noreply, 
        assign(socket, 
          xiang_is_running: true
        )
      }
    else
      {:noreply, socket}      
    end
  end

  @impl true
  def handle_event("reset", _params, socket) do
    send(self(), :reset_xiang_graph)
    {
      :noreply, 
      assign(socket, 
      xiang_is_running: false,
      length_xiang: 400
    )}
  end

  def notification_event(action) do
    Desktop.Window.show_notification(XiangWindow, "You did '#{inspect(action)}' me!",
      id: :click,
      type: :warning
    )
  end
end
