
function[ground_truth_coor,ref_coord_std]=read_Sinex2(filename,stationName)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

disp('Reading the Sinex file............');

ref_coord=[];
ref_coord_std=[];

File =fopen (filename,'r');
if File<0
    error('The Sinex file is not found. The Sinex file name is false!!')
end


satir = fgets(File);
i=1;



while ischar(satir)
    t(i).line =satir ;
    if length(t(i).line)>17 && strcmp(cellstr(t(i).line(1:18)),'+SOLUTION/ESTIMATE')
        fistLine=i;

    elseif length(t(i).line)>17 && strcmp(cellstr(t(i).line(1:18)),'-SOLUTION/ESTIMATE')
        lastLine=i;
        break;
    end
    satir=fgets(File);
    i=i+1;
end
fclose(File);






for ii=fistLine+1:lastLine


    if strcmp(cellstr(t(ii).line(8:11)),'STAX') && strcmp(cellstr(t(ii).line(15:18)),stationName)

        ref_coord=[cell2mat(textscan(t(ii).line(48:68),'%f'))
            cell2mat(textscan(t(ii+1).line(48:68),'%f'));
            cell2mat(textscan(t(ii+2).line(48:68),'%f'))];


        ref_coord_std=sqrt((cell2mat(textscan(t(ii).line(70:80),'%f')))^2+(cell2mat(textscan(t(ii+1).line(70:80),'%f')))^2+...
            (cell2mat(textscan(t(ii+2).line(70:80),'%f')))^2);

    end


end





if ~isempty(ref_coord)
    ground_truth_coor=ref_coord;
else
    ground_truth_coor=[];
    disp('The station may not an IGS point. Please, enter the station coordinates manually. ')

end