defmodule PlantAidWeb.ResearchAdminController do
  use PlantAidWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
