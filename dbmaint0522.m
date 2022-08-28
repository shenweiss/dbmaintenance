% DB Maintenance 0522

currentset={'IO001','IO002','IO004','IO005','IO006','IO008','IO009','IO010','IO012','IO013','IO014','IO015','IO017','IO018','IO019','IO021','IO022','IO023','IO024','IO025','IO027','2061','3162','4100','4110','4122','4124','4145','4150','4163','4166','448','449','451','453','456','458','463','466','467','468','470','473','474','475','477','478','479','480','481'};
server='localhost';
username='admin';
password='';
dbname='deckard_new';
port=27017;
conn = mongo(server,port,dbname,'UserName',username,'Password',password);
collection = "HFOs";
test_query=['{"resected":"1"}'];
values = distinct(conn,collection,'patient_id','Query',test_query)
