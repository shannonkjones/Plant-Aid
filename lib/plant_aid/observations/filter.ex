defmodule PlantAid.Observations.Filter do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :user_id, :id
    field :host_ids, {:array, :id}
    field :host_variety_ids, {:array, :id}
    field :location_type_ids, {:array, :id}
    field :suspected_pathology_ids, {:array, :id}
    field :county_ids, {:array, :id}

    field :states, {:array, :string}
    field :control_method, :string
    field :host_other, :string
    field :notes, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :organic, :boolean
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [
      :start_date,
      :end_date,
      :states,
      :organic,
      :control_method,
      :host_other,
      :notes,
      :location_type_ids,
      :suspected_pathology_ids,
      :host_ids,
      :host_variety_ids,
      :county_ids,
      :user_id
    ])
  end
end
