defmodule PlantAidWeb.PathologyControllerTest do
  use PlantAidWeb.ConnCase, async: true

  import PlantAid.AccountsFixtures
  import PlantAid.AdminFixtures

  @create_attrs %{common_name: "some common_name", scientific_name: "some scientific_name"}
  @update_attrs %{common_name: "some updated common_name", scientific_name: "some updated scientific_name"}
  @invalid_attrs %{common_name: nil, scientific_name: nil}

  describe "when unauthenticated" do
    setup [:create_pathology]

    test "all requests redirect to login", %{conn: conn, pathology: pathology} do
      Enum.each(
        [
          get(conn, Routes.pathology_path(conn, :index)),
          get(conn, Routes.pathology_path(conn, :new)),
          post(conn, Routes.pathology_path(conn, :create), pathology: @create_attrs),
          get(conn, Routes.pathology_path(conn, :edit, pathology)),
          put(conn, Routes.pathology_path(conn, :update, pathology),
            pathology: @update_attrs
          ),
          delete(conn, Routes.pathology_path(conn, :delete, pathology))
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
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end
    # setup [:create_pathology]

    test "all requests return forbidden", %{conn: conn, pathology: pathology} do
      Enum.each(
        [
          get(conn, Routes.pathology_path(conn, :index)),
          get(conn, Routes.pathology_path(conn, :new)),
          post(conn, Routes.pathology_path(conn, :create), pathology: @create_attrs),
          get(conn, Routes.pathology_path(conn, :edit, pathology)),
          put(conn, Routes.pathology_path(conn, :update, pathology),
            pathology: @update_attrs
          ),
          delete(conn, Routes.pathology_path(conn, :delete, pathology))
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

    test "lists all pathologies", %{conn: conn} do
      conn = get(conn, Routes.pathology_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pathologies"
    end
  end

  describe "when superuser index" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "lists all pathologies", %{conn: conn} do
      conn = get(conn, Routes.pathology_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Pathologies"
    end
  end

  describe "when admin new pathology" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pathology_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pathology"
    end
  end

  describe "when superuser new pathology" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.pathology_path(conn, :new))
      assert html_response(conn, 200) =~ "New Pathology"
    end
  end

  describe "when admin create pathology" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pathology_path(conn, :create), pathology: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pathology_path(conn, :show, id)

      conn = get(conn, Routes.pathology_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pathology"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pathology_path(conn, :create), pathology: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pathology"
    end
  end

  describe "when superuser create pathology" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user)}
    end

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pathology_path(conn, :create), pathology: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.pathology_path(conn, :show, id)

      conn = get(conn, Routes.pathology_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Pathology"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pathology_path(conn, :create), pathology: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Pathology"
    end
  end

  describe "when admin edit pathology" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "renders form for editing chosen pathology", %{
      conn: conn,
      pathology: pathology
    } do
      conn = get(conn, Routes.pathology_path(conn, :edit, pathology))
      assert html_response(conn, 200) =~ "Edit Pathology"
    end
  end

  describe "when superuser edit pathology" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "renders form for editing chosen pathology", %{
      conn: conn,
      pathology: pathology
    } do
      conn = get(conn, Routes.pathology_path(conn, :edit, pathology))
      assert html_response(conn, 200) =~ "Edit Pathology"
    end
  end

  describe "when admin update pathology" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, pathology: pathology} do
      conn =
        put(conn, Routes.pathology_path(conn, :update, pathology),
          pathology: @update_attrs
        )

      assert redirected_to(conn) == Routes.pathology_path(conn, :show, pathology)

      conn = get(conn, Routes.pathology_path(conn, :show, pathology))
      assert html_response(conn, 200) =~ "some updated common_name"
    end

    test "renders errors when data is invalid", %{conn: conn, pathology: pathology} do
      conn =
        put(conn, Routes.pathology_path(conn, :update, pathology),
          pathology: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Pathology"
    end
  end

  describe "when superuser update pathology" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "redirects when data is valid", %{conn: conn, pathology: pathology} do
      conn =
        put(conn, Routes.pathology_path(conn, :update, pathology),
          pathology: @update_attrs
        )

      assert redirected_to(conn) == Routes.pathology_path(conn, :show, pathology)

      conn = get(conn, Routes.pathology_path(conn, :show, pathology))
      assert html_response(conn, 200) =~ "some updated common_name"
    end

    test "renders errors when data is invalid", %{conn: conn, pathology: pathology} do
      conn =
        put(conn, Routes.pathology_path(conn, :update, pathology),
          pathology: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Pathology"
    end
  end

  describe "when admin delete pathology" do
    setup context do
      user = user_fixture(%{roles: [:admin]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "returns unauthorized", %{conn: conn, pathology: pathology} do
      conn = delete(conn, Routes.pathology_path(conn, :delete, pathology))
      assert html_response(conn, 403) =~ "Forbidden"
      conn = get(conn, Routes.pathology_path(conn, :show, pathology))
      assert html_response(conn, 200) =~ "Show Pathology"
    end
  end

  describe "when superuser delete pathology" do
    setup context do
      user = user_fixture(%{roles: [:superuser]})
      %{conn: log_in_user(context.conn, user), pathology: pathology_fixture()}
    end

    test "deletes chosen pathology", %{conn: conn, pathology: pathology} do
      conn = delete(conn, Routes.pathology_path(conn, :delete, pathology))
      assert redirected_to(conn) == Routes.pathology_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.pathology_path(conn, :show, pathology))
      end
    end
  end

  defp create_pathology(_) do
    pathology = pathology_fixture()
    %{pathology: pathology}
  end
end
