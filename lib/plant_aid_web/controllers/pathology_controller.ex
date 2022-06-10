defmodule PlantAidWeb.PathologyController do
  use PlantAidWeb, :controller

  alias PlantAid.Admin
  alias PlantAid.Admin.Pathology

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :list_pathologies,
             conn.assigns.current_user
           ),
         pathologies = Admin.list_pathologies() do
      render(conn, "index.html", pathologies: pathologies)
    end
  end

  def new(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :change_pathology,
             conn.assigns.current_user
           ),
         changeset = Admin.change_pathology(%Pathology{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"pathology" => pathology_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :create_pathology,
             conn.assigns.current_user,
             pathology_params
           ) do
      case Admin.create_pathology(pathology_params) do
        {:ok, pathology} ->
          conn
          |> put_flash(:info, "Pathology created successfully.")
          |> redirect(to: Routes.pathology_path(conn, :show, pathology))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_pathology,
             conn.assigns.current_user
           ),
         pathology = Admin.get_pathology!(id) do
      render(conn, "show.html", pathology: pathology)
    end
  end

  def edit(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_pathology,
             conn.assigns.current_user,
             id
           ),
         pathology = Admin.get_pathology!(id),
         :ok <-
           Bodyguard.permit(
             Admin,
             :change_pathology,
             conn.assigns.current_user,
             pathology
           ) do
      changeset = Admin.change_pathology(pathology)
      render(conn, "edit.html", pathology: pathology, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "pathology" => pathology_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_pathology,
             conn.assigns.current_user,
             id
           ),
         :ok <-
           Bodyguard.permit(
             Admin,
             :update_pathology,
             conn.assigns.current_user,
             pathology_params
           ),
         pathology = Admin.get_pathology!(id) do
      case Admin.update_pathology(pathology, pathology_params) do
        {:ok, pathology} ->
          conn
          |> put_flash(:info, "Pathology updated successfully.")
          |> redirect(to: Routes.pathology_path(conn, :show, pathology))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", pathology: pathology, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :delete_pathology,
             conn.assigns.current_user,
             id
           ),
         pathology = Admin.get_pathology!(id) do
      {:ok, _pathology} = Admin.delete_pathology(pathology)

      conn
      |> put_flash(:info, "pathology deleted successfully.")
      |> redirect(to: Routes.pathology_path(conn, :index))
    end
  end
end
