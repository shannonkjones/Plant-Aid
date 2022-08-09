#!/bin/sh
mix phx.gen.auth Accounts User users

mix phx.gen.html Admin LocationType location_types name
mix phx.gen.html Admin County counties name state
mix phx.gen.html Admin Pathology pathologies common_name scientific_name
mix phx.gen.html Admin Host hosts common_name scientific_name
mix phx.gen.html Admin HostVariety host_varieties host_id:references:hosts name

# Note: arguably we should use phx.gen.json for one or more of the following, or perhaps just phx.gen.schema for some of the "children"
# Added _id to fields since I think that's a phoenix-ism and by having that it will make automatically populating the models later easier; can be changed if needed
# This gen in particular leaves out a couple things and makes several assumptions
mix phx.gen.html Observations Observation observations user_id:references:users observation_date:utc_datetime coordinates:string county_id:references:counties location_type_id:references:location_types organic:boolean suspected_pathology_id:references:pathologies control_method:string host_id:references:hosts host_other:string host_variety_id:references:host_varieties notes:string
mix phx.gen.html Observations Image images observation_id:references:observations file_location:string metadata:map # Need to pin down exactly what we're doing with images; if S3 we need a url or key of some kind pointing to it

# I have just, lots of questions here, this probably needs a fair bit of work
mix phx.gen.html Tests Test tests observation_id:references:observations pathology_id:references:pathologies disease_present:boolean
mix phx.gen.html Tests PCRDetails pcr_details test_id:references:tests mating_type:string gpi mef genotype:string status:string
mix phx.gen.schema Tests.VOCDetails voc_details status:string disease_presence:float qr_info:string result_image_urls:array:string observation_id:references:observations pathology_id:references:pathologies
mix phx.gen.html Tests Immunoassay immunoassays test_id:references:tests result_image status
# Does a Lamp Cell really have multiple Lamp details given the Lamp details already has the 1 and 60 minute images?
# Is there a relationship between the 1 and 60 minute images and the images table? Is everything living in S3?
mix phx.gen.schema Tests.LAMPCell lamp_cells cell_number:integer disease_presence:float lamp_details_id:references:lamp_details observation_id:references:observations pathology_id:references:pathologies
mix phx.gen.schema Tests.LAMPDetails lamp_details qr_info:string initial_image_urls:array:string final_image_urls:string status:string interpretted_results:map observation_id:references:observations

# What is the story on Research Plot?
mix phx.gen.schema Observations.ResearchPlotDetails research_plot_details observation_id:references:observations treatment:string block:string plant_id:string