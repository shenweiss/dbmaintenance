function remove_events(file_name,ripple_index,spike_index,fripple_index,offset,ref,file_block)

load(file_name)
if ref==0 % referential recording
    [~,montage_idx]=ismember(metadata.m_chanlist,metadata.montage(:,1));
end;
if ref==1
    [~,montage_idx]=ismember(metadata.bp_chanlist,metadata.montage(:,1));
end;

b=[];
deletions=0;
found=0;
A = exist('RonO');
if A==1
    if ~isempty(RonO.channel)
        for i=1:numel(RonO.channel(:,1))
            if ~ismember((round(RonO.start_t(i)+offset,4)+((file_block-1)*600)),round(ripple_index{montage_idx(RonO.channel(i,1))},4))
                disp_msg=['deleting ripple on oscillation in channel: ' metadata.montage(montage_idx(RonO.channel(i,1)),1)];
                disp(disp_msg)
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;
        end;
          for i=1:numel(b)
                Total_RonO(RonO.channel(b(i),1))=Total_RonO(RonO.channel(b(i),1))-1;
          end;    
          if ~isempty(b)
                RonO.channel(b,:)=[];
                RonO.delta(:,b)=[];
                RonO.delta_angle(:,b)=[];
                RonO.delta_vs(:,b)=[];
                RonO.duration(b,:)=[];
                RonO.finish_t(b,:)=[];
                RonO.freq_av(b,:)=[];
                RonO.freq_pk(b,:)=[];
                RonO.power_av(b,:)=[];
                RonO.power_pk(b,:)=[];
                RonO.slow(:,b)=[];
                RonO.slow_angle(:,b)=[];
                RonO.slow_vs(:,b)=[];
                RonO.spindle(:,b)=[];
                RonO.spindle_angle(:,b)=[];
                RonO.spindle_vs(:,b)=[];
                RonO.start_t(b,:)=[];
                RonO.theta(:,b)=[];
                RonO.theta_angle(:,b)=[];
                RonO.theta_vs(:,b)=[];
          end;      
    end;
end;

b=[];
A = exist('TRonS');
if A==1
    if ~isempty(TRonS.channel)
        for i=1:numel(TRonS.channel(:,1))
            if  ~ismember((round(TRonS.start_t(i)+offset,4)+((file_block-1)*600)),round(ripple_index{montage_idx(TRonS.channel(i,1))},4))
                disp_msg=['deleting ripple on spike in channel: ' metadata.montage(montage_idx(TRonS.channel(i,1)),1)];
                disp(disp_msg)
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;
        end;
        for i=1:numel(b)
                Total_TRonS(TRonS.channel(b(i),1))=Total_TRonS(TRonS.channel(b(i),1))-1;
        end;  
          if ~isempty(b)
                TRonS.channel(b,:)=[];
                TRonS.duration(b,:)=[];
                TRonS.finish_t(b,:)=[];
                TRonS.freq_av(b,:)=[];
                TRonS.freq_pk(b,:)=[];
                TRonS.power_av(b,:)=[];
                TRonS.power_pk(b,:)=[];
                TRonS.start_t(b,:)=[];
                TRonS.vs(:,b)=[];
                TRonS.angle(:,b)=[];
          end;      
    end;
end;

b=[];
A = exist('ftTRonS');
if A==1
    if ~isempty(ftTRonS.channel)
        for i=1:numel(ftTRonS.channel(:,1))
            if  ~ismember((round(ftTRonS.start_t(i)+offset,4)+((file_block-1)*600)),round(fripple_index{montage_idx(ftTRonS.channel(i,1))},4))
                disp_msg=['deleting fast ripple on spike in channel: ' metadata.montage(montage_idx(ftTRonS.channel(i,1)),1)];
                disp(disp_msg)
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;            
        end;
        for i=1:numel(b)
                Total_ftTRonS(ftTRonS.channel(b(i),1))=Total_ftTRonS(ftTRonS.channel(b(i),1))-1;
        end;          
        if ~isempty(b)
                ftTRonS.channel(b,:)=[];
                ftTRonS.duration(b,:)=[];
                ftTRonS.finish_t(b,:)=[];
                ftTRonS.freq_av(b,:)=[];
                ftTRonS.freq_pk(b,:)=[];
                ftTRonS.power_av(b,:)=[];
                ftTRonS.power_pk(b,:)=[];
                ftTRonS.start_t(b,:)=[];
                ftTRonS.vs(:,b)=[];
                ftTRonS.angle(:,b)=[];
        end;         
    end;
end;

b=[];
A = exist('ftRonO');
if A==1
    if ~isempty(ftRonO.channel)
        for i=1:numel(ftRonO.channel(:,1))
            if ~ismember((round(ftRonO.start_t(i)+offset,4)+((file_block-1)*600)),round(fripple_index{montage_idx(ftRonO.channel(i,1))},4))
                disp_msg=['deleting fast ripple on oscillation in channel: ' metadata.montage(montage_idx(ftRonO.channel(i,1)),1)];
                disp(disp_msg)
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;
        end;
        for i=1:numel(b)
                Total_ftRonO(ftRonO.channel(b(i),1))=Total_ftRonO(ftRonO.channel(b(i),1))-1;
        end;  
          if ~isempty(b)
                ftRonO.channel(b,:)=[];
                ftRonO.delta(:,b)=[];
                ftRonO.delta_angle(:,b)=[];
                ftRonO.delta_vs(:,b)=[];
                ftRonO.duration(b,:)=[];
                ftRonO.finish_t(b,:)=[];
                ftRonO.freq_av(b,:)=[];
                ftRonO.freq_pk(b,:)=[];
                ftRonO.power_av(b,:)=[];
                ftRonO.power_pk(b,:)=[];
                ftRonO.slow(:,b)=[];
                ftRonO.slow_angle(:,b)=[];
                ftRonO.slow_vs(:,b)=[];
                ftRonO.spindle(:,b)=[];
                ftRonO.spindle_angle(:,b)=[];
                ftRonO.spindle_vs(:,b)=[];
                ftRonO.start_t(b,:)=[];
                ftRonO.theta(:,b)=[];
                ftRonO.theta_angle(:,b)=[];
                ftRonO.theta_vs(:,b)=[];
          end;      
    end;
end;

b=[];
A = exist('FRonS');
if A==1
    if ~isempty(FRonS.channel)
        for i=1:numel(FRonS.channel(:,1))
            if ~ismember((round(FRonS.start_t(i)+offset,4)+((file_block-1)*600)),round(spike_index{montage_idx(FRonS.channel(i,1))},4))
                disp_msg=['deleting spike in channel: ' metadata.montage(montage_idx(FRonS.channel(i,1)),1)];
                disp(disp_msg)   
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;
        end;
        for i=1:numel(b)
                Total_FRonS(FRonS.channel(b(i),1))=Total_FRonS(FRonS.channel(b(i),1))-1;
        end;
           if ~isempty(b)
                FRonS.channel(b,:)=[];
                FRonS.finish_t(b,:)=[];
                FRonS.start_t(b,:)=[];
          end;     
    end;
end;

b=[];
A = exist('ftFRonS')
if A==1
    if ~isempty(ftFRonS.channel)
        for i=1:numel(ftFRonS.channel(:,1))
            if ~ismember((round(ftFRonS.start_t(i)+offset,4)+((file_block-1)*600)),round(spike_index{montage_idx(ftFRonS.channel(i,1))},4))
                disp_msg=['deleting spike in channel: ' metadata.montage(montage_idx(ftFRonS.channel(i,1)),1)];
                disp(disp_msg)
                deletions=deletions+1;
                b=[b i];
            else
                found=found+1;
            end;
        end;
        for i=1:numel(b)
                Total_ftFRonS(ftFRonS.channel(b(i),1))=Total_ftFRonS(ftFRonS.channel(b(i),1))-1;
        end;
          if ~isempty(b)
                ftFRonS.channel(b,:)=[];
                ftFRonS.finish_t(b,:)=[];
                ftFRonS.start_t(b,:)=[];
          end;      
    end;
end;
disp_msg=['During alignment ' num2str(found) ' events were found'];
disp(disp_msg)
disp_msg=[num2str(deletions) ' events were not found and deleted. Writing corrected EZPAC file'];
disp(disp_msg)
filename_length=numel(file_name);
file_name=file_name(1:(filename_length-4));
file_name=strcat(file_name, 'c.mat');
save(file_name,'RonO','TRonS','FRonS','ftRonO','ftTRonS','ftFRonS','Total_RonO','Total_TRonS','Total_FRonS','Total_ftRonO','Total_ftTRonS','Total_ftFRonS','metadata');