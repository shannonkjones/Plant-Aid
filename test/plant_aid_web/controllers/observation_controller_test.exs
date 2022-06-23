defmodule PlantAidWeb.ObservationControllerTest do
  use PlantAidWeb.ConnCase

  import PlantAid.ObservationsFixtures

  @create_attrs %{control_method: "some control_method", coordinates: "some coordinates", host_other: "some host_other", notes: "some notes", observation_date: ~U[2022-06-16 00:10:00Z], organic: true}
  @update_attrs %{control_method: "some updated control_method", coordinates: "some updated coordinates", host_other: "some updated host_other", notes: "some updated notes", observation_date: ~U[2022-06-17 00:10:00Z], organic: false}
  @invalid_attrs %{control_method: nil, coordinates: nil, host_other: nil, notes: nil, observation_date: nil, organic: nil}

  describe "index" do
    test "lists all observations", %{conn: conn} do
      conn = get(conn, Routes.observation_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Observations"
    end
  end

  describe "new observation" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.observation_path(conn, :new))
      assert html_response(conn, 200) =~ "New Observation"
    end
  end

  describe "create observation" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.observation_path(conn, :create), observation: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.observation_path(conn, :show, id)

      conn = get(conn, Routes.observation_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Observation"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.observation_path(conn, :create), observation: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Observation"
    end
  end

  describe "edit observation" do
    setup [:create_observation]

    test "renders form for editing chosen observation", %{conn: conn, observation: observation} do
      conn = get(conn, Routes.observation_path(conn, :edit, observation))
      assert html_response(conn, 200) =~ "Edit Observation"
    end
  end

  describe "update observation" do
    setup [:create_observation]

    test "redirects when data is valid", %{conn: conn, observation: observation} do
      conn = put(conn, Routes.observation_path(conn, :update, observation), observation: @update_attrs)
      assert redirected_to(conn) == Routes.observation_path(conn, :show, observation)

      conn = get(conn, Routes.observation_path(conn, :show, observation))
      assert html_response(conn, 200) =~ "some updated control_method"
    end

    test "renders errors when data is invalid", %{conn: conn, observation: observation} do
      conn = put(conn, Routes.observation_path(conn, :update, observation), observation: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Observation"
    end
  end

  describe "delete observation" do
    setup [:create_observation]

    test "deletes chosen observation", %{conn: conn, observation: observation} do
      conn = delete(conn, Routes.observation_path(conn, :delete, observation))
      assert redirected_to(conn) == Routes.observation_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.observation_path(conn, :show, observation))
      end
    end
  end

  defp create_observation(_) do
    observation = observation_fixture()
    %{observation: observation}
  end
end
