function VMF1_parameter_Download(year, month,day)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

pre_path=pwd;

s = what('Troposphere_Modeling');
tro_path=s.path;
cd(tro_path)

currentFolder = pwd;
if  ~exist("VMF1_parameters", 'dir')

    mkdir VMF1_parameters ;
end



path_VMF1=(currentFolder+"\VMF1_parameters");
cd(path_VMF1)


year=num2str(year);

if month<10
    month=num2str(month);
    interval="0";
    month=interval+month;

end



if day<10
    day=num2str(day);
    interval="0";
    day=interval+day;

end



klasor=string(year);

if ~exist(klasor, 'dir')

    mkdir(klasor)
end

cd(path_VMF1+"\"+klasor)




ahdosyam1="VMFG_"+convertCharsToStrings(year(1:4))+convertCharsToStrings(month)+convertCharsToStrings(day)+".H00";
ahdosyam2="VMFG_"+convertCharsToStrings(year(1:4))+convertCharsToStrings(month)+convertCharsToStrings(day)+".H06";
ahdosyam3="VMFG_"+convertCharsToStrings(year(1:4))+convertCharsToStrings(month)+convertCharsToStrings(day)+".H12";
ahdosyam4="VMFG_"+convertCharsToStrings(year(1:4))+convertCharsToStrings(month)+convertCharsToStrings(day)+".H18";
ahfile={ahdosyam1;ahdosyam2;ahdosyam3;ahdosyam4};





myfile={ahfile};


for sss=1:4
    if ~isfile(myfile{1,1}{sss,1})
        url = "https://vmf.geo.tuwien.ac.at/trop_products/GRID/2.5x2/VMF1/VMF1_OP/"+year+"/"+myfile{1,1}{sss,1};
        filename =myfile{1,1}{sss,1};
        options=weboptions('Timeout',Inf);
        outfilename = websave(filename,url,options);
    end
end


cd(pre_path)

end