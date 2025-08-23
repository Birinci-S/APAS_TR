function [DCB_GPS,DCB_GLO, DCB_GAL, DCB_BDS]=read_DCB_File(filename)


%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

disp('Reading the DCB file............');
t =struct('line',{});
File =fopen (filename,'r');
if File<0 || ~strcmp(filename(length(filename)-3:length(filename)),'.BSX')
    error('The DCB file is not found. Please select a file with .BSX extension..!')
end

satir = fgets(File);
i=1;

while ischar(satir)
    t(i).line =satir ;
    if strcmp(cellstr(t(i).line(1:14)),'+BIAS/SOLUTION')
        lastHeaderLine=i+1;
    end

    if strcmp(cellstr(t(i).line(2:12)),'DSB  G    G')
        sonsatir=i;
        break;
    end

    satir=fgets(File);
    i=i+1;
end
fclose(File);


DCB_GPS{1,1}='C1C  C1W';
DCB_GPS{1,2}='C2C  C2W';
DCB_GPS{1,3}='C2W  C2S';
DCB_GPS{1,4}='C2W  C2L';
DCB_GPS{1,5}='C2W  C2X';
DCB_GPS{1,6}='C1C  C2W';
DCB_GPS{1,7}='C1C  C5Q';
DCB_GPS{1,8}='C1C  C5X';
DCB_GPS{1,9}='C1W  C2W';




for r=lastHeaderLine+1:sonsatir-1
    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C1C  C1W')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,1}(1,satNo)=str2double(t(r).line(82:93));
    end



    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C2C  C2W')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,2}(1,satNo)=str2double(t(r).line(82:93));
    end



    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C2W  C2S')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,3}(1,satNo)=str2double(t(r).line(82:93));
    end




    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C2W  C2L')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,4}(1,satNo)=str2double(t(r).line(82:93));
    end



    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C2W  C2X')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,5}(1,satNo)=str2double(t(r).line(82:93));
    end



    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C1C  C2W')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,6}(1,satNo)=str2double(t(r).line(82:93));
    end



    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C1C  C5Q')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,7}(1,satNo)=str2double(t(r).line(82:93));
    end


    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C1C  C5X')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,8}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'G') && strcmp(cellstr(t(r).line(26:33)),'C1W  C2W')
        satNo=str2double(t(r).line(13:14));
        DCB_GPS{2,9}(1,satNo)=str2double(t(r).line(82:93));
    end
end


DCB_GLO{1,1}='C1C  C1P';
DCB_GLO{1,2}='C2C  C2P';
DCB_GLO{1,3}='C1C  C2C';
DCB_GLO{1,4}='C1C  C2P';
DCB_GLO{1,5}='C1P  C2P';



for r=lastHeaderLine+1:sonsatir-1
    if strcmp(cellstr(t(r).line(12)),'R') && strcmp(cellstr(t(r).line(26:33)),'C1C  C1P')
        satNo=str2double(t(r).line(13:14));
        DCB_GLO{2,1}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'R') && strcmp(cellstr(t(r).line(26:33)),'C2C  C2P')
        satNo=str2double(t(r).line(13:14));
        DCB_GLO{2,2}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'R') && strcmp(cellstr(t(r).line(26:33)),'C1C  C2C')
        satNo=str2double(t(r).line(13:14));
        DCB_GLO{2,3}(1,satNo)=str2double(t(r).line(82:93));
    end


    if strcmp(cellstr(t(r).line(12)),'R') && strcmp(cellstr(t(r).line(26:33)),'C1C  C2P')
        satNo=str2double(t(r).line(13:14));
        DCB_GLO{2,4}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'R') && strcmp(cellstr(t(r).line(26:33)),'C1P  C2P')
        satNo=str2double(t(r).line(13:14));
        DCB_GLO{2,5}(1,satNo)=str2double(t(r).line(82:93));
    end
end





DCB_GAL{1,1}='C1C  C5Q';
DCB_GAL{1,2}='C1C  C6C';
DCB_GAL{1,3}='C1C  C7Q';
DCB_GAL{1,4}='C1X  C5X';
DCB_GAL{1,5}='C1X  C7X';



for r=lastHeaderLine+1:sonsatir-1
    if strcmp(cellstr(t(r).line(12)),'E') && strcmp(cellstr(t(r).line(26:33)),'C1C  C5Q')
        satNo=str2double(t(r).line(13:14));
        DCB_GAL{2,1}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'E') && strcmp(cellstr(t(r).line(26:33)),'C1C  C6C')
        satNo=str2double(t(r).line(13:14));
        DCB_GAL{2,2}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'E') && strcmp(cellstr(t(r).line(26:33)),'C1C  C7Q')
        satNo=str2double(t(r).line(13:14));
        DCB_GAL{2,3}(1,satNo)=str2double(t(r).line(82:93));
    end


    if strcmp(cellstr(t(r).line(12)),'E') && strcmp(cellstr(t(r).line(26:33)),'C1X  C5X')
        satNo=str2double(t(r).line(13:14));
        DCB_GAL{2,4}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'E') && strcmp(cellstr(t(r).line(26:33)),'C1X  C7X')
        satNo=str2double(t(r).line(13:14));
        DCB_GAL{2,5}(1,satNo)=str2double(t(r).line(82:93));
    end
end







DCB_BDS{1,1}='C2I  C7I';
DCB_BDS{1,2}='C2I  C6I';
DCB_BDS{1,3}='C1X  C5X';
DCB_BDS{1,4}='C1P  C5P';



for r=lastHeaderLine+1:sonsatir-1
    if strcmp(cellstr(t(r).line(12)),'C') && strcmp(cellstr(t(r).line(26:33)),'C2I  C7I')
        satNo=str2double(t(r).line(13:14));
        DCB_BDS{2,1}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'C') && strcmp(cellstr(t(r).line(26:33)),'C2I  C6I')
        satNo=str2double(t(r).line(13:14));
        DCB_BDS{2,2}(1,satNo)=str2double(t(r).line(82:93));
    end

    if strcmp(cellstr(t(r).line(12)),'C') && strcmp(cellstr(t(r).line(26:33)),'C1X  C5X')
        satNo=str2double(t(r).line(13:14));
        DCB_BDS{2,3}(1,satNo)=str2double(t(r).line(82:93));
    end


    if strcmp(cellstr(t(r).line(12)),'C') && strcmp(cellstr(t(r).line(26:33)),'C1P  C5P')
        satNo=str2double(t(r).line(13:14));
        DCB_BDS{2,4}(1,satNo)=str2double(t(r).line(82:93));
    end


end


disp('The DCB file was read...');


end





