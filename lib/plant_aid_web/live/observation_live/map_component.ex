defmodule PlantAidWeb.ObservationLive.MapComponent do
  use PlantAidWeb, :live_component

  @impl true
  def update(%{observations: observations} = assigns, socket) do
    features =
      observations
      |> Enum.reject(fn observation ->
        !observation.coordinates
      end)
      |> Enum.map(fn observation ->
        %{
          type: "Feature",
          properties: %{
            id: observation.id,
            status: observation.status,
            date: observation.observation_date,
            host: observation.host,
            pathology: observation.suspected_pathology
          },
          geometry: %{
            type: "Point",
            coordinates: Tuple.to_list(observation.coordinates.coordinates)
          }
        }
      end)

    {:ok,
     socket
     |> assign(assigns)
     |> push_event("update-map", %{id: "map", features: features})}

    #  |> assign(map_observations: Jason.encode!(map_observations))}
  end
end
