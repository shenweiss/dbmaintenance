% combine spikes and sharp spikes
% double check SOZ
% change LOC check and double check output

function [output_t] = rate_table()

server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);
collection = "HFOs";

patients={'4145'};
%patients={'4122', '4124', '4145', '4166', '466', '468', '477', 'IO004'};

for i=1:numel(patients)
    collection = "HFOs";
    test_query=['{"patient_id":"' patients{i} '"}'];
    file_block = distinct(conn,collection,"file_block",'Query',test_query);
        for j=1:numel(file_block)
            test_query=['{"patient_id":"' patients{i} '","file_block":"' file_block{j} '"}'];
            electrodes = distinct(conn,collection,"electrode",'Query',test_query);
            pat={''};
            chan={''};
            loc2={''};
            soz=[];
            mt=[];
            rates=[];
               for k=1:numel(electrodes)                  
                 pat{k}=patients{i};
                 chan{k}=electrodes{k};
                  for l=1:5
                   if l~=3   
                    test_query=['{"patient_id":"' patients{i} '","electrode":"' electrodes{k} '","file_block":"' file_block{j} '","type":"' num2str(l) '"}'];
                    num_records = count(conn,collection,'Query',test_query);
                    iterations = (num_records/5000);
                    documents=[];
                    for m=1:(iterations+1)
                        if m==1
                            docs = find(conn,collection,'query',test_query,'limit',5000);
                        else
                            docs = find(conn,collection,'query',test_query,'skip',5000,'limit',5000);
                        end;
                    documents=vertcat(documents,docs);
                    end
                    counter=iterations*5000;
                    if iterations==0
                    documents = find(conn,collection,'query',test_query);
                    end;                     
                 
                 if ~isempty(documents)   
                 test_query=['{"patient_id":"' patients{i} '","electrode":"' electrodes{k} '"}'];
                 collection = "HFOs";
                 soztemp = distinct(conn,collection,"soz",'Query',test_query);
                 soztemp=cell2mat(soztemp);
                   if ~isempty(soztemp)       
                      soztemp=str2double(soztemp);       
                      soztemp=soztemp(1);
                   else
                    collection = "Electrodes";
                    soztemp = distinct(conn,collection,"soz",'Query',test_query);
                    soztemp = cell2mat(soztemp);
     
                  if ~isempty(soztemp)       
                   soztemp=str2double(soztemp);      
                   soztemp=soztemp(1);
                  end;
                  end;
     
                  if soztemp == 0
                  collection = "Electrodes";
                  soztemp = distinct(conn,collection,"soz",'Query',test_query);
                  soztemp =cell2mat(soztemp);
                  if ~isempty(soztemp)      soztemp=str2double(soztemp);    soztemp=soztemp(1);     end;   
                  end;
                 
                 soz(k)=soztemp;
                 collection = "HFOs";
                 mt(k)=str2num(documents(1).resected);
                 if ~iscell(documents(1).loc2)
                     loc2{k}=(documents(1).loc2);
                 else
                     loc2{k}=(documents(1).loc2{1});
                 end;   
                 if isempty(documents(1).loc2)            
                 collection = "Electrodes";                    
                 test_query=['{"patient_id":"' patients{i} '","electrode":"' electrodes{k} '"}'];
                 temp = find(conn,collection,'query',test_query,'limit',5000);
                 collection = "HFOs";
                 loc2{k}=temp(1).loc2;
                 if isempty(loc2{k})
                 loc2{k}='No Localization';
                 end;
                 end;
                 
                 if strcmp(loc2{k},'Limbic Lobe')
                     if ~iscell(documents(1).loc5)
                        tempstr=(documents(1).loc5);
                     else
                        tempstr=(documents(1).loc5{1});
                     end;  
                     
                     if strcmp(tempstr,'Amygdala')
                        loc2{k}='Amygdala';
                     end;
                     
                     if strcmp(tempstr,'Hippocampus')
                        loc2{k}='Hippocampus';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 28')
                        loc2{k}='EC';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 34')
                        loc2{k}='EC';
                     end;
                 end;
                 
                 if l==1
                 rates(k,1)=numel(documents)/(documents(1).r_duration/60);
                 
                 end;
                 if l==2
                 rates(k,2)=numel(documents)/(documents(1).r_duration/60);
                 end;
                 if l==4
                 rates(k,4)=numel(documents)/(documents(1).fr_duration/60);
                 end;
                 if l==5
                 rates(k,5)=numel(documents)/(documents(1).fr_duration/60);
                 end;                 
                 else
                 if l==1
                 rates(k,1)=0;
                 end;
                 if l==2
                 rates(k,2)=0;
                 end;              
                 if l==4
                 rates(k,4)=0;
                 end;
                 if l==5
                 rates(k,5)=0;
                 end;
                 end;
                 else
                    test_query=['{"patient_id":"' patients{i} '","electrode":"' electrodes{k} '","file_block":"' file_block{j} '","type":"' num2str(3) '"}'];
                    num_records = count(conn,collection,'Query',test_query);
                    iterations = (num_records/5000);
                    documents=[];
                    for m=1:(iterations+1)
                        if m==1
                            docs = find(conn,collection,'query',test_query,'limit',5000);
                        else
                            docs = find(conn,collection,'query',test_query,'skip',5000,'limit',5000);
                        end;
                    documents=vertcat(documents,docs);
                    end
                    counter=iterations*5000;
                    if iterations==0
                    documents = find(conn,collection,'query',test_query);
                    end;                     
                   test_query=['{"patient_id":"' patients{i} '","electrode":"' electrodes{k} '","file_block":"' file_block{j} '","type":"' num2str(6) '"}'];
                   num_records = count(conn,collection,'Query',test_query);

                 if ~isempty(documents)   
                 soz(k)=str2num(documents(1).soz);
                 mt(k)=str2num(documents(1).resected);
                 if ~iscell(documents(1).loc2)
                     loc2{k}=(documents(1).loc2);
                 else
                     loc2{k}=(documents(1).loc2{1});
                 end;
                 
                 if strcmp(loc2{k},'Limbic Lobe')
                     if ~iscell(documents(1).loc5)
                        tempstr=(documents(1).loc5);
                     else
                        tempstr=(documents(1).loc5{1});
                     end;  
                     
                     if strcmp(tempstr,'Amygdala')
                        loc2{k}='Amygdala';
                     end;
                     
                     if strcmp(tempstr,'Hippocampus')
                        loc2{k}='Hippocampus';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 28')
                        loc2{k}='EC';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 34')
                        loc2{k}='EC';
                     end;
                 end;
                 
                 rates(k,3)=(numel(documents)+num_records)/(documents(1).r_duration/60);                           
                 else
                  rates(k,3)=0;
                 end;            
               end;
              end;
            end;
            temp_t=table(pat', chan', soz', mt', loc2', rates);    
            if j==1
              temp2_t=temp_t;  
            else
              temp2_t=vertcat(temp2_t, temp_t);
            end;
        end;
   if i==1
      temp3_t=[];
      soz={''};
      mt={''};
      pat={''};
      chan={''};
      loc2={''};
      unique_chans=unique(temp2_t.Var2);
        for j=1:numel(unique_chans)
          index = find(strcmp([temp2_t.Var2(:)],unique_chans(j)));
          pat{j}=temp2_t.Var1(j);
          tempvar=unique_chans(j);
          chan{j}=tempvar{1,1};
          soz{j}=temp2_t.Var3(index(1));
          mt{j}=temp2_t.Var4(index(1));
          loc2{j}=temp2_t.Var5(index(1));
          rtemp=zeros(1,5); 
          for k=1:numel(index)
               rtemp(1)=rtemp(1)+temp2_t.rates(index(k),1);
               rtemp(2)=rtemp(2)+temp2_t.rates(index(k),2);
               rtemp(3)=rtemp(3)+temp2_t.rates(index(k),3);
               rtemp(4)=rtemp(4)+temp2_t.rates(index(k),4);
               rtemp(5)=rtemp(5)+temp2_t.rates(index(k),5);
          end;
         rtemp=rtemp/numel(index); 
         rates(j,:)=rtemp;
        end;
    temp3_t=table(pat', chan', soz', mt', loc2', rates); 
    %% add electrodes with no events
    collection = "Electrodes";
    test_query=['{"patient_id":"' patients{i} '"}'];
    ex_electrodes = distinct(conn,collection,"electrode",'Query',test_query);
    [C,IA] = setdiff(ex_electrodes,chan)
    Var1={''};
    Var2={''};
    Var3={''};
    Var4={''};
    Var5={''};
    rates=[];
    for j=1:numel(C)
     Var1{j}=temp2_t.Var1(1);
     Var2{j}=C(j);
     test_query=['{"patient_id":"' patients{i} '","electrode":"' C{j} '"}'];
     docs = find(conn,collection,'query',test_query,'limit',5000);
     soztemp=docs(1).soz;
                  if ~isempty(soztemp)      soztemp=str2double(soztemp);   end; 
     Var3{j}=soztemp;             
     Var4{j}=docs(1).resected;
     Var5{j}=docs(1).loc2;
            if ~iscell(docs(1).loc2)
                    Var5{j}=(docs(1).loc2);
            else
                    Var5{j}=(docs(1).loc2{1});
            end;  
            
            if strcmp(loc2{k},'Limbic Lobe')
                     if ~iscell(documents(1).loc5)
                        tempstr=(documents(1).loc5);
                     else
                        tempstr=(documents(1).loc5{1});
                     end;  
                     
                     if strcmp(tempstr,'Amygdala')
                        loc2{k}='Amygdala';
                     end;
                     
                     if strcmp(tempstr,'Hippocampus')
                        loc2{k}='Hippocampus';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 28')
                        loc2{k}='EC';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 34')
                        loc2{k}='EC';
                     end;
            end;
            
     if isempty(docs(1).loc2)
        Var5{j}='No Localization';
     end;
     rates(j,:)=zeros(1,5);
    end;
    temp3ex_t=table(Var1', Var2', Var3', Var4', Var5', rates);
    temp3_t=vertcat(temp3_t, temp3ex_t);
    output_t=temp3_t;
   else
      temp3_t=[];
      soz={''};
      mt={''};
      pat={''};
      chan={''};
      loc2={''};
      unique_chans=unique(temp2_t.Var2);
        for j=1:numel(unique_chans)
          index = find(strcmp([temp2_t.Var2(:)],unique_chans(j)));
          pat{j}=temp2_t.Var1(j);
          tempvar=unique_chans(j);
          chan{j}=tempvar{1,1};
          if numel(index)>1
          soz{j}=temp2_t.Var3(index(1));
          mt{j}=temp2_t.Var4(index(1));
          loc2{j}=temp2_t.Var5(index(1));
          else
          soz{j}=temp2_t.Var3(index);
          mt{j}=temp2_t.Var4(index);
          loc2{j}=temp2_t.Var5(index);
          rtemp=zeros(1,5); 
          end;
          for k=1:numel(index)
               rtemp(1)=rtemp(1)+temp2_t.rates(index(k),1);
               rtemp(2)=rtemp(2)+temp2_t.rates(index(k),2);
               rtemp(3)=rtemp(3)+temp2_t.rates(index(k),3);
               rtemp(4)=rtemp(4)+temp2_t.rates(index(k),4);
               rtemp(5)=rtemp(5)+temp2_t.rates(index(k),5);
          end;
         rtemp=rtemp/numel(index); 
         rates(j,:)=rtemp;
        end;  
    temp3_t=table(pat', chan', soz', mt', loc2', rates);  
    %% add electrodes with no events
    collection = "Electrodes";
    test_query=['{"patient_id":"' patients{i} '"}'];
    ex_electrodes = distinct(conn,collection,"electrode",'Query',test_query);
    [C,IA] = setdiff(ex_electrodes,chan)
    Var1={''}
    Var2={''};
    Var3={''};
    Var4={''};
    Var5={''};
    rates=[];
    for j=1:numel(C)
     Var1{j}=temp2_t.Var1(1);
     Var2{j}=C(j);
     test_query=['{"patient_id":"' patients{i} '","electrode":"' C{j} '"}'];
     docs = find(conn,collection,'query',test_query,'limit',5000);
     soztemp=docs(1).soz;
                  if ~isempty(soztemp)      soztemp=str2double(soztemp);     end; 
     Var3{j}=soztemp;  
     Var4{j}=docs(1).mt;
     Var5{j}=docs(1).loc2
     if ~iscell(docs(1).loc2)
                    Var5{j}=(docs(1).loc2);
            else
                    Var5{j}=(docs(1).loc2{1});
     end;  
     
     if strcmp(loc2{k},'Limbic Lobe')
                     if ~iscell(documents(1).loc5)
                        tempstr=(documents(1).loc5);
                     else
                        tempstr=(documents(1).loc5{1});
                     end;  
                     
                     if strcmp(tempstr,'Amygdala')
                        loc2{k}='Amygdala';
                     end;
                     
                     if strcmp(tempstr,'Hippocampus')
                        loc2{k}='Hippocampus';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 28')
                        loc2{k}='EC';
                     end;
                     
                     if strcmp(tempstr,'Brodmann area 34')
                        loc2{k}='EC';
                     end;
     end;
     
     if isempty(docs(1).loc2)
        Var5{j}='No Localization';
     end;
     rates(j,:)=zeros(1,5);
    end;
    temp3ex_t=table(Var1', Var2', Var3', Var4', Var5', rates);
    temp3_t=vertcat(temp3_t, temp3ex_t);
    output_t=vertcat(output_t,temp3_t);   
   end;      
end;

