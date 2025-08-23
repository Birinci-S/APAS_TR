
function store_PPPresults(output,stationName,combination)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

pre_path=pwd;

s = what('APAS_TR');
m_prog=s.path;

m_path=([m_prog '\Results_File' ]);
cd(m_path);
currentFolder = pwd;
% ~isfolder(string(stationName), 'dir')


if  ~isfolder(string(stationName))

    mkdir(stationName) ;
end



path_station=(currentFolder+"\"+string(stationName));
cd(path_station)




filename=string(datetime("now",'Format','dd-MM-yyyy HH-mm-ss'));
mkdir(filename);
path2 = pwd+"\"+filename;
cd(path2)


if combination==1; pre_text="GPS-";
elseif combination==2; pre_text="GR-";
elseif combination==3; pre_text="GE-";
elseif combination==4; pre_text="GRE-";
elseif combination==5; pre_text="GREC2-";
elseif combination==6; pre_text="GREC3-";
elseif combination==7; pre_text="GREC2C3-";
elseif combination==8; pre_text="GREC2C3J-";
end


fileID = fopen(pre_text+stationName+"-"+'results.txt','w');
fprintf(fileID,'APAS-TR PPP Solutions \n');
fprintf(fileID,'%s  Combination\n',pre_text);


fprintf(fileID,' Epoch   YEAR    DOY     Sec of GPSweek       X-coordinates   Y-coordinates   Z coordinates      GPS rec clkoff     ZTD         ISB-GLO       ISB-GAL        ISB-BDS2      ISB-BDS3        ISB-J\n'    );
fprintf(fileID,' -----   -----   ----    --------------       -------------   --------------  -------------      --------------    -------      ----------    ----------     -----------   ----------      -----------\n');



for i=1:size(output,1)
    fprintf(fileID,'%5.0d    %5.0d  %4.0d     %14.4f      %14.4f  %14.4f  %14.4f %16.8f %13.4f %13.6f  %13.6f   %13.6f %13.6f  %13.6f\n',output(i,:));
end


cd(pre_path)

end

