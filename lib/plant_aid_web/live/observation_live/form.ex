defmodule PlantAidWeb.ObservationLive.Form do
  use PlantAidWeb, :live_view

  alias PlantAid.Accounts
  alias PlantAid.Admin
  alias PlantAid.ObjectStorage
  alias PlantAid.Observations
  alias PlantAid.Observations.Observation
  alias PlantAid.Diagnostics.{LAMPDetails, VOCDetails}

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    location_types = Admin.list_location_types()
    pathologies = Admin.list_pathologies()
    hosts = Admin.list_hosts()

    {:ok,
     socket
     |> assign(:current_user, user)
     |> assign(:location_types, location_types)
     |> assign(:pathologies, pathologies)
     |> assign(:hosts, hosts)
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 10,
       external: &presign_upload/2
     )
     |> allow_upload(:lamp_initial_image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 10,
       external: &presign_upload/2
     )
     |> allow_upload(:lamp_final_image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 10,
       external: &presign_upload/2
     )
     |> allow_upload(:voc_result_image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 10,
       external: &presign_upload/2
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> apply_action(socket.assigns.live_action, params)
     |> assign_remaining}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    observation = Observations.get_observation!(id)

    socket
    |> assign(:observation, observation)
  end

  defp apply_action(socket, :new, _) do
    socket
    |> assign(:observation, %Observation{user: socket.assigns.current_user, lamp_details: nil, voc_details: nil})
  end

  defp assign_remaining(socket) do
    changeset = Observations.change_observation(socket.assigns.observation)
    selected_host = get_selected_host(changeset, socket.assigns.hosts)
    research_plot? = research_plot?(changeset, socket.assigns.location_types)

    socket
    |> assign(:changeset, changeset)
    |> assign(:selected_host, selected_host)
    |> assign(:research_plot?, research_plot?)
    |> assign(:page_title, page_title(socket.assigns.live_action))
  end

  @impl true
  def handle_event("validate", %{"observation" => observation_params}, socket) do
    changeset =
      socket.assigns.observation
      |> Observations.change_observation(observation_params)
      |> Map.put(:action, :validate)

    selected_host = get_selected_host(changeset, socket.assigns.hosts)
    research_plot? = research_plot?(changeset, socket.assigns.location_types)

    {:noreply,
     socket
     |> assign(:changeset, changeset)
     |> assign(:selected_host, selected_host)
     |> assign(:research_plot?, research_plot?)}
  end

  def handle_event("save", %{"observation" => observation_params}, socket) do
    save_observation(socket, socket.assigns.live_action, observation_params)
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  def handle_event(
        "current_position",
        %{"latitude" => latitude, "longitude" => longitude},
        socket
      ) do
    changeset =
      socket.assigns.changeset
      |> Ecto.Changeset.put_change(:latitude, latitude)
      |> Ecto.Changeset.put_change(:longitude, longitude)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("current_position_error", %{"message" => message}, socket) do
    {:noreply,
     put_flash(
       socket,
       :error,
       "Error getting current position: '#{message}'. Refreshing may fix this."
     )}
  end

  defp save_observation(socket, :edit, observation_params) do
    observation_params = put_upload_urls(observation_params, socket)

    case Observations.update_observation(
           socket.assigns.observation,
           observation_params,
           &consume_images(socket, &1)
         ) do
      {:ok, observation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Observation updated successfully")
         |> push_redirect(to: Routes.observation_show_path(socket, :show, observation))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_observation(socket, :new, observation_params) do
    observation_params = put_upload_urls(observation_params, socket)

    case Observations.create_observation(
           socket.assigns.observation,
           observation_params,
           &consume_images(socket, &1)
         ) do
      {:ok, observation} ->
        {:noreply,
         socket
         |> put_flash(:info, "Observation created successfully")
         |> push_redirect(to: Routes.observation_show_path(socket, :show, observation))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_selected_host(changeset, hosts) do
    with host_id <- Ecto.Changeset.get_field(changeset, :host_id) do
      Enum.find(hosts, fn h -> h.id == host_id end) || List.first(hosts)
    end
  end

  defp research_plot?(changeset, location_types) do
    with location_type_id <- Ecto.Changeset.get_field(changeset, :location_type_id) do
      location_type =
        Enum.find(location_types, fn lt -> lt.id == location_type_id end) ||
          List.first(location_types)

      location_type && location_type.name == "Research plot"
    end
  end

  defp page_title(:new), do: "Create Observation"
  defp page_title(:edit), do: "Edit Observation"

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  def error_to_string(:too_many_files), do: "You have selected too many files"

  defp put_upload_urls(%{} = observation_params, socket) do
    observation_params
    |> put_image_urls(socket)
    |> put_lamp_details(socket)
    |> put_voc_details(socket)
  end

  defp put_image_urls(observation_params, socket) do
    new_urls = get_upload_urls(socket, :image)

    if length(new_urls) > 0 do
      Map.put(
        observation_params,
        "image_urls",
        Enum.concat(socket.assigns.observation.image_urls, new_urls)
      )
    else
      observation_params
    end
  end

  defp put_lamp_details(%{} = observation_params, socket) do
    new_initial_image_urls = get_upload_urls(socket, :lamp_initial_image)
    new_final_image_urls = get_upload_urls(socket, :lamp_final_image)

    if length(new_initial_image_urls) > 0 or length(new_final_image_urls) > 0 do
      lamp_details = socket.assigns.observation.lamp_details || %LAMPDetails{}

      lamp_details_params = %{
        "id" => lamp_details.id,
        "initial_image_urls" =>
          Enum.concat(lamp_details.initial_image_urls, new_initial_image_urls),
        "final_image_urls" => Enum.concat(lamp_details.final_image_urls, new_final_image_urls)
      }

      Map.put(observation_params, "lamp_details", lamp_details_params)
    else
      observation_params
    end
  end

  defp put_voc_details(%{} = observation_params, socket) do
    new_result_image_urls = get_upload_urls(socket, :voc_result_image)

    if length(new_result_image_urls) > 0 do
      voc_details = socket.assigns.observation.voc_details || %VOCDetails{}

      voc_details_params = %{
        "id" => voc_details.id,
        "result_image_urls" =>
          Enum.concat(voc_details.result_image_urls, new_result_image_urls),
      }

      Map.put(observation_params, "voc_details", voc_details_params)
    else
      observation_params
    end
  end

  defp get_upload_urls(socket, upload_key) do
    {completed, []} = uploaded_entries(socket, upload_key)

    for entry <- completed do
      Path.join(object_storage_base_url(), object_storage_key(entry))
    end
  end

  defp consume_images(socket, %Observation{} = observation) do
    consume_uploaded_entries(socket, :image, fn _meta, _entry -> {:ok, nil} end)
    {:ok, observation}
  end

  defp presign_upload(entry, socket) do
    config = Application.get_env(:plant_aid, PlantAid.ObjectStorage)
    uploads = socket.assigns.uploads
    bucket = config[:bucket]

    config = %{
      region: config[:region],
      access_key_id: config[:access_key_id],
      secret_access_key: config[:secret_access_key]
    }

    {:ok, fields} =
      ObjectStorage.sign_form_upload(config, bucket,
        key: object_storage_key(entry),
        content_type: entry.client_type,
        max_file_size: uploads[entry.upload_config].max_file_size,
        expires_in: :timer.hours(24)
      )

    meta = %{
      uploader: "S3",
      key: object_storage_key(entry),
      url: object_storage_base_url(),
      fields: fields
    }

    {:ok, meta, socket}
  end

  defp object_storage_base_url do
    config = Application.get_env(:plant_aid, PlantAid.ObjectStorage)
    "https://#{config[:bucket]}.#{config[:region]}.#{config[:domain]}"
  end

  defp object_storage_key(entry) do
    "images/#{entry.uuid}.#{extension(entry)}"
  end

  defp extension(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end
end
