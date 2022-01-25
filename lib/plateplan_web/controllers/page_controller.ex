defmodule PlateplanWeb.PageController do
  use PlateplanWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
