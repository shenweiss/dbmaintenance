function [men]=existingmen(patcode)

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

chan_hfo={''};
x_hfo={''};
y_hfo={''};
z_hfo={''};
loc1_hfo={''};
loc2_hfo={''};
loc3_hfo={''};
loc4_hfo={''};
loc5_hfo={''};
r_hfo={''};

for i=1:numel(hfo_electrodes)
    i
query=['{"patient_id":"' patients{patnum} '","electrode":"' hfo_electrodes{i} '"}'];
docs = find(conn,collection,'query',query,'limit',1);
chan_hfo{i}=hfo_electrodes{i};
x_hfo{i}=docs.x;
y_hfo{i}=docs.y;
z_hfo{i}=docs.z;
if ~isempty(docs.loc1)
loc1_hfo{i}=docs.loc1;
loc2_hfo{i}=docs.loc2;
loc3_hfo{i}=docs.loc3;
loc4_hfo{i}=docs.loc4;
loc5_hfo{i}=docs.loc5;
else
if ~isempty(docs.x)
Locs = mni2Locs(x_hfo{i},y_hfo{i},z_hfo{i})
loc1_hfo{i}=Locs{1};
loc2_hfo{i}=Locs{2};
loc3_hfo{i}=Locs{3};
loc4_hfo{i}=Locs{4};
loc5_hfo{i}=Locs{5};
else
loc1_hfo{i}='';
loc2_hfo{i}='';
loc3_hfo{i}='';
loc4_hfo{i}='';
loc5_hfo{i}='';
end;
end; 
r_hfo{i}='0';
end;

collection = "Electrodes";
query=['{"patient_id":"' patients{patnum} '"}'];
edb_electrodes = distinct(conn,collection,"electrode",'Query',query);
notinset_idx=find(ismember(edb_electrodes,hfo_electrodes)==0);
notinset=edb_electrodes(notinset_idx);

chan_e={''}
x_e={''};
y_e={''};
z_e={''};
loc1_e={''};
loc2_e={''};
loc3_e={''};
loc4_e={''};
loc5_e={''};
r_e={''};

for i=1:numel(notinset)
    i
query=['{"patient_id":"' patients{patnum} '","electrode":"' notinset{i} '"}'];
docs = find(conn,collection,'query',query,'limit',1);
chan_e{i}=notinset{i};
x_e{i}=docs.x;
y_e{i}=docs.y;
z_e{i}=docs.z;
if ~isempty(docs.loc1)
loc1_e{i}=docs.loc1;
loc2_e{i}=docs.loc2;
loc3_e{i}=docs.loc3;
loc4_e{i}=docs.loc4;
loc5_e{i}=docs.loc5;
else
if ~isempty(docs.x)
Locs = mni2Locs(x_e{i},y_e{i},z_e{i})
loc1_e{i}=Locs{1}
loc2_e{i}=Locs{2}
loc3_e{i}=Locs{3}
loc4_e{i}=Locs{4}
loc5_e{i}=Locs{5}
else
loc1_hfo{i}='';
loc2_hfo{i}='';
loc3_hfo{i}='';
loc4_hfo{i}='';
loc5_hfo{i}='';
end;
end; 
r_e{i}='0';
end;

chan=vertcat(chan_hfo',chan_e');
x=vertcat(x_hfo',x_e');
y=vertcat(y_hfo',y_e');
z=vertcat(z_hfo',z_e');
loc1=vertcat(loc1_hfo',loc1_e');
loc2=vertcat(loc2_hfo',loc2_e');
loc3=vertcat(loc3_hfo',loc3_e');
loc4=vertcat(loc4_hfo',loc4_e');
loc5=vertcat(loc5_hfo',loc5_e');
r=vertcat(r_hfo',r_e');
men=horzcat(chan,x,y,z,loc1,loc2,loc3,loc4,loc5,r);
