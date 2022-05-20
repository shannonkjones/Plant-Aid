defmodule PlantAid.ResearchAdminTest do
  use PlantAid.DataCase

  alias PlantAid.ResearchAdmin

  describe "location_types" do
    alias PlantAid.ResearchAdmin.LocationType

    import PlantAid.ResearchAdminFixtures

    @invalid_attrs %{name: nil}

    test "list_location_types/0 returns all location_types" do
      location_type = location_type_fixture()
      assert ResearchAdmin.list_location_types() == [location_type]
    end

    test "get_location_type!/1 returns the location_type with given id" do
      location_type = location_type_fixture()
      assert ResearchAdmin.get_location_type!(location_type.id) == location_type
    end

    test "create_location_type/1 with valid data creates a location_type" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %LocationType{} = location_type} = ResearchAdmin.create_location_type(valid_attrs)
      assert location_type.name == "some name"
    end

    test "create_location_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ResearchAdmin.create_location_type(@invalid_attrs)
    end

    test "update_location_type/2 with valid data updates the location_type" do
      location_type = location_type_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %LocationType{} = location_type} = ResearchAdmin.update_location_type(location_type, update_attrs)
      assert location_type.name == "some updated name"
    end

    test "update_location_type/2 with invalid data returns error changeset" do
      location_type = location_type_fixture()
      assert {:error, %Ecto.Changeset{}} = ResearchAdmin.update_location_type(location_type, @invalid_attrs)
      assert location_type == ResearchAdmin.get_location_type!(location_type.id)
    end

    test "delete_location_type/1 deletes the location_type" do
      location_type = location_type_fixture()
      assert {:ok, %LocationType{}} = ResearchAdmin.delete_location_type(location_type)
      assert_raise Ecto.NoResultsError, fn -> ResearchAdmin.get_location_type!(location_type.id) end
    end

    test "change_location_type/1 returns a location_type changeset" do
      location_type = location_type_fixture()
      assert %Ecto.Changeset{} = ResearchAdmin.change_location_type(location_type)
    end
  end
end
