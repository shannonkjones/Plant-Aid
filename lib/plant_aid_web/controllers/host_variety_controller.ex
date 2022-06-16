defmodule PlantAidWeb.HostVarietyController do
  use PlantAidWeb, :controller

  alias PlantAid.Admin
  alias PlantAid.Admin.HostVariety

  # TODO: authorization!

  def index(conn, %{"host_id" => host_id}) do
    host_varieties = Admin.list_host_varieties(host_id)
    render(conn, "index.html", host_varieties: host_varieties, host_id: host_id)
  end

  def new(conn, %{"host_id" => host_id}) do
    changeset = Admin.change_host_variety(%HostVariety{})
    render(conn, "new.html", changeset: changeset, host_id: host_id)
  end

  def create(conn, %{"host_id" => host_id, "host_variety" => host_variety_params}) do
    IO.inspect(host_variety_params, label: "params")
    case Admin.create_host_variety(host_id, host_variety_params) do
      {:ok, host_variety} ->
        conn
        |> put_flash(:info, "Host variety created successfully.")
        |> redirect(to: Routes.host_variety_path(conn, :show, host_id, host_variety))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"host_id" => host_id, "id" => id}) do
    host_variety = Admin.get_host_variety!(host_id, id)
    render(conn, "show.html", host_variety: host_variety)
  end

  def edit(conn, %{"host_id" => host_id, "id" => id}) do
    host_variety = Admin.get_host_variety!(host_id, id)
    changeset = Admin.change_host_variety(host_variety)
    render(conn, "edit.html", host_variety: host_variety, changeset: changeset)
  end

  def update(conn, %{"host_id" => host_id, "id" => id, "host_variety" => host_variety_params}) do
    host_variety = Admin.get_host_variety!(host_id, id)

    case Admin.update_host_variety(host_variety, host_variety_params) do
      {:ok, host_variety} ->
        conn
        |> put_flash(:info, "Host variety updated successfully.")
        |> redirect(to: Routes.host_variety_path(conn, :show, host_id, host_variety))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", host_variety: host_variety, changeset: changeset)
    end
  end

  def delete(conn, %{"host_id" => host_id, "id" => id}) do
    host_variety = Admin.get_host_variety!(host_id, id)
    {:ok, _host_variety} = Admin.delete_host_variety(host_variety)

    conn
    |> put_flash(:info, "Host variety deleted successfully.")
    |> redirect(to: Routes.host_variety_path(conn, :index, host_id))
  end
end
