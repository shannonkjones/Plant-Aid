defmodule PlantAidWeb.LocationTypeController do
  use PlantAidWeb, :controller

  alias PlantAid.ResearchAdmin
  alias PlantAid.ResearchAdmin.LocationType

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :list_location_types,
             conn.assigns.current_user
           ),
         location_types = ResearchAdmin.list_location_types() do
      render(conn, "index.html", location_types: location_types)
    end
  end

  def new(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :change_location_type,
             conn.assigns.current_user
           ),
         changeset = ResearchAdmin.change_location_type(%LocationType{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"location_type" => location_type_params}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :create_location_types,
             conn.assigns.current_user,
             location_type_params
           ) do
      case ResearchAdmin.create_location_type(location_type_params) do
        {:ok, location_type} ->
          conn
          |> put_flash(:info, "Location type created successfully.")
          |> redirect(to: Routes.location_type_path(conn, :show, location_type))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_location_type,
             conn.assigns.current_user
           ),
         location_type = ResearchAdmin.get_location_type!(id) do
      render(conn, "show.html", location_type: location_type)
    end
  end

  def edit(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_location_type,
             conn.assigns.current_user,
             id
           ),
           location_type = ResearchAdmin.get_location_type!(id),
           :ok <-
            Bodyguard.permit(
              ResearchAdmin,
              :change_location_type,
              conn.assigns.current_user,
              location_type
            )
          do
      changeset = ResearchAdmin.change_location_type(location_type)
      render(conn, "edit.html", location_type: location_type, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "location_type" => location_type_params}) do
    with :ok <-
           Bodyguard.permit(
             ResearchAdmin,
             :get_location_type,
             conn.assigns.current_user,
             id
           ),
           :ok <-
            Bodyguard.permit(
              ResearchAdmin,
              :update_location_type,
              conn.assigns.current_user,
              location_type_params
            ),
         location_type = ResearchAdmin.get_location_type!(id) do
      case ResearchAdmin.update_location_type(location_type, location_type_params) do
        {:ok, location_type} ->
          conn
          |> put_flash(:info, "Location type updated successfully.")
          |> redirect(to: Routes.location_type_path(conn, :show, location_type))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", location_type: location_type, changeset: changeset)
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
         location_type = ResearchAdmin.get_location_type!(id) do
      {:ok, _location_type} = ResearchAdmin.delete_location_type(location_type)

      conn
      |> put_flash(:info, "Location type deleted successfully.")
      |> redirect(to: Routes.location_type_path(conn, :index))
    end
  end
end
