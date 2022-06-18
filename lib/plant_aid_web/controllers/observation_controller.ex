defmodule PlantAidWeb.ObservationController do
  use PlantAidWeb, :controller

  alias PlantAid.Observations
  alias PlantAid.Observations.Observation

  def index(conn, _params) do
    observations = Observations.list_observations()
    render(conn, "index.html", observations: observations)
  end

  def new(conn, _params) do
    changeset = Observations.change_observation(%Observation{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"observation" => observation_params}) do
    IO.puts("1")
    observation_params = Map.update!(observation_params, "coordinates", fn coordinate_string ->
      [longitude, latitude] = String.split(coordinate_string, ",") |> Enum.map(&String.to_float/1)
      # "{\"type\": \"Point\", \"coordinates\": [#{longitude}, #{latitude}] }"
      %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
    end)
    IO.puts("2")
    case Observations.create_observation(observation_params) do
      {:ok, observation} ->
        IO.puts("3good")
        conn
        |> put_flash(:info, "Observation created successfully.")
        |> redirect(to: Routes.observation_path(conn, :show, observation))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.puts("3bad")
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    observation = Observations.get_observation!(id)
    render(conn, "show.html", observation: observation)
  end

  def edit(conn, %{"id" => id}) do
    observation = Observations.get_observation!(id)
    changeset = Observations.change_observation(observation)
    render(conn, "edit.html", observation: observation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "observation" => observation_params}) do
    observation = Observations.get_observation!(id)

    case Observations.update_observation(observation, observation_params) do
      {:ok, observation} ->
        conn
        |> put_flash(:info, "Observation updated successfully.")
        |> redirect(to: Routes.observation_path(conn, :show, observation))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", observation: observation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    observation = Observations.get_observation!(id)
    {:ok, _observation} = Observations.delete_observation(observation)

    conn
    |> put_flash(:info, "Observation deleted successfully.")
    |> redirect(to: Routes.observation_path(conn, :index))
  end
end
