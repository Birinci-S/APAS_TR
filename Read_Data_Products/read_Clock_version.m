function [clk_version ] = read_Clock_version(filename)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

disp('Reading the clock file version..');
t =struct('line',{}); 
File =fopen (filename,'r');
if File<0
   error('The clock file is not found. The clock file name is false!!')
end

satir=fgets(File); 
 t(1).line=satir;

         clk_version=cell2mat((textscan(t(1).line(1:9),'%f')));
   
fclose(File);

disp('The clock file version was read....');
end