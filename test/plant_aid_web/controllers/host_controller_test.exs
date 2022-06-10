defmodule PlantAidWeb.HostControllerTest do
  use PlantAidWeb.ConnCase, async: true

  import PlantAid.AccountsFixtures
  import PlantAid.AdminFixtures

  @create_attrs %{common_name: "some common_name", scientific_name: "some scientific_name"}
  @update_attrs %{common_name: "some updated common_name", scientific_name: "some updated scientific_name"}
  @invalid_attrs %{common_name: nil, scientific_name: nil}

  describe "when unauthenticated" do
    setup [:create_host]

    test "all requests redirect to login", %{conn: conn, host: host} do
      Enum.each(
        [
          get(conn, Routes.host_path(conn, :index)),
          get(conn, Routes.host_path(conn, :new)),
          post(conn, Routes.host_path(conn, :create), host: @create_attrs),
          get(conn, Routes.host_path(conn, :edit, host)),
          put(conn, Routes.host_path(conn, :update, host),
            host: @update_attrs
          ),
          delete(conn, Routes.host_path(conn, :delete, host))
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
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end
    # setup [:create_host]

    test "all requests return forbidden", %{conn: conn, host: host} do
      Enum.each(
        [
          get(conn, Routes.host_path(conn, :index)),
          get(conn, Routes.host_path(conn, :new)),
          post(conn, Routes.host_path(conn, :create), host: @create_attrs),
          get(conn, Routes.host_path(conn, :edit, host)),
          put(conn, Routes.host_path(conn, :update, host),
            host: @update_attrs
          ),
          delete(conn, Routes.host_path(conn, :delete, host))
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

    test "lists all hosts", %{conn: conn} do
      conn = get(conn, Routes.host_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hosts"
    end
  end

  describe "when superuser index" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all hosts", %{conn: conn} do
      conn = get(conn, Routes.host_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Hosts"
    end
  end

  describe "when admin new host" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.host_path(conn, :new))
      assert html_response(conn, 200) =~ "New Host"
    end
  end

  describe "when superuser new host" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.host_path(conn, :new))
      assert html_response(conn, 200) =~ "New Host"
    end
  end

  describe "when admin create host" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.host_path(conn, :create), host: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.host_path(conn, :show, id)

      conn = get(conn, Routes.host_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Host"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.host_path(conn, :create), host: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Host"
    end
  end

  describe "when superuser create host" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.host_path(conn, :create), host: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.host_path(conn, :show, id)

      conn = get(conn, Routes.host_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Host"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.host_path(conn, :create), host: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Host"
    end
  end

  describe "when admin edit host" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "renders form for editing chosen host", %{
      conn: conn,
      host: host
    } do
      conn = get(conn, Routes.host_path(conn, :edit, host))
      assert html_response(conn, 200) =~ "Edit Host"
    end
  end

  describe "when superuser edit host" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "renders form for editing chosen host", %{
      conn: conn,
      host: host
    } do
      conn = get(conn, Routes.host_path(conn, :edit, host))
      assert html_response(conn, 200) =~ "Edit Host"
    end
  end

  describe "when admin update host" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, host: host} do
      conn =
        put(conn, Routes.host_path(conn, :update, host),
          host: @update_attrs
        )

      assert redirected_to(conn) == Routes.host_path(conn, :show, host)

      conn = get(conn, Routes.host_path(conn, :show, host))
      assert html_response(conn, 200) =~ "some updated common_name"
    end

    test "renders errors when data is invalid", %{conn: conn, host: host} do
      conn =
        put(conn, Routes.host_path(conn, :update, host),
          host: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Host"
    end
  end

  describe "when superuser update host" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, host: host} do
      conn =
        put(conn, Routes.host_path(conn, :update, host),
          host: @update_attrs
        )

      assert redirected_to(conn) == Routes.host_path(conn, :show, host)

      conn = get(conn, Routes.host_path(conn, :show, host))
      assert html_response(conn, 200) =~ "some updated common_name"
    end

    test "renders errors when data is invalid", %{conn: conn, host: host} do
      conn =
        put(conn, Routes.host_path(conn, :update, host),
          host: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Host"
    end
  end

  describe "when admin delete host" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "returns unauthorized", %{conn: conn, host: host} do
      conn = delete(conn, Routes.host_path(conn, :delete, host))
      assert html_response(conn, 403) =~ "Forbidden"
      conn = get(conn, Routes.host_path(conn, :show, host))
      assert html_response(conn, 200) =~ "Show Host"
    end
  end

  describe "when superuser delete host" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), host: host_fixture()}
    end

    test "deletes chosen host", %{conn: conn, host: host} do
      conn = delete(conn, Routes.host_path(conn, :delete, host))
      assert redirected_to(conn) == Routes.host_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.host_path(conn, :show, host))
      end
    end
  end

  defp create_host(_) do
    host = host_fixture()
    %{host: host}
  end
end
