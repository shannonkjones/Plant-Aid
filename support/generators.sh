#!/bin/sh
mix phx.gen.auth Accounts User users

mix phx.gen.html ResearchAdmin LocationType location_types name
mix phx.gen.html ResearchAdmin County counties name state # Is state from a list? If so do we need a state table or some kind of configurable list? Puerto Rico is probably only a matter of time
mix phx.gen.html ResearchAdmin Host hosts name metadata:map # Threw a metadata map (JSONB) in as a catch all, can be changed/supplemented/removed
mix phx.gen.html ResearchAdmin HostVariety host_varieties host_id:references:hosts name metadata:map # Does this really have no relationship with host? Seems like it ought to? Same note on metadata
mix phx.gen.html ResearchAdmin Pathology pathologies name

# Note: arguably we should use phx.gen.json for one or more of the following, or perhaps just phx.gen.schema for some of the "children"
# Added _id to fields since I think that's a phoenix-ism and by having that it will make automatically populating the models later easier; can be changed if needed
# This gen in particular leaves out a couple things and makes several assumptions
mix phx.gen.html Observations Observation observations user_id:references:users observation_date:utc_datetime coordinates:string county_id:references:counties location_type_id:references:location_types organic:boolean suspected_pathology_id:references:pathologies control_method:string host_id:references:hosts host_other:string host_variety_id:references:host_varieties notes:string
mix phx.gen.html Observations Image images observation_id:references:observations file_location:string metadata:map # Need to pin down exactly what we're doing with images; if S3 we need a url or key of some kind pointing to it

# I have just, lots of questions here, this probably needs a fair bit of work
mix phx.gen.html Tests Test tests observation_id:references:observations pathology_id:references:pathologies disease_present:boolean
mix phx.gen.html Tests PCRDetails pcr_details test_id:references:tests mating_type:string gpi mef genotype:string status:string
mix phx.gen.html Tests VOCDetails voc_details test_id:references:tests qr_info:map result_image status
mix phx.gen.html Tests Immunoassay immunoassays test_id:references:tests result_image status
# Does a Lamp Cell really have multiple Lamp details given the Lamp details already has the 1 and 60 minute images?
# Is there a relationship between the 1 and 60 minute images and the images table? Is everything living in S3?
mix phx.gen.html Tests LampCell lamp_cells cell_number:integer test_id:references:tests
mix phx.gen.html Tests LampDetails lamp_details lamp_cell_id:references:lamp_cells qr_info:map one_minute_image:string sixty_minute_image:string status:string

# What is the story on Research Plot?
mix phx.gen.html ResearchPlotDetails ResearchPlotDetails research_plot_details observation_id:references:observations treatment:string block:string plant_identifier:string