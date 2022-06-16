# TODO: implement!

# defmodule PlantAidWeb.HostVarietyControllerTest do
#   use PlantAidWeb.ConnCase

#   import PlantAid.AdminFixtures

#   @create_attrs %{name: "some name"}
#   @update_attrs %{name: "some updated name"}
#   @invalid_attrs %{name: nil}

#   describe "index" do
#     test "lists all host_varieties", %{conn: conn} do
#       conn = get(conn, Routes.host_variety_path(conn, :index))
#       assert html_response(conn, 200) =~ "Listing Host varieties"
#     end
#   end

#   describe "new host_variety" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, Routes.host_variety_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Host variety"
#     end
#   end

#   describe "create host_variety" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.host_variety_path(conn, :create), host_variety: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.host_variety_path(conn, :show, id)

#       conn = get(conn, Routes.host_variety_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Host variety"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.host_variety_path(conn, :create), host_variety: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Host variety"
#     end
#   end

#   describe "edit host_variety" do
#     setup [:create_host_variety]

#     test "renders form for editing chosen host_variety", %{conn: conn, host_variety: host_variety} do
#       conn = get(conn, Routes.host_variety_path(conn, :edit, host_variety))
#       assert html_response(conn, 200) =~ "Edit Host variety"
#     end
#   end

#   describe "update host_variety" do
#     setup [:create_host_variety]

#     test "redirects when data is valid", %{conn: conn, host_variety: host_variety} do
#       conn = put(conn, Routes.host_variety_path(conn, :update, host_variety), host_variety: @update_attrs)
#       assert redirected_to(conn) == Routes.host_variety_path(conn, :show, host_variety)

#       conn = get(conn, Routes.host_variety_path(conn, :show, host_variety))
#       assert html_response(conn, 200) =~ "some updated name"
#     end

#     test "renders errors when data is invalid", %{conn: conn, host_variety: host_variety} do
#       conn = put(conn, Routes.host_variety_path(conn, :update, host_variety), host_variety: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Host variety"
#     end
#   end

#   describe "delete host_variety" do
#     setup [:create_host_variety]

#     test "deletes chosen host_variety", %{conn: conn, host_variety: host_variety} do
#       conn = delete(conn, Routes.host_variety_path(conn, :delete, host_variety))
#       assert redirected_to(conn) == Routes.host_variety_path(conn, :index)

#       assert_error_sent 404, fn ->
#         get(conn, Routes.host_variety_path(conn, :show, host_variety))
#       end
#     end
#   end

#   defp create_host_variety(_) do
#     host_variety = host_variety_fixture()
#     %{host_variety: host_variety}
#   end
# end
