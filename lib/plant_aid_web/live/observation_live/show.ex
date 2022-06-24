defmodule PlantAidWeb.ObservationLive.Show do
  use PlantAidWeb, :live_view

  alias PlantAid.Accounts
  alias PlantAid.Observations

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    {:ok, assign(socket, :current_user, user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:observation, Observations.get_observation!(id))}
  end

  defp page_title(:show), do: "Show Observation"
  defp page_title(:edit), do: "Edit Observation"
end
