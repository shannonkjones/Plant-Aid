defmodule PlantAidWeb.ObservationLiveTest do
  use PlantAidWeb.ConnCase

  import Phoenix.LiveViewTest
  import PlantAid.ObservationsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_observation(_) do
    observation = observation_fixture()
    %{observation: observation}
  end

  describe "Index" do
    setup [:create_observation]

    test "lists all observations", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.observation_index_path(conn, :index))

      assert html =~ "Listing Observations"
    end

    test "saves new observation", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.observation_index_path(conn, :index))

      assert index_live |> element("a", "New Observation") |> render_click() =~
               "New Observation"

      assert_patch(index_live, Routes.observation_index_path(conn, :new))

      assert index_live
             |> form("#observation-form", observation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#observation-form", observation: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.observation_index_path(conn, :index))

      assert html =~ "Observation created successfully"
    end

    test "updates observation in listing", %{conn: conn, observation: observation} do
      {:ok, index_live, _html} = live(conn, Routes.observation_index_path(conn, :index))

      assert index_live |> element("#observation-#{observation.id} a", "Edit") |> render_click() =~
               "Edit Observation"

      assert_patch(index_live, Routes.observation_index_path(conn, :edit, observation))

      assert index_live
             |> form("#observation-form", observation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#observation-form", observation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.observation_index_path(conn, :index))

      assert html =~ "Observation updated successfully"
    end

    test "deletes observation in listing", %{conn: conn, observation: observation} do
      {:ok, index_live, _html} = live(conn, Routes.observation_index_path(conn, :index))

      assert index_live |> element("#observation-#{observation.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#observation-#{observation.id}")
    end
  end

  describe "Show" do
    setup [:create_observation]

    test "displays observation", %{conn: conn, observation: observation} do
      {:ok, _show_live, html} = live(conn, Routes.observation_show_path(conn, :show, observation))

      assert html =~ "Show Observation"
    end

    test "updates observation within modal", %{conn: conn, observation: observation} do
      {:ok, show_live, _html} = live(conn, Routes.observation_show_path(conn, :show, observation))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Observation"

      assert_patch(show_live, Routes.observation_show_path(conn, :edit, observation))

      assert show_live
             |> form("#observation-form", observation: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#observation-form", observation: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.observation_show_path(conn, :show, observation))

      assert html =~ "Observation updated successfully"
    end
  end
end
