defmodule PlantAidWeb.ObservationLive.FilterComponent do
  use PlantAidWeb, :live_component

  alias PlantAid.Admin
  alias PlantAid.Observations

  @impl true
  def update(%{filter: filter} = assigns, socket) do
    IO.inspect(filter, label: "filter")
    # changeset = Observations.change_observation(observation)
    # IO.inspect(changeset, label: "changeset")
    location_types = Admin.list_location_types() |> Enum.map(fn lt -> {lt.name, lt.id} end)
    pathologies = Admin.list_pathologies() |> Enum.map(fn p -> {p.common_name, p.id} end)
    hosts = Admin.list_hosts() |> Enum.map(fn h -> {h.common_name, h.id} end)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(%{filter: filter, location_types: location_types, pathologies: pathologies, hosts: hosts})}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter_params}, socket) do
    observations = Observations.list_observations(filter_params)
    {:noreply, assign(socket, %{observations: observations})}
  end

  # @impl true
  # def handle_event("validate", %{"observation" => observation_params}, socket) do
  #   changeset =
  #     socket.assigns.observation
  #     |> Observations.change_observation(observation_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign(socket, :changeset, changeset)}
  # end

  # def handle_event("save", %{"observation" => observation_params}, socket) do
  #   save_observation(socket, socket.assigns.action, observation_params)
  # end

  # defp save_observation(socket, :edit, observation_params) do
  #   case Observations.update_observation(socket.assigns.observation, observation_params) do
  #     {:ok, _observation} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Observation updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  # defp save_observation(socket, :new, observation_params) do
  #   case Observations.create_observation(socket.assigns.current_user, observation_params) do
  #     {:ok, _observation} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Observation created successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, changeset: changeset)}
  #   end
  # end
end
