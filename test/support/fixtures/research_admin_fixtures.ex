defmodule PlantAid.ResearchAdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlantAid.ResearchAdmin` context.
  """

  @doc """
  Generate a location_type.
  """
  def location_type_fixture(attrs \\ %{}) do
    {:ok, location_type} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PlantAid.ResearchAdmin.create_location_type()

    location_type
  end
end
