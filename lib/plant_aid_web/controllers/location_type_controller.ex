defmodule PlantAidWeb.LocationTypeController do
  use PlantAidWeb, :controller

  alias PlantAid.ResearchAdmin
  alias PlantAid.ResearchAdmin.LocationType

  def index(conn, _params) do
    location_types = ResearchAdmin.list_location_types()
    render(conn, "index.html", location_types: location_types)
  end

  def new(conn, _params) do
    changeset = ResearchAdmin.change_location_type(%LocationType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"location_type" => location_type_params}) do
    case ResearchAdmin.create_location_type(location_type_params) do
      {:ok, location_type} ->
        conn
        |> put_flash(:info, "Location type created successfully.")
        |> redirect(to: Routes.location_type_path(conn, :show, location_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    location_type = ResearchAdmin.get_location_type!(id)
    render(conn, "show.html", location_type: location_type)
  end

  def edit(conn, %{"id" => id}) do
    location_type = ResearchAdmin.get_location_type!(id)
    changeset = ResearchAdmin.change_location_type(location_type)
    render(conn, "edit.html", location_type: location_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "location_type" => location_type_params}) do
    location_type = ResearchAdmin.get_location_type!(id)

    case ResearchAdmin.update_location_type(location_type, location_type_params) do
      {:ok, location_type} ->
        conn
        |> put_flash(:info, "Location type updated successfully.")
        |> redirect(to: Routes.location_type_path(conn, :show, location_type))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", location_type: location_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    location_type = ResearchAdmin.get_location_type!(id)
    {:ok, _location_type} = ResearchAdmin.delete_location_type(location_type)

    conn
    |> put_flash(:info, "Location type deleted successfully.")
    |> redirect(to: Routes.location_type_path(conn, :index))
  end
end
