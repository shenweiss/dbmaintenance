function [output_t] = build_rate_table()



server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);
collection = "HFOs";

%patients = distinct(conn,collection,"patient_id")
patients={'4166'}

for i=1:numel(patients)
    collection = "HFOs";
    test_query=['{"patient_id":"' patients{i} '"}'];
    file_block = distinct(conn,collection,"file_block",'Query',test_query);
        for j=1:numel(file_block)
            test_query=['{"patient_id":"' patients{i} '","file_block":"' file_block{j} '"}'];
            electrodes = distinct(conn,collection,"electrode",'Query',test_query);
            pat={''};
            chan={''};
            soz=[];
            mt=[];
               for k=1:numel(electrodes)                  
                 pat{k}=patients{i};
                 chan{k}=electrodes{k};
                  for l=1:6
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
                 soz(k)=str2num(documents(1).soz);
                 mt(k)=str2num(documents(1).mt);
                 if l==1
                 rates(k,1)=numel(documents)/(documents(1).r_duration/60);
                 end;
                 if l==2
                 rates(k,2)=numel(documents)/(documents(1).r_duration/60);
                 end;
                 if l==3
                 rates(k,3)=numel(documents)/(documents(1).r_duration/60);
                 end;
                 if l==4
                 rates(k,4)=numel(documents)/(documents(1).fr_duration/60);
                 end;
                 if l==5
                 rates(k,5)=numel(documents)/(documents(1).fr_duration/60);
                 end;
                 if l==6
                 rates(k,6)=numel(documents)/(documents(1).fr_duration/60);
                 end;
                 else
                 if l==1
                 rates(k,1)=0;
                 end;
                 if l==2
                 rates(k,2)=0;
                 end;
                 if l==3
                 rates(k,3)=0;
                 end;
                 if l==4
                 rates(k,4)=0;
                 end;
                 if l==5
                 rates(k,5)=0;
                 end;
                 if l==6
                 rates(k,6)=0;
                 end;                     
                end;                  
               end;
               end;
            temp_t=table(pat', chan', soz', mt', rates);    
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
      unique_chans=unique(temp2_t.Var2);
        for j=1:numel(unique_chans)
          index = find(strcmp([temp2_t.Var2(:)],unique_chans(j)));
          pat{j}=temp2_t.Var1(j);
          chan{j}=unique_chans(j);
          soz{j}=temp2_t.Var3(index(1));
          mt{j}=temp2_t.Var4(index(1));
          rtemp=zeros(1,6); 
          for k=1:numel(index)
               rtemp(1)=rtemp(1)+temp2_t.rates(index(k),1);
               rtemp(2)=rtemp(2)+temp2_t.rates(index(k),2);
               rtemp(3)=rtemp(3)+temp2_t.rates(index(k),3);
               rtemp(4)=rtemp(4)+temp2_t.rates(index(k),4);
               rtemp(5)=rtemp(5)+temp2_t.rates(index(k),5);
               rtemp(6)=rtemp(6)+temp2_t.rates(index(k),6);
          end;
         rtemp=rtemp/numel(index); 
         rates(j,:)=rtemp;
        end;
    temp3_t=table(pat', chan', soz', mt', rates); 
    %% add electrodes with no events
    collection = "Electrodes_AES";
    test_query=['{"patient_id":"' patients{i} '"}'];
    ex_electrodes = distinct(conn,collection,"electrode",'Query',test_query);
    [C,IA] = setdiff(ex_electrodes,electrodes)
    Var1={''};
    Var2={''};
    Var3={''};
    Var4={''};
    rates=[];
    for j=1:numel(C)
     Var1{j}=temp2_t.Var1(1);
     Var2{j}=C(j);
     test_query=['{"patient_id":"' patients{i} '","electrode":"' C{j} '"}'];
     docs = find(conn,collection,'query',test_query,'limit',5000);
     Var3{j}=docs(1).soz;
     Var4{j}=docs(1).mt;
     rates(j,:)=zeros(1,6);
    end;
    temp3ex_t=table(Var1', Var2', Var3', Var4', rates);
    temp3_t=vertcat(temp3_t, temp3ex_t);
    output_t=temp3_t;
   else
      temp3_t=[];
      soz={''};
      mt={''};
      pat={''};
      chan={''};
      unique_chans=unique(temp2_t.Var2);
        for j=1:numel(unique_chans)
          index = find(strcmp([temp2_t.Var2(:)],unique_chans(j)));
          pat{j}=temp2_t.Var1(j);
          chan{j}=unique_chans(j);
          soz{j}=temp2_t.Var3(index(1));
          mt{j}=temp2_t.Var4(index(1));
          rtemp=zeros(1,6); 
          for k=1:numel(index)
               rtemp(1)=rtemp(1)+temp2_t.rates(index(k),1);
               rtemp(2)=rtemp(2)+temp2_t.rates(index(k),2);
               rtemp(3)=rtemp(3)+temp2_t.rates(index(k),3);
               rtemp(4)=rtemp(4)+temp2_t.rates(index(k),4);
               rtemp(5)=rtemp(5)+temp2_t.rates(index(k),5);
               rtemp(6)=rtemp(6)+temp2_t.rates(index(k),6);
          end;
         rtemp=rtemp/numel(index); 
         rates(j,:)=rtemp;
        end;
    %% add electrodes with no events
    collection = "Electrodes_AES";
    test_query=['{"patient_id":"' patients{i} '"}'];
    ex_electrodes = distinct(conn,collection,"electrode",'Query',test_query);
    [C,IA] = setdiff(ex_electrodes,electrodes)
    Var1={''}
    Var2={''};
    Var3={''};
    Var4={''};
    rates=[];
    for j=1:numel(C)
     Var1{j}=temp2_t.Var1(1);
     Var2{j}=C(j);
     test_query=['{"patient_id":"' patients{i} '","electrode":"' C{j} '"}'];
     docs = find(conn,collection,'query',test_query,'limit',5000);
     Var3{j}=docs(1).soz;
     Var4{j}=docs(1).mt;
     rates(j,:)=zeros(1,6);
    end;
    temp3ex_t=table(Var1', Var2', Var3', Var4', rates);
    temp3_t=vertcat(temp3_t, temp3ex_t);
    output_t=vertcat(output_t,temp3_t);   
   end;      
end;
