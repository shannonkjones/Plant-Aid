defmodule PlantAidWeb.AdminController do
  use PlantAidWeb, :controller

  alias PlantAid.Admin

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :index,
             conn.assigns.current_user
           ) do
      render(conn, "index.html")
    end
  end
end
