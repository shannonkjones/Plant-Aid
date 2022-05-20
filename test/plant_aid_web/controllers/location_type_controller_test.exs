defmodule PlantAidWeb.LocationTypeControllerTest do
  use PlantAidWeb.ConnCase

  import PlantAid.ResearchAdminFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all location_types", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Location types"
    end
  end

  describe "new location_type" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :new))
      assert html_response(conn, 200) =~ "New Location type"
    end
  end

  describe "create location_type" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.location_type_path(conn, :create), location_type: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.location_type_path(conn, :show, id)

      conn = get(conn, Routes.location_type_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Location type"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.location_type_path(conn, :create), location_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Location type"
    end
  end

  describe "edit location_type" do
    setup [:create_location_type]

    test "renders form for editing chosen location_type", %{conn: conn, location_type: location_type} do
      conn = get(conn, Routes.location_type_path(conn, :edit, location_type))
      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "update location_type" do
    setup [:create_location_type]

    test "redirects when data is valid", %{conn: conn, location_type: location_type} do
      conn = put(conn, Routes.location_type_path(conn, :update, location_type), location_type: @update_attrs)
      assert redirected_to(conn) == Routes.location_type_path(conn, :show, location_type)

      conn = get(conn, Routes.location_type_path(conn, :show, location_type))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, location_type: location_type} do
      conn = put(conn, Routes.location_type_path(conn, :update, location_type), location_type: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "delete location_type" do
    setup [:create_location_type]

    test "deletes chosen location_type", %{conn: conn, location_type: location_type} do
      conn = delete(conn, Routes.location_type_path(conn, :delete, location_type))
      assert redirected_to(conn) == Routes.location_type_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.location_type_path(conn, :show, location_type))
      end
    end
  end

  defp create_location_type(_) do
    location_type = location_type_fixture()
    %{location_type: location_type}
  end
end
