defmodule PlantAidWeb.ObservationLive.FilterComponent do
  use PlantAidWeb, :live_component

  alias PlantAid.Admin
  alias PlantAid.Observations
  alias PlantAid.Observations.Filter

  @impl true
  def update(%{filter: filter} = assigns, socket) do
    changeset = Observations.change_filter(filter)
    location_types = Admin.list_location_types() |> Enum.map(fn lt -> {lt.name, lt.id} end)
    pathologies = Admin.list_pathologies() |> Enum.map(fn p -> {p.common_name, p.id} end)
    hosts = Admin.list_hosts() |> Enum.map(fn h -> {h.common_name, h.id} end)
    states = Admin.list_states()
    counties = Admin.list_counties()
    county_select_options = if filter.states do
      Enum.filter(counties, fn c ->
        c.state in filter.states
      end)
    else
      counties
    end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(%{
       changeset: changeset,
       location_types: location_types,
       pathologies: pathologies,
       hosts: hosts,
       states: states,
       counties: counties,
       county_select_options: county_select_options
     })}
  end

  @impl true
  def handle_event("filter", %{"filter" => filter_params}, socket) do
    filter = Observations.update_filter(%Filter{}, filter_params)

    send(self(), {:updated_filter, filter})

    {:noreply,
     socket
     |> put_flash(:info, "Filter updated")
     |> push_patch(to: socket.assigns.return_to)}
  end

  @impl true
  def handle_event("state_changed", %{"filter" => %{"states" => states}}, socket) do
    county_select_options = Enum.filter(socket.assigns.counties, fn c ->
      c.state in states
    end)
    {:noreply, assign(socket, county_select_options: county_select_options)}
  end

  @impl true
  def handle_event("state_changed", _, socket) do
    {:noreply, assign(socket, county_select_options: socket.assigns.counties)}
  end
end
