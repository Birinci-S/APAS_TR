function [satOffset, recOffset]=read_AntexFile(MJD,filename,antenName)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

GPS_rec={};
GLONASS_rec={};
disp('Reading the Antenna file............');

t =struct('line',{});
File =fopen (filename,'r');
if File<0
    error('The antenna file is not found. The antenna file name is false!!')
end

rows = fgets(File);
i=1;

while ischar(rows)
    t(i).line =rows ;
    if strcmp(cellstr(t(i).line(61:length(t(i).line))),'END OF HEADER')
        lastHeaderLine=i;
    end
    rows=fgets(File);
    i=i+1;
end
fclose(File);


for j=lastHeaderLine+2:length(t)
    if strcmp(cellstr(t(j).line(1:7)),'GLONASS')
        endofGPS=j;
        break;
    end
end

for jj=endofGPS:length(t)
    if strcmp(cellstr(t(jj).line(1:7)),'GALILEO')
        endofGLONASS=jj;
        break
    end
end

for jj=endofGLONASS:length(t)
    if strcmp(cellstr(t(jj).line(1:6)),'BEIDOU')
        endofGALILEO=jj;
        break
    end
end

for jj=endofGALILEO:length(t)
    if strcmp(cellstr(t(jj).line(1:4)),'QZSS')
        endofBEIDOU=jj;
        break
    end
end


for jj=endofBEIDOU:length(t)
    if strcmp(cellstr(t(jj).line(1:5)),'IRNSS')
        endofQZSS=jj;
        break
    end
end

%******************************************************************************************************************
%GPS satellites antenna offsets
%******************************************************************************************************************

sayac=1;
sayac2=1;
for k=lastHeaderLine:endofGPS-1
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'TYPE / SERIAL NO')
        satName=cell2mat(textscan(t(k).line(22:23),'%f'));
        satValue(sayac2,1)=satName;

        if sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) == 0)

            sayac=sayac+1;
        elseif sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) ~= 0)
            sayac=1;
        end
        sayac2=sayac2+1;
    end
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL')
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f')); %valid from date
        dtA.year=deger(1,1);%year
        dtA.month=deger(1,2);%month
        dtA.day=deger(1,3);%day
        dtA.hour=deger(1,4);%hour
        dtA.min=deger(1,5);%minute
        dtA.sec=deger(1,6);%second
        dtA=date2GPS(dtA);%GPS time converter
        GPS{1,satName}{sayac,1}=dtA.MJD; %modified Julian day
        deger=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f %f %f %f')); %valid until day
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GPS{1,satName}{sayac,2}=dtA.MJD;
    elseif  strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && (strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL'))==0
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GPS{1,satName}{sayac,1}=dtA.MJD;%valid from
        GPS{1,satName}{sayac,2} = (juliandate(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'),'modifiedjuliandate'));
    end


    %GPS output:
    % //1.=valid from // 2.=valid until // 3.=L1  north east up // 4.= L2  north east up
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'G01') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP') %L1 frequency
        GPS{1,satName}{sayac,3}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f')); % north east up
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'G02') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP') % L2 frequency
        GPS{1,satName}{sayac,4}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    end
end

% %******************************************************************************************************************
% %GLONASS satellites antenna offsets
% %******************************************************************************************************************
for k=endofGPS:endofGLONASS-1
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'TYPE / SERIAL NO')
        satName=cell2mat(textscan(t(k).line(22:23),'%f'));
        satValue(sayac2,1)=satName;

        if sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) == 0)
            sayac=sayac+1;
        elseif sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) ~= 0)
            sayac=1;
        end
        sayac2=sayac2+1;
    end
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL')
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GLONASS{1,satName}{sayac,1}=dtA.MJD;
        deger=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GLONASS{1,satName}{sayac,2}=dtA.MJD;
    elseif  strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && (strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL'))==0
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GLONASS{1,satName}{sayac,1}=dtA.MJD;
        GLONASS{1,satName}{sayac,2} = (juliandate(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'),'modifiedjuliandate'));
    end



    %GLONASS  output:
    % //1.=valid from // 2.=valid until // 3.=L1  north east up // 4.= L2  north east up

    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'R01') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GLONASS{1,satName}{sayac,3}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'R02') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GLONASS{1,satName}{sayac,4}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    end
end


%******************************************************************************************************************
%GALILEO satellite antenna offsets
%******************************************************************************************************************

for k=endofGLONASS:endofGALILEO-1
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'TYPE / SERIAL NO')
        satName=cell2mat(textscan(t(k).line(22:23),'%f'));
        satValue(sayac2,1)=satName;

        if sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) == 0)
            sayac=sayac+1;
        elseif sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) ~= 0)
            sayac=1;
        end
        sayac2=sayac2+1;
    end
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL')
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GALILEO{1,satName}{sayac,1}=dtA.MJD;
        deger=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GALILEO{1,satName}{sayac,2}=dtA.MJD;
    elseif  strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && (strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL'))==0
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        GALILEO{1,satName}{sayac,1}=dtA.MJD;
        GALILEO{1,satName}{sayac,2} = (juliandate(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'),'modifiedjuliandate'));
    end


    %GALILEO  output:
    % //1.=valid from // 2.=valid until // 3.=E5A-1 için north east up // 4.= E5B-1 için north east up  // 5.= E6-C için north east up
    %6.= E1-C için north east up // %7.= E5-Q için north east up

    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'E05') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GALILEO{1,satName}{sayac,3}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));



        %         sayac3=1;
        %         for yy=k+3:k+75
        %             if (strcmp(cellstr(t(yy).line(4)),'E'))~= 1
        %             GALILEO{1,satName}{sayac+1,3}(sayac3,:)=  cell2mat(textscan(t(yy).line(1:length(t(yy).line)),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'));
        %             sayac3=sayac3+1;
        %             end
        %         end





    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'E07') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GALILEO{1,satName}{sayac,4}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'E06') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GALILEO{1,satName}{sayac,5}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'E01') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GALILEO{1,satName}{sayac,6}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'E08') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        GALILEO{1,satName}{sayac,7}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    end
end

% %******************************************************************************************************************
% %BEIDOU satellite antenna offsets
% %******************************************************************************************************************

for k=endofGALILEO:endofBEIDOU-1
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'TYPE / SERIAL NO')
        satName=cell2mat(textscan(t(k).line(22:23),'%f'));
        satValue(sayac2,1)=satName;

        if sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) == 0)
            sayac=sayac+1;
        elseif sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) ~= 0)
            sayac=1;
        end
        sayac2=sayac2+1;
    end
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL')
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        BEIDOU{1,satName}{sayac,1}=dtA.MJD;
        deger=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        BEIDOU{1,satName}{sayac,2}=dtA.MJD;
    elseif  strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && (strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL'))==0
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        BEIDOU{1,satName}{sayac,1}=dtA.MJD;
        BEIDOU{1,satName}{sayac,2} = (juliandate(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'),'modifiedjuliandate'));
    end


    %BEIDOU  output:
    % //1.=valid from // 2.=valid until // 3.=C01 için north east up // 4.= C02 için north east up  // 5.= C06 için north east up
    %6.= C07 için north east up

    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'C01') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        BEIDOU{1,satName}{sayac,3}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'C02') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        BEIDOU{1,satName}{sayac,4}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));

    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'C05') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        BEIDOU{1,satName}{sayac,5}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));

    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'C06') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        BEIDOU{1,satName}{sayac,6}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'C07') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        BEIDOU{1,satName}{sayac,7}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));

    end
end



%******************************************************************************************************************
%QZSS antenna offset
%******************************************************************************************************************
for k=endofBEIDOU:endofQZSS-1
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'TYPE / SERIAL NO')
        satName=cell2mat(textscan(t(k).line(22:23),'%f'));
        satValue(sayac2,1)=satName;

        if sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) == 0)
            sayac=sayac+1;
        elseif sayac2>=2 &&  ((satValue(sayac2,1) - satValue(sayac2-1,1)) ~= 0)
            sayac=1;
        end
        sayac2=sayac2+1;
    end
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL')
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        QZSS{1,satName}{sayac,1}=dtA.MJD;
        deger=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        QZSS{1,satName}{sayac,2}=dtA.MJD;
    elseif  strcmp(cellstr(t(k).line(61:length(t(k).line))),'VALID FROM') && (strcmp(cellstr(t(k+1).line(61:length(t(k).line))),'VALID UNTIL'))==0
        deger=cell2mat(textscan(t(k).line(1:60),'%f %f %f %f %f %f'));
        dtA.year=deger(1,1);
        dtA.month=deger(1,2);
        dtA.day=deger(1,3);
        dtA.hour=deger(1,4);
        dtA.min=deger(1,5);
        dtA.sec=deger(1,6);
        dtA=date2GPS(dtA);
        QZSS{1,satName}{sayac,1}=dtA.MJD;
        QZSS{1,satName}{sayac,2} = (juliandate(datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z'),'modifiedjuliandate'));
    end


    %QZSS  output:
    % //1.=valid from // 2.=valid until // 3.=J01 için north east up // 4.= J02 için north east up  // 5.= J05 için north east up
    %6.= J06 için north east up
    if strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'J01') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        QZSS{1,satName}{sayac,3}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'J02') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        QZSS{1,satName}{sayac,4}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'J05') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        QZSS{1,satName}{sayac,5}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    elseif strcmp(cellstr(t(k).line(61:length(t(k).line))),'START OF FREQUENCY') && strcmp(cellstr(t(k).line(4:6)),'J06') && ...
            strcmp(cellstr(t(k+1).line(61:length(t(k+1).line))),'NORTH / EAST / UP')
        QZSS{1,satName}{sayac,6}=cell2mat(textscan(t(k+1).line(1:60),'%f %f %f'));
    end
end


%GPS
GPS_sat=cell(1,length(GPS));
for b=1:length(GPS)
    for bb=1:size(GPS{1,b},1)
        if GPS{1,b}{bb,1}<=MJD &&  GPS{1,b}{bb,2}>=MJD
            GPS_sat{1,b}{1,1}=(GPS{1,b}{bb,3})';
            GPS_sat{1,b}{1,2}=(GPS{1,b}{bb,4})';
        end
    end
end

%GLONASS
GLONASS_sat=cell(1,length(GLONASS));
for b=1:length(GLONASS)
    for bb=1:size(GLONASS{1,b},1)
        if GLONASS{1,b}{bb,1}<=MJD &&  GLONASS{1,b}{bb,2}>=MJD
            GLONASS_sat{1,b}{1,1}=(GLONASS{1,b}{bb,3})';
            GLONASS_sat{1,b}{1,2}=(GLONASS{1,b}{bb,4})';
        end
    end
end

%Galileo
GALILEO_sat=cell(1,length(GALILEO));
for b=1:length(GALILEO)
    for bb=1:size(GALILEO{1,b},1)
        if GALILEO{1,b}{bb,1}<=MJD &&  GALILEO{1,b}{bb,2}>=MJD
            GALILEO_sat{1,b}{1,1}=(GALILEO{1,b}{bb,3})';
            GALILEO_sat{1,b}{1,2}=(GALILEO{1,b}{bb,4})';
            GALILEO_sat{1,b}{1,3}=(GALILEO{1,b}{bb,5})';
            GALILEO_sat{1,b}{1,4}=(GALILEO{1,b}{bb,6})';
            GALILEO_sat{1,b}{1,5}=(GALILEO{1,b}{bb,7})';
        end
    end
end

%BDS
BEIDOU_sat=cell(1,length(BEIDOU));
for b=1:length(BEIDOU)
    for bb=1:size(BEIDOU{1,b},1)
        if BEIDOU{1,b}{bb,1}<=MJD &&  BEIDOU{1,b}{bb,2}>=MJD
            BEIDOU_sat{1,b}{1,1}=(BEIDOU{1,b}{bb,3})';
            BEIDOU_sat{1,b}{1,2}=(BEIDOU{1,b}{bb,4})';
            BEIDOU_sat{1,b}{1,3}=(BEIDOU{1,b}{bb,5})';
            BEIDOU_sat{1,b}{1,4}=(BEIDOU{1,b}{bb,6})';
            BEIDOU_sat{1,b}{1,5}=(BEIDOU{1,b}{bb,7})';
        end
    end
end




%QZSS
QZSS_sat=cell(1,length(QZSS));
for b=1:length(QZSS)
    for bb=1:size(QZSS{1,b},1)
        if QZSS{1,b}{bb,1}<=MJD &&  QZSS{1,b}{bb,2}>=MJD
            QZSS_sat{1,b}{1,1}=(QZSS{1,b}{bb,3})';
            QZSS_sat{1,b}{1,2}=(QZSS{1,b}{bb,4})';
            QZSS_sat{1,b}{1,3}=(QZSS{1,b}{bb,5})';
            QZSS_sat{1,b}{1,4}=(QZSS{1,b}{bb,6})';
        end
    end
end

satOffset.GPS=GPS_sat;
satOffset.GLONASS=GLONASS_sat;
satOffset.GALILEO=GALILEO_sat;
satOffset.BEIDOU=BEIDOU_sat;
satOffset.QZSS=QZSS_sat;


%///////////////////////////////////////////////////////////////////////////////////////////////////////////
%for receiver antenna
%///////////////////////////////////////////////////////////////////////////////////////////////////////////
firstLine=NaN;

for s=endofQZSS:length(t)
    if strcmp(cellstr(t(s).line(1:60)),antenName)
        firstLine=s-1;
    end
end

if isnan(firstLine)
    antenName2=char(antenName);
    antenName2(17:end)='NONE';
    antenName=string(antenName2);
    msgbox('Antenna Type Name was revised!!')
end


for s=endofQZSS:length(t)
    if strcmp(cellstr(t(s).line(1:60)),antenName)
        firstLine=s-1;
    end
end


for ss=firstLine:length(t)
    if strcmp(cellstr(t(ss).line(61:length(t(ss).line))),'END OF ANTENNA')
        endLine=ss;
        break ;
    end
end


for y=firstLine:endLine
    if strcmp(cellstr(t(y).line(61:length(t(y).line))),'START OF FREQUENCY') && strcmp(cellstr(t(y).line(4:6)),'G01') && ...
            strcmp(cellstr(t(y+1).line(61:length(t(y+1).line))),'NORTH / EAST / UP')
        GPS_rec{1,1}=(cell2mat(textscan(t(y+1).line(1:60),'%f %f %f')))';
        sayac3=1;

        if strcmp(cellstr(t(y+3).line(61:length(t(y+3).line))),'END OF FREQUENCY')
            GPS_rec{1,2}(1:73,1)=0:5:360;
            GPS_rec{1,2}(1:73,2:19)=0;
            msgbox('No Antenna PC0!!');
        else

            for yy=y+3:y+75
                GPS_rec{1,2}(sayac3,:)=  cell2mat(textscan(t(yy).line(1:length(t(yy).line)),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'));
                sayac3=sayac3+1;
            end
        end
    end



    if strcmp(cellstr(t(y).line(61:length(t(y).line))),'START OF FREQUENCY') && strcmp(cellstr(t(y).line(4:6)),'G02') && ...
            strcmp(cellstr(t(y+1).line(61:length(t(y+1).line))),'NORTH / EAST / UP')
        GPS_rec{2,1}=(cell2mat(textscan(t(y+1).line(1:60),'%f %f %f')))';
        sayac3=1;
        if strcmp(cellstr(t(y+3).line(61:length(t(y+3).line))),'END OF FREQUENCY')
            GPS_rec{2,2}(1:73,1)=0:5:360;
            GPS_rec{2,2}(1:73,2:19)=0;
            disp('No Antenna PC0!!');
        else


            for yy=y+3:y+75
                GPS_rec{2,2}(sayac3,:)=  cell2mat(textscan(t(yy).line(1:length(t(yy).line)),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'));
                sayac3=sayac3+1;
            end
        end
    end


    %%%GLONASS
    if strcmp(cellstr(t(y).line(61:length(t(y).line))),'START OF FREQUENCY') && strcmp(cellstr(t(y).line(4:6)),'R01') && ...
            strcmp(cellstr(t(y+1).line(61:length(t(y+1).line))),'NORTH / EAST / UP')
        GLONASS_rec{1,1}=(cell2mat(textscan(t(y+1).line(1:60),'%f %f %f')))';
        sayac3=1;


        if strcmp(cellstr(t(y+3).line(61:length(t(y+3).line))),'END OF FREQUENCY')
            GLONASS_rec{1,2}(1:73,1)=0:5:360;
            GLONASS_rec{1,2}(1:73,2:19)=0;
            disp('No Antenna PC0!!');
        else

            for yy=y+3:y+75
                GLONASS_rec{1,2}(sayac3,:)=  cell2mat(textscan(t(yy).line(1:length(t(yy).line)),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'));
                sayac3=sayac3+1;
            end
        end
    end

    if strcmp(cellstr(t(y).line(61:length(t(y).line))),'START OF FREQUENCY') && strcmp(cellstr(t(y).line(4:6)),'R02') && ...
            strcmp(cellstr(t(y+1).line(61:length(t(y+1).line))),'NORTH / EAST / UP')
        GLONASS_rec{2,1}=(cell2mat(textscan(t(y+1).line(1:60),'%f %f %f')))';
        sayac3=1;

        if strcmp(cellstr(t(y+3).line(61:length(t(y+3).line))),'END OF FREQUENCY')
            GLONASS_rec{2,2}(1:73,1)=0:5:360;
            GLONASS_rec{2,2}(1:73,2:19)=0;
            disp('No Antenna PC0!!');
        else

            for yy=y+3:y+75
                GLONASS_rec{2,2}(sayac3,:)=  cell2mat(textscan(t(yy).line(1:length(t(yy).line)),'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f'));
                sayac3=sayac3+1;
            end
        end
    end

end



if isempty(GPS_rec)
    recOffset.GPS=[0;0;0];
else
    recOffset.GPS=GPS_rec;
end

if isempty(GLONASS_rec)
    recOffset.GLONASS=[0;0;0];
else
    recOffset.GLONASS=GLONASS_rec;
end



disp('The Antenna file was read...');

end