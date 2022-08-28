function Locs = mni2Locs(x,y,z)
    
    out = icbm_other2tal([x,y,z]);
    t = out(1);
    u = out(2);
    v = out(3);
    
    command = strcat('java -cp /data/downstate/dbmaintenance/talairach.jar org.talairach.PointToTD 4, ',num2str(t),',',num2str(u),',',num2str(v));
    
    [~,out] = system(command);
    
    reg1 = regexp(out,'Returned:','split');
    
    Locs = regexp(reg1{1,2},',','split');
    
    nogmstring = 'No Gray Matter found within +/-5mm';
    
    Locs = regexprep(Locs,'[\n\r]+','');
        
    nogm = strcmp(Locs,nogmstring);
    
    if nogm
        Locs = cell(1,5);
        if t <= 0, Locs{1,1} = 'Left Cerebrum'; end
        if t > 0, Locs{1,1} = 'Right Cerebrum'; end        
        Locs{1,4} = 'White Matter';
    end
end