% Example script for uploading the EZPAC out files to a MongoDB.
% The MongoDB should have two collections. One collection is for
% the HFO entries, the other collection is for the electrode contact
% name entries. The reason you need both is that it may not be possible
% to reconstruct all the analyzed channels by HFO occurrences alone. 
% If you need to use the HFO entries to build an ROC curve, for instance,
% you will also need to know the analyzed channels that had no HFO
% occurrences.

% I have listed a number of sample fields that I use in my MongoDB (see 
% mongo_upload_hfos.m and mongo_upload_electrodes.m) I recommend 
% uploading the HFOs with these sample fields created but empty.
% To add neuroimaging data to the HFOs and Electrode databases you can 
% download the appropriate entries from the HFO and Electrode databases
% and then overwrite the empty entries with the neuroimaging data. 
% Then reupload the modified entries to your database (be sure to delete
% the original entries in the DB or you will make duplicates!!!).

% eeg_name: this refers to the EZPAC out .mat files. For example for 
% file EEG_32_mp_1.mat the eeg_name='EEG_32'

% orig_fname: is the original EDF/TRC/etc file that all the file was
% derived from. As noted in the user's manual if you split a file in two
% because the channel number exceeded 128 the analysis can still be
% reconstituted in the MongoDB under the orig_fname entry.

% patient_id: this is also an essential entry since Brain Quick removes
% identifying information, and a new entry is required. 
%
% blocks: refers to the number of EZPAC blocks of data
%
% ref: specifies the montages of the EZPAC out files. ref=0 is 
% referential only, ref=1 is bipolar only, ref=2 is both ref and 
% bipolar. 

% NOTE IF YOU ARE USING EZ PAC OUT FILES AFTER REDACTIONS THEY WILL NEED TO
% BE RENAMED BY REMOVING THE TERMINAL "c" BEFORE .mat

function upload_ezpac_mongo(eeg_name, orig_fname,patient_id,blocks,ref)

% connect to your MongoDB
server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);

if ref == 0
    for i=1:blocks
        ref=0;
        fname=[eeg_name '_mp_' num2str(i) '.mat'];
        mongo_upload_hfos(conn,fname,orig_fname,patient_id,ref)
        mongo_upload_electrodes(conn,fname,orig_fname,patient_id)
    end;
end;

if ref == 1
    for i=1:blocks
        ref=1;
        fname=[eeg_name '_bp_' num2str(i) '.mat'];
        mongo_upload_hfos(conn,fname,orig_fname,patient_id,ref)
        mongo_upload_electrodes(conn,fname,orig_fname,patient_id)
    end;
end;

if ref == 2
    for i=1:blocks
        ref=0;
        fname=[eeg_name '_mp_' num2str(i) '.mat'];
        mongo_upload_hfos(conn,fname,orig_fname,patient_id,ref)
        mongo_upload_electrodes(conn,fname,orig_fname,patient_id)
        ref=1;
        fname=[eeg_name '_bp_' num2str(i) '.mat'];
        mongo_upload_hfos(conn,fname,orig_fname,patient_id,ref)
    end
end;
close(conn)

