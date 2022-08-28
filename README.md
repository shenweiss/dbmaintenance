# dbmaintenance
mongodb matlab tools for adding hfos, spikes, electrodes, neuroanatomic data, and clinical metadata

These Matlab functions are designed to add the output of HFO Engine/EZ-Detect to MongoDB for subsequent analysis. In addition edit_ezpac.m uses the XML files from
Micromed Brainquick to delete false positive detections from the automated detector prior to adding the entries to the database. Other functions are used to add 
neuroanatomic data to the HFO, spike, and electrode entries. 

Base functions 
edit_ezpac.m : Removes false positive event detections from the "edited" XML file from Micromed Brainquick. 
upload_ezpac_mongo.m : Uploads the ezpac files to the MongoDB
edit_mongoni.m : Prerequisite step to adding neuroimaging data
existingmen.m : Modify resected or SOZ data in existing entries
add_mongoni.m : Adds neuroimaging coordinates and structures to the HFO, spike, and electrode entries in the MongoDB.
rate_table.m : Calculate table of rates based on existing entries.
