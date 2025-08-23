function [sp3data,sp3time]=read_Sp3(filename)


%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

disp('Reading the SP3 file............');
sp3data.GPS={};  sp3data.GLONASS={}; sp3data.GALILEO={};  sp3data.BEIDOU={}; sp3data.QZSS={};

t =struct('line',{});
File =fopen (filename,'r');
if File<0
    error('The SP3 file is not found. The SP3 file name is false!!');
end

rows = fgets(File);
i=1;



while ischar(rows)
    t(i).line =rows ;
    if strcmp(cellstr(t(i).line(1:2)),'/*')
        lastHeaderLine=i;
    end
    rows=fgets(File);
    i=i+1;
end
fclose(File);

for ii =1:lastHeaderLine
    if strcmp(cellstr(t(ii).line(1)),'+')
        sat_number=cell2mat(textscan(t(ii).line(4:7),'%f'));
        %sabit=ceil(sat_number/17);
        break;
    end

end

s=1;
for jj=lastHeaderLine+1:length(t)-1
    if strcmp(cellstr(t(jj).line(1)),'*')
        timesPerEpoch{s,:}=cell2mat(textscan(t(jj).line(4:31),'%f %f %f %f %f %f'));
        epoch{s,1}=jj;
        s=s+1;
    end

end


aa=1;
bb=1;
for ff=1:length(timesPerEpoch)
    for yy=epoch{ff,1}+1:(epoch{ff,1}+sat_number)
        satellites{ff,1}{aa,1}=t(yy).line(2:4);
        rawMeasurement{bb,1}=t(yy).line(5:length(t(yy).line));
        bb=bb+1;
        aa=aa+1;
        if aa>sat_number
            aa=1;
        end
    end
end

for ff=1:length(rawMeasurement)
    if length(rawMeasurement{ff,1})<=56
        newRawMeasurement{ff,1}=char(string([rawMeasurement{ff,1} blanks(sutunGenislik-length(rawMeasurement{ff,1}))]));
    elseif length(rawMeasurement{ff,1})>56
        newRawMeasurement{ff,1}=char(string(deblank(rawMeasurement{ff,1})));
    end
end

for kkk=1:length(newRawMeasurement)
    boyut(kkk,1)=length(newRawMeasurement{kkk,1});
end

observ=zeros(length(newRawMeasurement),4);
for vv=1:length(newRawMeasurement)
    for v2=1:4
        if v2<4
            observ(vv,v2)=str2num(deblank((newRawMeasurement{vv,1}((v2*14-13):(14*v2)))))*1000;
        elseif v2==4
            observ(vv,v2)=str2num(deblank((newRawMeasurement{vv,1}((v2*14-13):(14*v2)))));
        end
    end
end

gozlemSayisi=4 ;
veri{1,1}='X';
veri{1,2}='Y';
veri{1,3}='Z';
veri{1,4}='TIME';

logic1=false;
GPSsatellites=cell(1,gozlemSayisi);
for m1=1:gozlemSayisi
    for m2=1:length(satellites)

        if m2==1
            deger1=0;
        else
            deger1=deger1+sat_number;
        end
        for m3=1:length(satellites{m2,1})
            if satellites{m2,1}{m3,1}(1:1)=='G'
                logic1=true;
                sutun=str2double(satellites{m2,1}{m3,1}(2:3)); %satellite number
                GPSsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
            end
        end
    end
end
if logic1==true
    GPS=[veri;GPSsatellites]; % GPS sp3data
    sp3data.GPS=GPS;
end


logic2=false;
GLONASSsatellites=cell(1,gozlemSayisi);
for m1=1:gozlemSayisi
    for m2=1:length(satellites)
        if m2==1
            deger1=0;
        else
            deger1=deger1+sat_number;
        end
        for m3=1:length(satellites{m2,1})
            if satellites{m2,1}{m3,1}(1:1)=='R'
                logic2=true;
                sutun=str2double(satellites{m2,1}{m3,1}(2:3)); %satellite number
                GLONASSsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
            end
        end
    end
end
if logic2==true
    GLONASS=[veri;GLONASSsatellites]; % GLONASS sp3data
    sp3data.GLONASS=GLONASS;
end


% logic3=false;
% for m1=1:gozlemSayisi
%     for m2=1:length(satellites)
%        if m2==1
%            deger1=0;
%        else
%            deger1=deger1+sat_number;
%        end
%         for m3=1:length(satellites{m2,1})
%             if satellites{m2,1}{m3,1}(1:1)=='S'
%                 logic3=true;
%                 sutun=str2num(satellites{m2,1}{m3,1}(2:3)); %satellite number
%                 SBASsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
%             end
%         end
%     end
% end
% if logic3==true
% SBAS=[veri;SBASsatellites]; % SBAS sp3data
% sp3data.SBAS=SBAS;
% end

GALILEOsatellites=cell(1,gozlemSayisi);
logic4=false;
for m1=1:gozlemSayisi
    for m2=1:length(satellites)
        if m2==1
            deger1=0;
        else
            deger1=deger1+sat_number;
        end
        for m3=1:length(satellites{m2,1})
            if satellites{m2,1}{m3,1}(1:1)=='E'
                logic4=true;
                sutun=str2double(satellites{m2,1}{m3,1}(2:3)); %satellite number
                GALILEOsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
            end
        end
    end
end
if logic4==true
    GALILEO=[veri;GALILEOsatellites]; % Galileo sp3data
    sp3data.GALILEO=GALILEO;
end



logic5=false;
BEIDOUsatellites=cell(1,gozlemSayisi);
for m1=1:gozlemSayisi
    for m2=1:length(satellites)
        if m2==1
            deger1=0;
        else
            deger1=deger1+sat_number;
        end
        for m3=1:length(satellites{m2,1})
            if satellites{m2,1}{m3,1}(1:1)=='C'
                logic5=true;
                sutun=str2double(satellites{m2,1}{m3,1}(2:3)); %satellite number
                BEIDOUsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
            end
        end
    end
end
if logic5==true
    BEIDOU=[veri;BEIDOUsatellites]; % BDS sp3data
    sp3data.BEIDOU=BEIDOU;
end



logic6=false;
QZSSsatellites=cell(1,gozlemSayisi);
for m1=1:gozlemSayisi
    for m2=1:length(satellites)
        if m2==1
            deger1=0;
        else
            deger1=deger1+sat_number;
        end
        for m3=1:length(satellites{m2,1})
            if satellites{m2,1}{m3,1}(1:1)=='J'
                logic6=true;
                sutun=str2double(satellites{m2,1}{m3,1}(2:3)); %satellite number
                QZSSsatellites{1,m1}(m2,sutun)=observ( deger1+m3,m1);
            end
        end
    end
end

if logic6==true
    QZSS=[veri;QZSSsatellites]; % QZSS sp3data
    sp3data.QZSS=QZSS;
end

% logic7=false;
% for m1=1:gozlemSayisi
%     for m2=1:length(satellites)
%        if m2==1
%            deger1=0;
%        else
%            deger1=deger1+sat_number;
%        end
%         for m3=1:length(satellites{m2,1})
%             if satellites{m2,1}{m3,1}(1:1)=='I'
%                 logic7=true;
%                 sutun=str2num(satellites{m2,1}{m3,1}(2:3)); %satellite number
%                 IRNSSsatellites{1,m1}(m2,sutun)=observ(deger1+m3,m1);
%             end
%         end
%     end
% end
% if logic7 ==true
% IRNSS=[veri;IRNSSsatellites]; % IRNSS sp3data
% sp3data.IRNSS=IRNSS;
% end


sp3time= zeros(length(timesPerEpoch),1);
for i=1:length(timesPerEpoch)
    dtA.year=timesPerEpoch{i,1}(1);
    dtA.month=timesPerEpoch{i,1}(2);
    dtA.day=timesPerEpoch{i,1}(3);
    dtA.hour=timesPerEpoch{i,1}(4);
    dtA.min=timesPerEpoch{i,1}(5);
    dtA.sec=timesPerEpoch{i,1}(6);

    dtA=date2GPS(dtA);
    [sec_of_week] = (dtA.wsec);
    sp3time(i,1)=sec_of_week;%  GPS TIME
end




disp('The SP3 file was read...');

end
