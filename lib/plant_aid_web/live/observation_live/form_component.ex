# defmodule PlantAidWeb.ObservationLive.FormComponent do
#   use PlantAidWeb, :live_component

#   alias PlantAid.Admin
#   alias PlantAid.ObjectStorage
#   alias PlantAid.Observations
#   alias PlantAid.Observations.{Observation, Submission}

#   @impl true
#   def update(%{observation: observation} = assigns, socket) do
#     changeset = Observations.change_submission(observation)
#     location_types = Admin.list_location_types()
#     pathologies = Admin.list_pathologies()
#     hosts = Admin.list_hosts()
#     selected_host = get_selected_host(changeset, hosts)

#     {:ok,
#      socket
#      |> assign(assigns)
#      |> assign(%{
#        changeset: changeset,
#        location_types: location_types,
#        pathologies: pathologies,
#        hosts: hosts,
#        selected_host: selected_host
#      })
#      |> allow_upload(:image,
#        accept: ~w(.jpg .jpeg .png),
#        max_entries: 3,
#        external: &presign_upload/2
#      )
#      |> allow_upload(:lamp_initial_image,
#        accept: ~w(.jpg .jpeg .png),
#        max_entries: 3,
#        external: &presign_upload/2
#      )
#      |> allow_upload(:lamp_final_image,
#        accept: ~w(.jpg .jpeg .png),
#        max_entries: 3,
#        external: &presign_upload/2
#      )
#      |> allow_upload(:voc_result_image,
#        accept: ~w(.jpg .jpeg .png),
#        max_entries: 3,
#        external: &presign_upload/2
#      )}
#   end

#   @impl true
#   def handle_event("validate", %{"submission" => submission_params}, socket) do
#     changeset =
#       socket.assigns.observation
#       |> Observations.change_submission(submission_params)
#       |> Map.put(:action, :validate)

#     selected_host = get_selected_host(changeset, socket.assigns.hosts)

#     {:noreply, assign(socket, changeset: changeset, selected_host: selected_host)}
#   end

#   def handle_event("save", %{"submission" => submission_params}, socket) do
#     # uploaded_files =
#     #   consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
#     #     dest = Path.join([:code.priv_dir(:plant_aid), "static", "uploads", Path.basename(path)])
#     #     # The `static/uploads` directory must exist for `File.cp!/2` to work.
#     #     File.cp!(path, dest)
#     #     {:ok, Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")}
#     #   end)
#     # IO.inspect(uploaded_files, label: "uploaded files")
#     save_observation(socket, socket.assigns.action, submission_params)
#   end

#   def handle_event("cancel-upload", %{"ref" => ref}, socket) do
#     {:noreply, cancel_upload(socket, :image, ref)}
#   end

#   def error_to_string(:too_large), do: "Too large"
#   def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
#   def error_to_string(:too_many_files), do: "You have selected too many files"

#   defp save_observation(socket, :edit, observation_params) do
#     case Observations.update_observation(socket.assigns.observation, observation_params) do
#       {:ok, _observation} ->
#         {:noreply,
#          socket
#          |> put_flash(:info, "Observation updated successfully")
#          |> push_redirect(to: socket.assigns.return_to)}

#       {:error, %Ecto.Changeset{} = changeset} ->
#         {:noreply, assign(socket, :changeset, changeset)}
#     end
#   end

#   defp save_observation(socket, :new, submission_params) do
#     submission =
#       %Submission{user_id: socket.assigns.current_user.id}
#       |> put_upload_urls(socket)

#     case Observations.create_observation(
#            submission,
#            submission_params,
#            &consume_images(socket, &1)
#          ) do
#       {:ok, _observation} ->
#         {:noreply,
#          socket
#          |> put_flash(:info, "Observation created successfully")
#          |> push_redirect(to: socket.assigns.return_to)}

#       {:error, %Ecto.Changeset{} = changeset} ->
#         {:noreply, assign(socket, changeset: changeset)}
#     end
#   end

#   defp get_selected_host(changeset, hosts) do
#     with host_id <- Ecto.Changeset.get_field(changeset, :host_id) do
#       Enum.find(hosts, fn h -> h.id == host_id end) || List.first(hosts)
#     end
#   end

#   defp put_upload_urls(%Submission{} = submission, socket) do
#     submission
#     |> put_upload_urls(socket, :image, :image_urls)
#     |> put_upload_urls(socket, :lamp_initial_image, :lamp_initial_image_urls)
#     |> put_upload_urls(socket, :lamp_final_image, :lamp_final_image_urls)
#     |> put_upload_urls(socket, :voc_result_image, :voc_result_image_urls)
#   end

#   defp put_upload_urls(%Submission{} = submission, socket, upload_key, submission_key) do
#     {completed, []} = uploaded_entries(socket, upload_key)

#     if length(completed) > 0 do
#       urls =
#         for entry <- completed do
#           Path.join("https://padb-dev.nyc3.digitaloceanspaces.com", "images/#{entry.uuid}.jpg")
#         end

#       Map.put(submission, submission_key, urls)
#     else
#       submission
#     end
#   end

#   defp consume_images(socket, %Observation{} = observation) do
#     consume_uploaded_entries(socket, :image, fn _meta, _entry -> {:ok} end)
#     {:ok, observation}
#   end

#   defp presign_upload(entry, socket) do
#     IO.inspect(entry, label: "entry")
#     uploads = socket.assigns.uploads
#     bucket = "padb-dev"
#     key = "images/#{entry.uuid}.jpg"

#     config = %{
#       region: "nyc3",
#       access_key_id: "ZR6PEDAAMOG2OA3SBROV",
#       secret_access_key: "8qKs26/6vXFBCs1ykraocsJ46fwCA5h5LExdIkiW0l4"
#     }

#     {:ok, fields} =
#       ObjectStorage.sign_form_upload(config, bucket,
#         key: key,
#         content_type: entry.client_type,
#         max_file_size: uploads[entry.upload_config].max_file_size,
#         expires_in: :timer.hours(1)
#       )

#     meta = %{
#       uploader: "S3",
#       key: key,
#       url: "https://padb-dev.nyc3.digitaloceanspaces.com",
#       fields: fields
#     }

#     {:ok, meta, socket}
#   end
# end
