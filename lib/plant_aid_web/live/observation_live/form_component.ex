defmodule PlantAidWeb.ObservationLive.FormComponent do
  use PlantAidWeb, :live_component

  alias PlantAid.Admin
  alias PlantAid.Observations

  @impl true
  def update(%{observation: observation} = assigns, socket) do
    changeset = Observations.change_observation(observation)
    location_types = Admin.list_location_types()
    pathologies = Admin.list_pathologies()
    hosts = Admin.list_hosts()
    selected_host = get_selected_host(changeset, hosts)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(%{changeset: changeset, location_types: location_types, pathologies: pathologies, hosts: hosts, selected_host: selected_host})}
  end

  @impl true
  def handle_event("validate", %{"observation" => observation_params}, socket) do
    changeset =
      socket.assigns.observation
      |> Observations.change_observation(observation_params)
      |> Map.put(:action, :validate)

    selected_host = get_selected_host(changeset, socket.assigns.hosts)

    {:noreply, assign(socket, [changeset: changeset, selected_host: selected_host])}
  end

  def handle_event("save", %{"observation" => observation_params}, socket) do
    save_observation(socket, socket.assigns.action, observation_params)
  end

  defp save_observation(socket, :edit, observation_params) do
    case Observations.update_observation(socket.assigns.observation, observation_params) do
      {:ok, _observation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Observation updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_observation(socket, :new, observation_params) do
    case Observations.create_observation(socket.assigns.current_user, observation_params) do
      {:ok, _observation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Observation created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_selected_host(changeset, hosts) do
    with host_id <- Ecto.Changeset.get_field(changeset, :host_id) do
      Enum.find(hosts, fn h -> h.id == host_id end) || List.first(hosts)
    end
  end
end
