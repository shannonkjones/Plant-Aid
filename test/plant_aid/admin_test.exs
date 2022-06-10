defmodule PlantAid.AdminTest do
  use PlantAid.DataCase, async: true

  alias PlantAid.Admin

  describe "location_types" do
    alias PlantAid.Admin.LocationType

    import PlantAid.AdminFixtures

    @invalid_attrs %{name: nil}

    test "list_location_types/0 returns all location_types" do
      location_type = location_type_fixture()
      assert Admin.list_location_types() == [location_type]
    end

    test "get_location_type!/1 returns the location_type with given id" do
      location_type = location_type_fixture()
      assert Admin.get_location_type!(location_type.id) == location_type
    end

    test "create_location_type/1 with valid data creates a location_type" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %LocationType{} = location_type} = Admin.create_location_type(valid_attrs)
      assert location_type.name == "some name"
    end

    test "create_location_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_location_type(@invalid_attrs)
    end

    test "update_location_type/2 with valid data updates the location_type" do
      location_type = location_type_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %LocationType{} = location_type} = Admin.update_location_type(location_type, update_attrs)
      assert location_type.name == "some updated name"
    end

    test "update_location_type/2 with invalid data returns error changeset" do
      location_type = location_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_location_type(location_type, @invalid_attrs)
      assert location_type == Admin.get_location_type!(location_type.id)
    end

    test "delete_location_type/1 deletes the location_type" do
      location_type = location_type_fixture()
      assert {:ok, %LocationType{}} = Admin.delete_location_type(location_type)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_location_type!(location_type.id) end
    end

    test "change_location_type/1 returns a location_type changeset" do
      location_type = location_type_fixture()
      assert %Ecto.Changeset{} = Admin.change_location_type(location_type)
    end
  end

  describe "counties" do
    alias PlantAid.Admin.County

    import PlantAid.AdminFixtures

    @invalid_attrs %{name: nil, state: nil}

    test "list_counties/0 returns all counties" do
      county = county_fixture()
      assert Admin.list_counties() == [county]
    end

    test "get_county!/1 returns the county with given id" do
      county = county_fixture()
      assert Admin.get_county!(county.id) == county
    end

    test "create_county/1 with valid data creates a county" do
      valid_attrs = %{name: "some name", state: "some state"}

      assert {:ok, %County{} = county} = Admin.create_county(valid_attrs)
      assert county.name == "some name"
      assert county.state == "some state"
    end

    test "create_county/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_county(@invalid_attrs)
    end

    test "update_county/2 with valid data updates the county" do
      county = county_fixture()
      update_attrs = %{name: "some updated name", state: "some updated state"}

      assert {:ok, %County{} = county} = Admin.update_county(county, update_attrs)
      assert county.name == "some updated name"
      assert county.state == "some updated state"
    end

    test "update_county/2 with invalid data returns error changeset" do
      county = county_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_county(county, @invalid_attrs)
      assert county == Admin.get_county!(county.id)
    end

    test "delete_county/1 deletes the county" do
      county = county_fixture()
      assert {:ok, %County{}} = Admin.delete_county(county)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_county!(county.id) end
    end

    test "change_county/1 returns a county changeset" do
      county = county_fixture()
      assert %Ecto.Changeset{} = Admin.change_county(county)
    end
  end

  describe "pathologies" do
    alias PlantAid.Admin.Pathology

    import PlantAid.AdminFixtures

    @invalid_attrs %{common_name: nil, scientific_name: nil}

    test "list_pathologies/0 returns all pathologies" do
      pathology = pathology_fixture()
      assert Admin.list_pathologies() == [pathology]
    end

    test "get_pathology!/1 returns the pathology with given id" do
      pathology = pathology_fixture()
      assert Admin.get_pathology!(pathology.id) == pathology
    end

    test "create_pathology/1 with valid data creates a pathology" do
      valid_attrs = %{common_name: "some common_name", scientific_name: "some scientific_name"}

      assert {:ok, %Pathology{} = pathology} = Admin.create_pathology(valid_attrs)
      assert pathology.common_name == "some common_name"
      assert pathology.scientific_name == "some scientific_name"
    end

    test "create_pathology/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_pathology(@invalid_attrs)
    end

    test "update_pathology/2 with valid data updates the pathology" do
      pathology = pathology_fixture()
      update_attrs = %{common_name: "some updated common_name", scientific_name: "some updated scientific_name"}

      assert {:ok, %Pathology{} = pathology} = Admin.update_pathology(pathology, update_attrs)
      assert pathology.common_name == "some updated common_name"
      assert pathology.scientific_name == "some updated scientific_name"
    end

    test "update_pathology/2 with invalid data returns error changeset" do
      pathology = pathology_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_pathology(pathology, @invalid_attrs)
      assert pathology == Admin.get_pathology!(pathology.id)
    end

    test "delete_pathology/1 deletes the pathology" do
      pathology = pathology_fixture()
      assert {:ok, %Pathology{}} = Admin.delete_pathology(pathology)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_pathology!(pathology.id) end
    end

    test "change_pathology/1 returns a pathology changeset" do
      pathology = pathology_fixture()
      assert %Ecto.Changeset{} = Admin.change_pathology(pathology)
    end
  end
end
