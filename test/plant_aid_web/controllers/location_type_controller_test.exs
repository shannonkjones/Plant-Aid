defmodule PlantAidWeb.LocationTypeControllerTest do
  use PlantAidWeb.ConnCase

  import PlantAid.AccountsFixtures
  import PlantAid.ResearchAdminFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "when unauthenticated" do
    setup [:create_location_type]

    test "all requests redirect to login", %{conn: conn, location_type: location_type} do
      Enum.each(
        [
          get(conn, Routes.location_type_path(conn, :index)),
          get(conn, Routes.location_type_path(conn, :new)),
          post(conn, Routes.location_type_path(conn, :create), location_type: @create_attrs),
          get(conn, Routes.location_type_path(conn, :edit, location_type)),
          put(conn, Routes.location_type_path(conn, :update, location_type),
            location_type: @update_attrs
          ),
          delete(conn, Routes.location_type_path(conn, :delete, location_type))
        ],
        fn conn ->
          assert redirected_to(conn) == Routes.user_session_path(conn, :new)
        end
      )
    end
  end

  describe "when user is authenticated but not research_admin or superuser" do
    setup context do
      user = user_fixture(%{roles: [:researcher]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end
    # setup [:create_location_type]

    test "all requests redirect to /", %{conn: conn, location_type: location_type} do
      Enum.each(
        [
          get(conn, Routes.location_type_path(conn, :index)),
          get(conn, Routes.location_type_path(conn, :new)),
          post(conn, Routes.location_type_path(conn, :create), location_type: @create_attrs),
          get(conn, Routes.location_type_path(conn, :edit, location_type)),
          put(conn, Routes.location_type_path(conn, :update, location_type),
            location_type: @update_attrs
          ),
          delete(conn, Routes.location_type_path(conn, :delete, location_type))
        ],
        fn conn ->
          assert redirected_to(conn) == Routes.page_path(conn, :index)
        end
      )
    end
  end

  describe "when research_admin index" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all location_types", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Location types"
    end
  end

  describe "when superuser index" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all location_types", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Location types"
    end
  end

  describe "when research_admin new location_type" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :new))
      assert html_response(conn, 200) =~ "New Location type"
    end
  end

  describe "when superuser new location_type" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.location_type_path(conn, :new))
      assert html_response(conn, 200) =~ "New Location type"
    end
  end

  describe "when research_admin create location_type" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user)}
    end

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

  describe "when superuser create location_type" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

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

  describe "when research_admin edit location_type" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

    test "renders form for editing chosen location_type", %{
      conn: conn,
      location_type: location_type
    } do
      conn = get(conn, Routes.location_type_path(conn, :edit, location_type))
      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "when superuser edit location_type" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

    test "renders form for editing chosen location_type", %{
      conn: conn,
      location_type: location_type
    } do
      conn = get(conn, Routes.location_type_path(conn, :edit, location_type))
      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "when research_admin update location_type" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, location_type: location_type} do
      conn =
        put(conn, Routes.location_type_path(conn, :update, location_type),
          location_type: @update_attrs
        )

      assert redirected_to(conn) == Routes.location_type_path(conn, :show, location_type)

      conn = get(conn, Routes.location_type_path(conn, :show, location_type))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, location_type: location_type} do
      conn =
        put(conn, Routes.location_type_path(conn, :update, location_type),
          location_type: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "when superuser update location_type" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, location_type: location_type} do
      conn =
        put(conn, Routes.location_type_path(conn, :update, location_type),
          location_type: @update_attrs
        )

      assert redirected_to(conn) == Routes.location_type_path(conn, :show, location_type)

      conn = get(conn, Routes.location_type_path(conn, :show, location_type))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, location_type: location_type} do
      conn =
        put(conn, Routes.location_type_path(conn, :update, location_type),
          location_type: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Location type"
    end
  end

  describe "when research_admin delete location_type" do
    setup context do
      user = user_fixture(%{roles: [:research_admin]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

    test "returns unauthorized", %{conn: conn, location_type: location_type} do
      conn = delete(conn, Routes.location_type_path(conn, :delete, location_type))
      assert html_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "when superuser delete location_type" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), location_type: location_type_fixture()}
    end

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
