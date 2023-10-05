defmodule XiangApp.MenuBar do
  @moduledoc """
    Menubar that is shown as part of the main Window on Windows/Linux. In
    MacOS this Menubar appears at the very top of the screen.
  """
  import XiangWeb.Gettext
  use Desktop.Menu
  alias XiangApp.Xiang
  alias Desktop.Window

  def render(assigns) do
    ~H"""
    <menubar>
    <menu label={gettext "File"}>
        <%= for item <- @xiangs do %>
        <item
            type="checkbox" onclick={"toggle:#{item.id}"}
            checked={item.status == "done"}
            ><%= item.text %></item>
        <% end %>
        <hr/>
        <item onclick="quit"><%= gettext "Quit" %></item>
    </menu>
    <menu label={gettext "Extra"}>
        <item onclick="notification"><%= gettext "Show Notification" %></item>
        <item onclick="observer"><%= gettext "Show Observer" %></item>
        <item onclick="browser"><%= gettext "Open Browser" %></item>
    </menu>
    </menubar>
    """
  end

  def handle_event(<<"toggle:", id::binary>>, menu) do
    Xiang.toggle_xiang(String.to_integer(id))
    {:noreply, menu}
  end

  def handle_event("observer", menu) do
    :observer.start()
    {:noreply, menu}
  end

  def handle_event("quit", menu) do
    Window.quit()
    {:noreply, menu}
  end

  def handle_event("browser", menu) do
    Window.prepare_url(XiangWeb.Endpoint.url())
    |> :wx_misc.launchDefaultBrowser()

    {:noreply, menu}
  end

  def handle_event("notification", menu) do
    Window.show_notification(XiangWindow, gettext("Sample Elixir Desktop App!"),
      callback: &XiangWeb.XiangLive.notification_event/1
    )

    {:noreply, menu}
  end

  def mount(menu) do
    XiangApp.Xiang.subscribe()
    {:ok, assign(menu, xiangs: Xiang.all_xiangs())}
  end

  def handle_info(:changed, menu) do
    {:noreply, assign(menu, xiangs: Xiang.all_xiangs())}
  end
end
