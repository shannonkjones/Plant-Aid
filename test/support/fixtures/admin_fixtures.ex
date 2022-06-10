defmodule PlantAid.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PlantAid.Admin` context.
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
      |> PlantAid.Admin.create_location_type()

    location_type
  end

  @doc """
  Generate a county.
  """
  def county_fixture(attrs \\ %{}) do
    {:ok, county} =
      attrs
      |> Enum.into(%{
        name: "some name",
        state: "some state"
      })
      |> PlantAid.Admin.create_county()

    county
  end
end
