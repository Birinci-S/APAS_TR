function [ref_ZTD]=read_Troposphere(filename,stationName)


%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci



ref_ZTD=[];



File =fopen (filename,'r');
if File<0
    error('The Troposphere file is not found. The Troposphere file name is false!!')
end



satir = fgets(File);
i=1;



while ischar(satir)
    t(i).line =satir ;
    if length(t(i).line)>13 && strcmp(cellstr(t(i).line(1:14)),'+TROP/SOLUTION')
        fistLine=i;

    end
    satir=fgets(File);
    i=i+1;
end
fclose(File);



count_sta=1;
for ii=fistLine+1:length(t)


    if strcmp(cellstr(t(ii).line(2:5)),stationName)
        epoch=cell2mat(textscan(t(ii).line(17:19),'%f'))+cell2mat(textscan(t(ii).line(21:25),'%f'))/3600/24;
        ztd_value=cell2mat(textscan(t(ii).line(27:32),'%f'))/1000;

        ref_ZTD(count_sta,:)=[epoch ztd_value];
        count_sta=count_sta+1;
    end
end

end

