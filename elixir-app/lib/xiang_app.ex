defmodule XiangApp do
  @moduledoc """
    XiangApp Application. This module takes care of the the boot.
    Because the XiangApp is a standalone desktop application there is
    initial Database initialization needed when the SQlite database is
    not yet existing. This is done during start() by
    calling `XiangApp.Repo.initialize()`.

    Other than that this module initialized the main `Desktop.Window`
    and configures it to create a taskbar icon as well.

  """
  use Application
  require Logger

  def config_dir() do
    Path.join([Desktop.OS.home(), ".config", "xiang"])
  end

  @app Mix.Project.config()[:app]

  def start(:normal, []) do
    Desktop.identify_default_locale(XiangWeb.Gettext)
    File.mkdir_p!(config_dir())

    Application.put_env(:xiang_app, XiangApp.Repo,
      database: Path.join(config_dir(), "/database.sq3")
    )

    {:ok, sup} = Supervisor.start_link([XiangApp.Repo], name: __MODULE__, strategy: :one_for_one)
    XiangApp.Repo.initialize()

    {:ok, _} = Supervisor.start_child(sup, XiangWeb.Sup)

    {:ok, _} =
      Supervisor.start_child(sup, {
        Desktop.Window,
        [
          app: @app,
          id: XiangWindow,
          title: "XiangApp",
          size: {600, 500},
          icon: "icon.png",
          menubar: XiangApp.MenuBar,
          icon_menu: XiangApp.Menu,
          url: &XiangWeb.Endpoint.url/0
        ]
      })
  end

  def config_change(changed, _new, removed) do
    XiangWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
