defmodule PlantAidWeb.CountyControllerTest do
  use PlantAidWeb.ConnCase, async: true

  import PlantAid.AccountsFixtures
  import PlantAid.AdminFixtures

  @create_attrs %{name: "some name", state: "some state"}
  @update_attrs %{name: "some updated name", state: "some updated state"}
  @invalid_attrs %{name: nil}

  describe "when unauthenticated" do
    setup [:create_county]

    test "all requests redirect to login", %{conn: conn, county: county} do
      Enum.each(
        [
          get(conn, Routes.county_path(conn, :index)),
          get(conn, Routes.county_path(conn, :new)),
          post(conn, Routes.county_path(conn, :create), county: @create_attrs),
          get(conn, Routes.county_path(conn, :edit, county)),
          put(conn, Routes.county_path(conn, :update, county),
            county: @update_attrs
          ),
          delete(conn, Routes.county_path(conn, :delete, county))
        ],
        fn conn ->
          assert redirected_to(conn) == Routes.user_session_path(conn, :new)
        end
      )
    end
  end

  describe "when user is authenticated but not admin or superuser" do
    setup context do
      user = user_fixture(%{roles: [:researcher]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end
    # setup [:create_county]

    test "all requests return forbidden", %{conn: conn, county: county} do
      Enum.each(
        [
          get(conn, Routes.county_path(conn, :index)),
          get(conn, Routes.county_path(conn, :new)),
          post(conn, Routes.county_path(conn, :create), county: @create_attrs),
          get(conn, Routes.county_path(conn, :edit, county)),
          put(conn, Routes.county_path(conn, :update, county),
            county: @update_attrs
          ),
          delete(conn, Routes.county_path(conn, :delete, county))
        ],
        fn conn ->
          assert html_response(conn, 403) =~ "Forbidden"
        end
      )
    end
  end

  describe "when admin index" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all counties", %{conn: conn} do
      conn = get(conn, Routes.county_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Counties"
    end
  end

  describe "when superuser index" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all counties", %{conn: conn} do
      conn = get(conn, Routes.county_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Counties"
    end
  end

  describe "when admin new county" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.county_path(conn, :new))
      assert html_response(conn, 200) =~ "New County"
    end
  end

  describe "when superuser new county" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.county_path(conn, :new))
      assert html_response(conn, 200) =~ "New County"
    end
  end

  describe "when admin create county" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.county_path(conn, :show, id)

      conn = get(conn, Routes.county_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show County"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @invalid_attrs)
      assert html_response(conn, 200) =~ "New County"
    end
  end

  describe "when superuser create county" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.county_path(conn, :show, id)

      conn = get(conn, Routes.county_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show County"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.county_path(conn, :create), county: @invalid_attrs)
      assert html_response(conn, 200) =~ "New County"
    end
  end

  describe "when admin edit county" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "renders form for editing chosen county", %{
      conn: conn,
      county: county
    } do
      conn = get(conn, Routes.county_path(conn, :edit, county))
      assert html_response(conn, 200) =~ "Edit County"
    end
  end

  describe "when superuser edit county" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "renders form for editing chosen county", %{
      conn: conn,
      county: county
    } do
      conn = get(conn, Routes.county_path(conn, :edit, county))
      assert html_response(conn, 200) =~ "Edit County"
    end
  end

  describe "when admin update county" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, county: county} do
      conn =
        put(conn, Routes.county_path(conn, :update, county),
          county: @update_attrs
        )

      assert redirected_to(conn) == Routes.county_path(conn, :show, county)

      conn = get(conn, Routes.county_path(conn, :show, county))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, county: county} do
      conn =
        put(conn, Routes.county_path(conn, :update, county),
          county: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit County"
    end
  end

  describe "when superuser update county" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, county: county} do
      conn =
        put(conn, Routes.county_path(conn, :update, county),
          county: @update_attrs
        )

      assert redirected_to(conn) == Routes.county_path(conn, :show, county)

      conn = get(conn, Routes.county_path(conn, :show, county))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, county: county} do
      conn =
        put(conn, Routes.county_path(conn, :update, county),
          county: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit County"
    end
  end

  describe "when admin delete county" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "returns unauthorized", %{conn: conn, county: county} do
      conn = delete(conn, Routes.county_path(conn, :delete, county))
      assert html_response(conn, 403) =~ "Forbidden"
      conn = get(conn, Routes.county_path(conn, :show, county))
      assert html_response(conn, 200) =~ "Show County"
    end
  end

  describe "when superuser delete county" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), county: county_fixture()}
    end

    test "deletes chosen county", %{conn: conn, county: county} do
      conn = delete(conn, Routes.county_path(conn, :delete, county))
      assert redirected_to(conn) == Routes.county_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.county_path(conn, :show, county))
      end
    end
  end

  defp create_county(_) do
    county = county_fixture()
    %{county: county}
  end
end
