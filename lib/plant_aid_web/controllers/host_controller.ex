defmodule PlantAidWeb.HostController do
  use PlantAidWeb, :controller

  alias PlantAid.Admin
  alias PlantAid.Admin.Host

  action_fallback PlantAidWeb.FallbackController

  def index(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :list_hosts,
             conn.assigns.current_user
           ),
         hosts = Admin.list_hosts() do
      render(conn, "index.html", hosts: hosts)
    end
  end

  def new(conn, _params) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :change_host,
             conn.assigns.current_user
           ),
         changeset = Admin.change_host(%Host{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"host" => host_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :create_host,
             conn.assigns.current_user,
             host_params
           ) do
      case Admin.create_host(host_params) do
        {:ok, host} ->
          conn
          |> put_flash(:info, "host created successfully.")
          |> redirect(to: Routes.host_path(conn, :show, host))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_host,
             conn.assigns.current_user
           ),
         host = Admin.get_host!(id) do
      render(conn, "show.html", host: host)
    end
  end

  def edit(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_host,
             conn.assigns.current_user,
             id
           ),
         host = Admin.get_host!(id),
         :ok <-
           Bodyguard.permit(
             Admin,
             :change_host,
             conn.assigns.current_user,
             host
           ) do
      changeset = Admin.change_host(host)
      render(conn, "edit.html", host: host, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "host" => host_params}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :get_host,
             conn.assigns.current_user,
             id
           ),
         :ok <-
           Bodyguard.permit(
             Admin,
             :update_host,
             conn.assigns.current_user,
             host_params
           ),
         host = Admin.get_host!(id) do
      case Admin.update_host(host, host_params) do
        {:ok, host} ->
          conn
          |> put_flash(:info, "host updated successfully.")
          |> redirect(to: Routes.host_path(conn, :show, host))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", host: host, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <-
           Bodyguard.permit(
             Admin,
             :delete_host,
             conn.assigns.current_user,
             id
           ),
         host = Admin.get_host!(id) do
      {:ok, _host} = Admin.delete_host(host)

      conn
      |> put_flash(:info, "host deleted successfully.")
      |> redirect(to: Routes.host_path(conn, :index))
    end
  end
end
