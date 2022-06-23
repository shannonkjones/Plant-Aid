defmodule PlantAid.ObservationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlantAid.Observations` context.
  """

  @doc """
  Generate a observation.
  """
  def observation_fixture(attrs \\ %{}) do
    {:ok, observation} =
      attrs
      |> Enum.into(%{
        control_method: "some control_method",
        coordinates: "some coordinates",
        host_other: "some host_other",
        notes: "some notes",
        observation_date: ~U[2022-06-16 00:10:00Z],
        organic: true
      })
      |> PlantAid.Observations.create_observation()

    observation
  end
end
