defmodule PlantAidWeb.PageControllerTest do
  use PlantAidWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Plant Aid!"
  end
end
