
function [version_Rinex]=rinex_Version(filename)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci



version_Rinex=[];
t=struct('line',{});


File=fopen(filename,'r');

if File<0
    error('The RINEX file is not found. The RINEX file name is false!!')
end

rows=fgets(File);
t(1).line=rows;


fclose(File);


if strcmp(cellstr((t(1).line(61:length(t(1).line)))),'RINEX VERSION / TYPE')
    version_Rinex=ceil(cell2mat((textscan(t(1).line(6:9),'%d'))));
end
disp('The RINEX version was read...');

end


