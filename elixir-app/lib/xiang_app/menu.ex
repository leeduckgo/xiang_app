defmodule XiangApp.Menu do
  @moduledoc """
    Menu that is shown when a user click on the taskbar icon of the XiangApp
  """
  import XiangWeb.Gettext
  use Desktop.Menu

  def handle_event(command, menu) do
    case command do
      <<"toggle:", id::binary>> -> XiangApp.Xiang.toggle_xiang(String.to_integer(id))
      <<"quit">> -> Desktop.Window.quit()
      <<"edit">> -> Desktop.Window.show(XiangWindow)
    end

    {:noreply, menu}
  end

  def mount(menu) do
    XiangApp.Xiang.subscribe()
    menu = assign(menu, xiangs: XiangApp.Xiang.all_xiangs())
    set_state_icon(menu)
    {:ok, menu}
  end

  def handle_info(:changed, menu) do
    menu = assign(menu, xiangs: XiangApp.Xiang.all_xiangs())

    set_state_icon(menu)

    {:noreply, menu}
  end

  defp set_state_icon(menu) do
    if checked?(menu.assigns.xiangs) do
      Menu.set_icon(menu, {:file, "icon32x32-done.png"})
    else
      Menu.set_icon(menu, {:file, "icon32x32.png"})
    end
  end

  defp checked?([]) do
    true
  end

  defp checked?([%{status: "done"} | xiangs]) do
    checked?(xiangs)
  end

  defp checked?([%{status: _} | xiangs]) do
    false && checked?(xiangs)
  end
end
