% This function is designed to edit 10 minutes blocks of the referential and
% bipolar HFO/spike detections using the exported XML file from Brain
% Quick. If no changes have been made to the XML file the program will
% output all detections found. If you have manually redacted detections,
% then the program will tell you how many redactions are detected and
% modified EZ-PAC files with the redacted detections removed will be saved.
% Please customize this example code to fit your needs. 

% PLEASE NOTE THE PROGRAM USES THE FIRST RIPPLE DETECTION!! AS AN INDEX
% IF YOU DELETE THE FIRST RIPPLE DECTECTION IN BRAIN QUICK THIS PROGRAM
% WILL NOT WORK!! IF YOU WANT TO DELETE THAT DETECTION IT WILL HAVE TO 
% BE DONE MANUALLY. 

% During testing, we recommend making a backup of your EVT file 
% before making edits in Brain Quick to confirm that the script
% can recognize all the events.

clear

mp=0 % loading referential file 
if mp==1
load('EEG_32_mp_1.mat') % monopolar EZ-Pac out file for ten minute block
m_FRonS=FRonS;
m_Total_FRonS=Total_FRonS;
m_Total_RonO=Total_RonO;
m_Total_TRonS=Total_TRonS;
m_Total_ftFRonS=Total_ftFRonS;
m_Total_ftRonO=Total_ftRonO;
m_Total_ftTRonS=Total_ftTRonS;
m_ftFRonS=ftFRonS;
m_metadata=metadata;
m_TRonS=TRonS;
m_RonO=RonO;
m_ftTRonS=ftTRonS;
m_ftRonO=ftRonO;
end;

bp=1 % loading bipolar file (i.e. ten minute block had both ref/suggested and bp channels
if bp==1
load('EEG_4164_bp_1.mat')
end;

[s]=xml2struct('EXT_5155.evt'); % load the corresponding XML file from Micromed

spike_index=cell(128,1);
ripple_index=cell(128,1);
fripple_index=cell(128,1);

for i=1:numel(s.EventFile.Events.Event)
        %Adjust times        
        %event_min=9;
        %event_sec=39.816+time_on;
      
        start=s.EventFile.Events.Event{i}.Begin;
        start=struct2cell(start);
        start=cell2mat(start);
        start=start(12:24);            
        s_hours=str2num(start(1:2));
        s_minutes=str2num(start(4:5));
        s_seconds=str2num(start(7:13));
        s_start=(s_hours*3600)+(s_minutes*60)+s_seconds;    % Note this code will need to be modified for recording that pass midnight
                
        finish=s.EventFile.Events.Event{i}.End;
        finish=struct2cell(finish);
        finish=cell2mat(finish);
        finish=finish(12:24);  
        f_hours=str2num(finish(1:2));
        f_minutes=str2num(finish(4:5));
        f_seconds=str2num(finish(7:13));
        f_final=(f_hours*3600)+(f_minutes*60)+f_seconds;
        
        ev_ch=s.EventFile.Events.Event{i}.DerivationInvID;
        ev_ch=struct2cell(ev_ch);
        ev_ch=cell2mat(ev_ch);
        ev_ch=str2num(ev_ch);
        
        % Identify event type 
        ev_type=s.EventFile.Events.Event{i}.EventDefinitionGuid;
        ev_type=struct2cell(ev_type);
        ev_type=cell2mat(ev_type);
        if strcmp(ev_type,'bf513752-2cb7-43bc-93f5-370def800b93');
            evt=0;
        end;
        if strcmp(ev_type,'167b6fad-f95a-4880-a9c6-968f468a1297');
            evt=1;
        end;
        if strcmp(ev_type,'e0a58c9c-b3c0-4a7d-a3c3-d3ed6a57dc3a');
            evt=2;
        end;
        
        if evt==0
            time_temp=s_start:0.0001:f_final;
            temp=spike_index{ev_ch};
            temp=horzcat(temp, time_temp);
            spike_index{ev_ch}=temp;
        end;
        if evt==1
            time_temp=s_start:0.0001:f_final;
            temp=ripple_index{ev_ch};
            temp=horzcat(temp, time_temp);
            ripple_index{ev_ch}=temp;
        end;
        if evt==2
            time_temp=s_start:0.0001:f_final;
            temp=fripple_index{ev_ch};
            temp=horzcat(temp, time_temp);
            fripple_index{ev_ch}=temp;
        end;
end;

% find channel assignments from original Brain Quick referential montage
if bp==1
    [~,montage_idx_bp]=ismember(metadata.bp_chanlist,metadata.montage(:,1));
end;
if mp==1
    [~,montage_idx_m]=ismember(m_metadata.m_chanlist,metadata.montage(:,1));
end

% adust time for first detection of RonO NEVER DELETE THE FIRST RONO
% DETECTION!

% find first ripple detection in EVT file
min_times=[];
for i=1:numel(metadata.montage(:,1))
    if ~isempty(ripple_index{i})
        min_times(i)=min(ripple_index{i})
    else
        min_times(i)=NaN
end;
end;
[firstxmlripple,xmlchannelidx]=nanmin(min_times);
dispstr=['first ripple in XML file occurs at: ', num2str(firstxmlripple),' seconds'];
disp(dispstr)
dispstr=['in channel:' metadata.montage(xmlchannelidx,1)];
disp(dispstr)

% find first ripple detection in referential file
if mp==1
 [m_minval,m_minidx]=min(m_RonO.start_t);
 m_minchidx=m_RonO.channel(m_minidx,1);
 m_minchname=m_metadata.montage(montage_idx_m(m_minchidx),1);
 dispstr=['first ripple in EZ-PAC monopolar file occurs at: ', num2str(m_minval),' seconds'];
 disp(dispstr) 
 dispstr=['in channel:' m_minchname];
 disp(dispstr)
end;

% find first ripple detection in referential file
if bp==1
 [bp_minval,bp_minidx]=min(RonO.start_t);
 bp_minchidx=RonO.channel(bp_minidx,1);
 bp_minchname=metadata.montage(montage_idx_bp(bp_minchidx),1);
 dispstr=['first ripple in EZ-PAC bipolar file occurs at: ', num2str(bp_minval),' seconds'];
 disp(dispstr) 
 dispstr=['in channel:' bp_minchname];
 disp(dispstr) 
end;

% calculate analysis offset time
analysis_offset=NaN;
if ((mp==1) & (bp==1)) % compare first channel name
    if strcmp(metadata.montage(xmlchannelidx,1),m_minchname)
         analysis_offset=firstxmlripple-m_minval
    end;
    if strcmp(metadata.montage(xmlchannelidx,1),bp_minchname)
        analysis_offset=firstxmlripple-bp_minval
    end;
end;

if ((mp==1) & (bp==0)) % compare first channel name
    if strcmp(metadata.montage(xmlchannelidx,1),m_minchname)
         analysis_offset=firstxmlripple-m_minval
    end;
end;

if ((mp==0) & (bp==1)) % compare first channel name
    if strcmp(metadata.montage(xmlchannelidx,1),bp_minchname)
        analysis_offset=firstxmlripple-bp_minval
    end;
end;

% Now use a subfunction to compare events, remove events, and save to a new
% EZpac file labeled with c. These functions can be used for multiple
% blocks of data. 


if bp==1
    %remove_events(file_name,ripple_index,spike_index,fripple_index,offset,ref,file_block)
    remove_events('EEG_4164_bp_1.mat',ripple_index, spike_index, fripple_index, analysis_offset+0.003, 1, 1) 
    %in beta testing additional three milliseconds of adjustment were required for offset, 
    %I apologize for this bug, and hope it remains consistent acrosss
    %files.The bug first appeared after adding hours to the event time
    %calculations from the XML file. Thus it is probably related to 
    %the precision of XML start times. 
end;

if mp==1
    %remove_events(file_name,ripple_index,spike_index,fripple_index,offset,ref,file_block)
    remove_events('EEG_32_mp_1.mat',ripple_index, spike_index, fripple_index, analysis_offset+0.003, 0, 1) 
    % please see comment above
end;
