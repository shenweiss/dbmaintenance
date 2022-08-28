%collection = "EZDETECT_TESTCONTACTS";
function mongo_upload_electrodes(conn,fname,orig_fname,patient_id,user_file_block)
load(fname)
collection = "Electrodes";
f=figure;
t = uitable(f);
fprintf('uploading channel data \r')
fprintf('make your soz assignments and hit enter \r')
chanlist=metadata.montage(:,1);
exclude= metadata.montage(:,4);
soz= num2cell(false(numel(chanlist),1));
tdata={''};
tdata=[chanlist'; exclude'; soz';];
t.Data=tdata';
t.ColumnName={'channame', 'exclude', 'soz';};
t.ColumnEditable = true;
set(t,'ColumnWidth',{80,30,30})
pause;
pause;
pause;
excluded=t.Data;
excluded=cell2mat(t.Data(:,2));
soz=cell2mat(t.Data(:,3));

for i=1:numel(metadata.montage(:,1))
if (cell2mat(metadata.montage(i,4))~=1)
e.patient_id=patient_id;
e.orig_fname=orig_fname;
e.file_id=metadata.file_id;
e.file_block=user_file_block;
e.electrode=metadata.montage(i,1);
e.soz=num2str(soz(i));
e.loc1='empty';
e.loc2='empty';
e.loc3='empty';
e.loc4='empty';
e.loc5='empty';
e.resected='-1';
e.x='-1'
e.y='-1'
e.z='-1'
e.age='empty';
e.gender='empty';
e.race='empty';
e.handedness='empty';
e.riskfactor1='empty';
e.riskfactor2='empty';
e.riskfactor3='empty';
e.dxduration='empty';
e.aura1='empty';
e.aura2='empty';
e.aura3='empty';
e.sztype1='empty';
e.sztype2='empty';
e.sztype3='empty';
e.szfreq1='empty';
e.szfreq2='empty';
e.szfreq3='empty';
e.szSE='empty';
e.education='empty';
e.dominance='empty';
e.pipsychosis='empty';
e.mri1='empty';
e.mri2='empty';
e.mri3='empty';
e.pet1='empty';
e.pet2='empty';
e.pet3='empty';
e.aed1='empty';
e.aed2='empty';
e.aed3='empty';
e.aed4='empty';
e.anesthesia1='empty';
e.anesthesia2='empty';
e.anesthesia3='empty';
e.sxcode='empty';
e.pathcode1='empty';
e.pathcode2='empty';
e.outcome='empty';
e.outcome_mo='empty';
e.t_firstsz='empty';
e.postaed1='empty';
e.postaed2='empty';
e.postaed3='empty';
e.repeatsx='empty';
e.repeatsx_tju='empty';
n= insert(conn, collection, e);
end;
end;
