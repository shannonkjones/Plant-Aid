defmodule PlantAidWeb.ObservationLive.Index do
  use PlantAidWeb, :live_view

  alias PlantAid.Accounts
  alias PlantAid.Observations
  alias PlantAid.Observations.{Observation, Filter}

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    filter = Filter.changeset(%Filter{}, %{"user_id" => user.id})

    {:ok,
     assign(socket,
       current_user: user,
       filter: filter,
       observations: list_observations(filter)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Observation")
    |> assign(:observation, Observations.get_observation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:page_title, "New Observation")
    |> assign(:observation, %Observation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Observations")
    |> assign(:observation, nil)
  end

  defp apply_action(socket, :filter, params) do
    socket
    |> assign(:page_title, "Filter Observations")
    |> assign(:observation, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    observation = Observations.get_observation!(id)
    {:ok, _} = Observations.delete_observation(observation)

    {:noreply, assign(socket, :observations, list_observations())}
  end

  defp list_observations(criteria \\ %{}) do
    Observations.list_observations(criteria)
  end
end
