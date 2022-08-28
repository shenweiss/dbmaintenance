function [men, error_men, error_nie]=edit_mongoni(patcode,ni_electrodes,resected)

server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);
collection = "HFOs";

patients = distinct(conn,collection,"patient_id");
patnum=find(ismember(patients,patcode)==1);

query=['{"patient_id":"' patients{patnum} '"}'];
hfo_electrodes = distinct(conn,collection,"electrode",'Query',query);

collection = "Electrodes";
edb_electrodes = distinct(conn,collection,"electrode",'Query',query);

total_electrodes = [hfo_electrodes edb_electrodes];
unique_electrodes = unique(total_electrodes);

mongo_electrode_names={''};
name_pol=0;
name_p=0;
if strcmp(unique_electrodes{3}(1:3),'POL')
    for i=1:numel(unique_electrodes)
        mongo_electrode_names{i}=unique_electrodes{i}(5:numel(unique_electrodes{i}));
    end;
    name_pol=1;  
else
if strcmp(unique_electrodes{3}(1:1),'P')
    for i=1:numel(unique_electrodes)
        mongo_electrode_names{i}=unique_electrodes{i}(3:numel(unique_electrodes{i}));
    end;
    name_p=1;
else    
    mongo_electrode_names=unique_electrodes;
end;
end;

name_ref=0;
strsize=numel(mongo_electrode_names{3})
if strsize>3
if strcmp(mongo_electrode_names{3}((strsize-3):strsize),'-Ref');
    for i=1:numel(mongo_electrode_names)
        strsize=numel(mongo_electrode_names{i});
        mongo_electrode_names{i}=mongo_electrode_names{i}(1:(strsize-4));
    end;
name_ref=1;
end;
end;

%% match ni_electrodes with mongo_electrode_names
% what ni_electrodes were not found
% what mongo_electrode_names were not found
% assign Var1-3 in the table in to the cell of mongo_electrode_names
clear nie men error_men error_nie error_men_bin
men = mongo_electrode_names.';
men(:,2:4) = cell(size(men,1),3);
nie = (ni_electrodes);
error_nie = {''};
error_men = {''};
error_men_bin = zeros(size(men,1),1);
for ii = 1:size(nie,1)
% ii = 1
    kk = 0;
    for jj = 1:size(men,1)
    % jj = 28
    x1 = convertStringsToChars(lower(nie{ii,1}));
    x2 = lower(men{jj,1});
    x1(isspace(x1)) = [];
    x2(isspace(x2)) = [];
    if strcmp(x1,'lp1 1')
        fprintf('test')
    end;
         if strcmp(x2,x1)
          if ~isempty(strfind(x1,x2)) || ~isempty(strfind(x2,x1))
            kk = 1;
            error_men_bin(jj) = 1;
            men(jj,2:end) = nie(ii,2:end);
         end
         end
    end
    if kk == 0
        error_nie = [error_nie; nie(ii,1)];
    end
end
error_men = [error_men; men(find(~error_men_bin),1)];
%%

for i=1:numel(men(:,1))
    i
    x=men{i,2}
    y=men{i,3}
    z=men{i,4}
    Locs = mni2Locs(x,y,z)
    men(i,5:9)=Locs;
    if resected==0
        men(i,10)={'-1'};
    else
        men(i,10)={'0'};
    end;    
end;

if name_pol==1;
    for i=1:numel(men(:,1))
      temp_str=men{i,1}
      temp_str=['POL ' temp_str]
      men{i,1}=temp_str;
    end;
end;

if name_p==1;
    for i=1:numel(men(:,1))
      temp_str=men{i,1}
      temp_str=['P ' temp_str]
      men{i,1}=temp_str;
    end;
end;

if name_ref==1;
    for i=1:numel(men(:,1))
      temp_str=men{i,1}
      temp_str=[temp_str '-Ref']
      men{i,1}=temp_str;
    end;
end;
%%




