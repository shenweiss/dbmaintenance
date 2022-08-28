function mongo_upload_hfos(conn,fname,orig_fname,patient_id,ref,user_file_block)

collection = "HFOs";
load(fname)
f=figure;
t = uitable(f);
if ref == 0
fprintf('uploading monopolar montage HFOs \r'); 
chanlist=metadata.m_chanlist';
fprintf('make your channel assignments and hit enter 5-10 time \r');
else
fprintf('uploading bipolar montage HFOs \r'); 
chanlist=metadata.bp_chanlist';
fprintf('make your channel assignments and hit enter 5-10 time \r');
end;
exclude= num2cell(false(numel(chanlist),1));
soz= num2cell(false(numel(chanlist),1));
tdata={''};
tdata=[chanlist'; exclude'; soz';];
t.Data=tdata';
t.ColumnName={'channame','exclude','soz';};
t.ColumnEditable = true;
set(t,'ColumnWidth',{80,30,30})
pause;
pause;
pause;
excluded=t.Data;
excluded=cell2mat(t.Data(:,2));
soz=cell2mat(t.Data(:,3));

fprintf('uploading! \r')
hfo.orig_fname=orig_fname;
hfo.patient_id=patient_id;
hfo.file=metadata.file_id; 
hfo.file_block=user_file_block;
hfo.r_duration=600;
hfo.fr_duration=600;
if ref == 0
hfo.montage=0;
else
hfo.montage=1;
end
hfo.loc1='empty';
hfo.loc2='empty';
hfo.loc3='empty';
hfo.loc4='empty';
hfo.loc5='empty';
hfo.resected='-1';
hfo.x='-1';
hfo.y='-1';
hfo.z='-1';
hfo.ezdetect='1.0.1';
hfo.montage='1';
hfo.age='empty';
hfo.gender='empty';
hfo.race='empty';
hfo.handedness='empty';
hfo.riskfactor1='empty';
hfo.riskfactor2='empty';
hfo.riskfactor3='empty';
hfo.dxduration='empty';
hfo.aura1='empty';
hfo.aura2='empty';
hfo.aura3='empty';
hfo.sztype1='empty';
hfo.sztype2='empty';
hfo.sztype3='empty';
hfo.szfreq1='empty';
hfo.szfreq2='empty';
hfo.szfreq3='empty';
hfo.szSE='empty';
hfo.education='empty';
hfo.dominance='empty';
hfo.pipsychosis='empty';
hfo.mri1='empty';
hfo.mri2='empty';
hfo.mri3='empty';
hfo.pet1='empty';
hfo.pet2='empty';
hfo.pet3='empty';
hfo.aed1='empty';
hfo.aed2='empty';
hfo.aed3='empty';
hfo.aed4='empty';
hfo.anesthesia1='empty';
hfo.anesthesia2='empty';
hfo.anesthesia3='empty';
hfo.sxcode='empty';
hfo.pathcode1='empty';
hfo.pathcode2='empty';
hfo.outcome='empty';
hfo.outcome_mo='empty';
hfo.t_firstsz='empty';
hfo.postaed1='empty';
hfo.postaed2='empty';
hfo.postaed3='empty';
hfo.repeatsx='empty';
hfo.repeatsx_tju='empty';

% add ripple events
% add ronos
if ~isempty(RonO.channel)
for i=1:numel(RonO.channel(:,1))
if excluded(RonO.channel(i,1))~=1 
  if ref == 0
  hfo.electrode=metadata.m_chanlist(RonO.channel(i,1));
  else
  hfo.electrode=metadata.bp_chanlist(RonO.channel(i,1));
  end;
  hfo.soz=num2str(soz(RonO.channel(i,1)));
  hfo.type='1'; %very important
  hfo.freq_av=RonO.freq_av(i);
  hfo.freq_pk=RonO.freq_pk(i);
  hfo.power_av=RonO.power_av(i);
  hfo.power_pk=RonO.power_pk(i);
  hfo.duration=RonO.duration(i);
  hfo.start_t=RonO.start_t(i);
  hfo.finish_t=RonO.finish_t(i);
  hfo.slow=RonO.slow(i);
  hfo.slow_vs=RonO.slow_vs(i);
  hfo.slow_angle=RonO.slow_angle(i);
  hfo.delta=RonO.delta(i);
  hfo.delta_vs=RonO.delta_vs(i);
  hfo.delta_angle=RonO.delta_angle(i);
  hfo.theta=RonO.theta(i);
  hfo.theta_vs=RonO.theta_vs(i);
  hfo.theta_angle=RonO.theta_angle(i);
  hfo.spindle=RonO.spindle(i);
  hfo.spindle_vs=RonO.spindle_vs(i);
  hfo.spindle_angle=RonO.spindle_angle(i);
  hfo.spike=0;
  hfo.spike_vs=0;
  hfo.spike_angle=0;
  n= insert(conn, collection, hfo);
end;
end;
end;

% add TRonS
if ~isempty(TRonS.channel)
for i=1:numel(TRonS.channel(:,1))
if excluded(TRonS.channel(i,1))~=1
  if ref == 0
  hfo.electrode=metadata.m_chanlist(TRonS.channel(i,1));
  else
  hfo.electrode=metadata.bp_chanlist(TRonS.channel(i,1));
  end;
  hfo.soz=num2str(soz(TRonS.channel(i,1)));
  hfo.type='2'; %very important
  hfo.freq_av=TRonS.freq_av(i);
  hfo.freq_pk=TRonS.freq_pk(i);
  hfo.power_av=TRonS.power_av(i);
  hfo.power_pk=TRonS.power_pk(i);
  hfo.duration=TRonS.duration(i);
  hfo.start_t=TRonS.start_t(i);
  hfo.finish_t=TRonS.finish_t(i);
  hfo.slow=0;
  hfo.slow_vs=0;
  hfo.slow_angle=0;
  hfo.delta=0;
  hfo.delta_vs=0;
  hfo.delta_angle=0;
  hfo.theta=0;
  hfo.theta_vs=0;
  hfo.theta_angle=0;
  hfo.spindle=0;
  hfo.spindle_vs=0;
  hfo.spindle_angle=0;
  hfo.spike=1;
  hfo.spike_vs=TRonS.vs(i);
  hfo.spike_angle=TRonS.angle(i);
  n= insert(conn, collection, hfo);
end;
end;
end;

% add FRonS
if exist('FRonS','var') == 1
if ~isempty(FRonS.channel)
for i=1:numel(FRonS.channel(:,1))
     if excluded(FRonS.channel(i,1))~=1 
        if ref == 0
        hfo.electrode=metadata.m_chanlist(FRonS.channel(i,1));
        else
        hfo.electrode=metadata.bp_chanlist(FRonS.channel(i,1));
        end;
        hfo.soz=num2str(soz(FRonS.channel(i,1)));
        hfo.type='3'; %very important
        hfo.freq_av=0;
        hfo.freq_pk=0;
        hfo.power_av=0;
        hfo.power_pk=0;
        hfo.duration=0;
        hfo.start_t=FRonS.start_t(i);
        hfo.finish_t=FRonS.finish_t(i);
        hfo.slow=0;
        hfo.slow_vs=0;
        hfo.slow_angle=0;
        hfo.delta=0;
        hfo.delta_vs=0;
        hfo.delta_angle=0;
        hfo.theta=0;
        hfo.theta_vs=0;
        hfo.theta_angle=0;
        hfo.spindle=0;
        hfo.spindle_vs=0;
        hfo.spindle_angle=0;
        hfo.spike=0;
        hfo.spike_vs=0;
        hfo.spike_angle=0;
        n= insert(conn, collection, hfo);
end;
end;
end;
end;

% add ftRonO
if ~isempty(ftRonO.channel)
for i=1:numel(ftRonO.channel(:,1))
if excluded(ftRonO.channel(i,1))~=1 
  if ref==0
  hfo.electrode=metadata.m_chanlist(ftRonO.channel(i,1));
  else
  hfo.electrode=metadata.bp_chanlist(ftRonO.channel(i,1));   
  end;
  hfo.soz=num2str(soz(ftRonO.channel(i,1)));
  hfo.type='4';
  hfo.freq_av=ftRonO.freq_av(i);
  hfo.freq_pk=ftRonO.freq_pk(i);
  hfo.power_av=ftRonO.power_av(i);
  hfo.power_pk=ftRonO.power_pk(i);
  hfo.duration=ftRonO.duration(i);
  hfo.start_t=ftRonO.start_t(i);
  hfo.finish_t=ftRonO.finish_t(i);
  hfo.slow=ftRonO.slow(i);
  hfo.slow_vs=ftRonO.slow_vs(i);
  hfo.slow_angle=ftRonO.slow_angle(i);
  hfo.delta=ftRonO.delta(i);
  hfo.delta_vs=ftRonO.delta_vs(i);
  hfo.delta_angle=ftRonO.delta_angle(i);
  hfo.theta=ftRonO.theta(i);
  hfo.theta_vs=ftRonO.theta_vs(i);
  hfo.theta_angle=ftRonO.theta_angle(i);
  hfo.spindle=ftRonO.spindle(i);
  hfo.spindle_vs=ftRonO.spindle_vs(i);
  hfo.spindle_angle=ftRonO.spindle_angle(i);
  hfo.spike=0;
  hfo.spike_vs=0;
  hfo.spike_angle=0;
  n= insert(conn, collection, hfo);
end;
end;
end;
% add ftTRonS
if ~isempty(ftTRonS.channel)
for i=1:numel(ftTRonS.channel(:,1))
if excluded(ftTRonS.channel(i,1))~=1 
  if ref == 0
  hfo.electrode=metadata.m_chanlist(ftTRonS.channel(i,1));
  else
  hfo.electrode=metadata.bp_chanlist(ftTRonS.channel(i,1));
  end
  hfo.soz=num2str(soz(ftTRonS.channel(i,1)));
  hfo.type='5'; 
  hfo.freq_av=ftTRonS.freq_av(i);
  hfo.freq_pk=ftTRonS.freq_pk(i);
  hfo.power_av=ftTRonS.power_av(i);
  hfo.power_pk=ftTRonS.power_pk(i);
  hfo.duration=ftTRonS.duration(i);
  hfo.start_t=ftTRonS.start_t(i);
  hfo.finish_t=ftTRonS.finish_t(i);
  hfo.slow=0;
  hfo.slow_vs=0;
  hfo.slow_angle=0;
  hfo.delta=0;
  hfo.delta_vs=0;
  hfo.delta_angle=0;
  hfo.theta=0;
  hfo.theta_vs=0;
  hfo.theta_angle=0;
  hfo.spindle=0;
  hfo.spindle_vs=0;
  hfo.spindle_angle=0;
  hfo.spike=1;
  hfo.spike_vs=ftTRonS.vs(i);
  hfo.spike_angle=ftTRonS.angle(i);
  n= insert(conn, collection, hfo);
end;
end;
end;
% add ftFRonS
if exist('ftFRonS','var') == 1
if ~isempty(ftFRonS.channel)
for i=1:numel(ftFRonS.channel(:,1))
    if excluded(ftFRonS.channel(i,1))~=1     
        if ref==0
        hfo.electrode=metadata.m_chanlist(ftFRonS.channel(i,1));
        else
        hfo.electrode=metadata.bp_chanlist(ftFRonS.channel(i,1));
        end
        hfo.soz=num2str(soz(ftFRonS.channel(i,1)));
        hfo.type='6'; 
        hfo.freq_av=0;
        hfo.freq_pk=0;
        hfo.power_av=0;
        hfo.power_pk=0;
        hfo.duration=0;
        hfo.start_t=ftFRonS.start_t(i);
        hfo.finish_t=ftFRonS.finish_t(i);
        hfo.slow=0;
        hfo.slow_vs=0;
        hfo.slow_angle=0;
        hfo.delta=0;
        hfo.delta_vs=0;
        hfo.delta_angle=0;
        hfo.theta=0;
        hfo.theta_vs=0;
        hfo.theta_angle=0;
        hfo.spindle=0;
        hfo.spindle_vs=0;
        hfo.spindle_angle=0;
        hfo.spike=0;
        hfo.spike_vs=0;
        hfo.spike_angle=0;
        n= insert(conn, collection, hfo);
end;
end;
end;
end;

 

