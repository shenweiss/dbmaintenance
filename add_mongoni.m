function add_mongoni(patcode,men)

server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);
collection = "HFOs";

patients = distinct(conn,collection,"patient_id");
patnum=find(ismember(patients,patcode)==1);

for i=1:numel(men(:,1))
  i
  query=['{"patient_id":"' patients{patnum} '","electrode":"' men{i,1} '"}'];
  num_records = count(conn,collection,'Query',query);
  if num_records>0
      iterations = floor(num_records/5000);
                        for m=1:(iterations+1)
                            if m==1
                                docs = find(conn,collection,'query',query,'limit',5000);
                                documents=docs;
                            else
                                skip_int=(5000+((m-2)*5000))
                                docs = find(conn,collection,'query',query,'skip',skip_int,'limit',5000);
                                documents=vertcat(documents, docs);
                           end;   
                        end;            
  for j=1:numel(documents)
      documents(j).x=men{i,2};
      documents(j).y=men{i,3};
      documents(j).z=men{i,4};
      documents(j).loc1=men{i,5};
      documents(j).loc2=men{i,6};
      documents(j).loc3=men{i,7};
      documents(j).loc4=men{i,8};
      documents(j).loc5=men{i,9};
      documents(j).resected=men{i,10};    
  end;
  documents=rmfield(documents,'x_id')
  entries_removed = remove(conn,collection,query);
  n= insert(conn, collection, documents);
  end;
end;

collection = "Electrodes";
for i=1:numel(men(:,1))
    i
    query=['{"patient_id":"' patients{patnum} '","electrode":"' men{i,1} '"}'];
    num_records = count(conn,collection,'Query',query);
if num_records>0
       iterations = floor(num_records/5000);
                         for m=1:(iterations+1)
                             if m==1
                                 docs = find(conn,collection,'query',query,'limit',5000);
                                 documents=docs;
                             else
                                 skip_int=(5000+((m-2)*5000))
                                 docs = find(conn,collection,'query',query,'skip',skip_int,'limit',5000);
                                 documents=vertcat(documents, docs);
                            end;   
                         end; 
for j=1:numel(documents)
    documents(j).x=men{i,2};
    documents(j).y=men{i,3};
    documents(j).z=men{i,4};
    documents(j).loc1=men{i,5};
    documents(j).loc2=men{i,6};
    documents(j).loc3=men(i,7);
    documents(j).loc4=men(i,8);
    documents(j).loc5=men(i,9);
    documents(j).resected=men(i,10);
end;
documents=rmfield(documents,'x_id')
entries_removed = remove(conn,collection,query);
n= insert(conn, collection, documents);
end;
end;