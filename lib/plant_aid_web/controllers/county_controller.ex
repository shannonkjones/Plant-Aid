defmodule PlantAidWeb.CountyController do
  use PlantAidWeb, :controller

  alias PlantAid.ResearchAdmin
  alias PlantAid.ResearchAdmin.County

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :list_counties,
             conn.assigns.current_user
           ),
         counties = ResearchAdmin.list_counties() do
      render(conn, "index.html", counties: counties)
    end
  end

  def new(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :change_county,
             conn.assigns.current_user
           ),
         changeset = ResearchAdmin.change_county(%County{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"county" => county_params}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :create_county,
             conn.assigns.current_user,
             county_params
           ) do
      case ResearchAdmin.create_county(county_params) do
        {:ok, county} ->
          conn
          |> put_flash(:info, "County created successfully.")
          |> redirect(to: Routes.county_path(conn, :show, county))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_county,
             conn.assigns.current_user
           ),
         county = ResearchAdmin.get_county!(id) do
      render(conn, "show.html", county: county)
    end
  end

  def edit(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_county,
             conn.assigns.current_user,
             id
           ),
         county = ResearchAdmin.get_county!(id),
         :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :change_county,
             conn.assigns.current_user,
             county
           ) do
      changeset = ResearchAdmin.change_county(county)
      render(conn, "edit.html", county: county, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "county" => county_params}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_county,
             conn.assigns.current_user,
             id
           ),
         :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :update_county,
             conn.assigns.current_user,
             county_params
           ),
         county = ResearchAdmin.get_county!(id) do
      case ResearchAdmin.update_county(county, county_params) do
        {:ok, county} ->
          conn
          |> put_flash(:info, "County updated successfully.")
          |> redirect(to: Routes.county_path(conn, :show, county))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", county: county, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :delete_location_type,
             conn.assigns.current_user,
             id
           ),
         county = ResearchAdmin.get_county!(id) do
      {:ok, _county} = ResearchAdmin.delete_county(county)

      conn
      |> put_flash(:info, "County deleted successfully.")
      |> redirect(to: Routes.county_path(conn, :index))
    end
  end
end
