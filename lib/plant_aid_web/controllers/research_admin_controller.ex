defmodule PlantAidWeb.ResearchAdminController do
  use PlantAidWeb, :controller

  alias PlantAid.ResearchAdmin

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :index,
             conn.assigns.current_user
           ) do
      render(conn, "index.html")
    end
  end
end
