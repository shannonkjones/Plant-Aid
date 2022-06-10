defmodule PlantAidWeb.CountyController do
  use PlantAidWeb, :controller

  alias PlantAid.Admin
  alias PlantAid.Admin.County

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :list_counties,
             conn.assigns.current_user
           ),
         counties = Admin.list_counties() do
      render(conn, "index.html", counties: counties)
    end
  end

  def new(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :change_county,
             conn.assigns.current_user
           ),
         changeset = Admin.change_county(%County{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"county" => county_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :create_county,
             conn.assigns.current_user,
             county_params
           ) do
      case Admin.create_county(county_params) do
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
             Admin,
             :get_county,
             conn.assigns.current_user
           ),
         county = Admin.get_county!(id) do
      render(conn, "show.html", county: county)
    end
  end

  def edit(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_county,
             conn.assigns.current_user,
             id
           ),
         county = Admin.get_county!(id),
         :ok <-
           Bodyguard.permit(
             Admin,
             :change_county,
             conn.assigns.current_user,
             county
           ) do
      changeset = Admin.change_county(county)
      render(conn, "edit.html", county: county, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "county" => county_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_county,
             conn.assigns.current_user,
             id
           ),
         :ok <-
           Bodyguard.permit(
             Admin,
             :update_county,
             conn.assigns.current_user,
             county_params
           ),
         county = Admin.get_county!(id) do
      case Admin.update_county(county, county_params) do
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
             Admin,
             :delete_county,
             conn.assigns.current_user,
             id
           ),
         county = Admin.get_county!(id) do
      {:ok, _county} = Admin.delete_county(county)

      conn
      |> put_flash(:info, "County deleted successfully.")
      |> redirect(to: Routes.county_path(conn, :index))
    end
  end
end
