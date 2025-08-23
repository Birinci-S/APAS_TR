

function [data, zaman, recposition, antennaPosition, antenType, markerName]=read_Rinex_Ver3(filename)


%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


disp('Reading the RINEX file............');

t =struct('line',{});
File =fopen (filename,'r');
if File<0
    error('The RINEX file is not found. The RINEX file name is false!!')
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



for ii=1:lastHeaderLine


    if strcmp(cellstr(t(ii).line(61:length(t(ii).line))),'MARKER NAME')
        markerName=string(textscan(t(ii).line(1:4),'%s'));
    end

    %     if strcmp(cellstr(t(ii).line(61:length(t(ii).line))),'REC # / TYPE / VERS')
    %         header.recieverType=string(textscan(t(ii).line(21:30),'%10c'));
    %     end

    if strcmp(cellstr(t(ii).line(61:length(t(ii).line))),'ANT # / TYPE')
        header.antennaType=deblank(string(t(ii).line(21:58)));
        antenType=header.antennaType;
    end

    if strcmp (cellstr(t(ii).line(61:length(t(ii).line))),'APPROX POSITION XYZ')
        header.approxPosition =cell2mat(textscan(t(ii).line(1:60),'%f %f %f'));
        recposition=header.approxPosition';
    end

    if strcmp (cellstr(t(ii).line(61:length(t(ii).line))),'ANTENNA: DELTA H/E/N')
        header.antennaPosition =cell2mat(textscan(t(ii).line(1:60),'%f %f %f'));
    end

    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'ANTENNA: DELTA H/E/N')
        antennaPosition=cell2mat((textscan(t(ii).line(1:60),'%f %f %f')));
    end

    % if strcmp (cellstr(t(ii).line(61:length(t(ii).line))),'TIME OF FIRST OBS')
    %     header.timeOfFirstObs =cell2mat(textscan(t(ii).line(1:60),'%f %f %f %f %f %f'));
    % end
    %
    % if strcmp (cellstr(t(ii).line(61:length(t(ii).line))),'TIME OF LAST OBS')
    %     header.timeOfLastObs =cell2mat(textscan(t(ii).line(1:60),'%f %f %f %f %f %f'));
    % end


    %***** GPS Observation Type******

    if strcmp (cellstr(t(ii).line(1:4)),'G')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{1,1}='G';
            typesOfObserv{1,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 && str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{1,1}='G';
            typesOfObserv{1,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{1,1}='G';
            typesOfObserv{1,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{1,1}='G';
            typesOfObserv{1,2}=fazlar;

        end
    end


    %***** GLONASS Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'R')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{2,1}='R';
            typesOfObserv{2,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{2,1}='R';
            typesOfObserv{2,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39   %%%16.10.2023
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{2,1}='R';
            typesOfObserv{2,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52   %%%16.10.2023
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{2,1}='R';
            typesOfObserv{2,2}=fazlar;

        end
    end

    %***** GALILEO Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'E')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{3,1}='E';
            typesOfObserv{3,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{3,1}='E';
            typesOfObserv{3,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{3,1}='E';
            typesOfObserv{3,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{3,1}='E';
            typesOfObserv{3,2}=fazlar;

        end
    end

    %***** BDS Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'C')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{4,1}='C';
            typesOfObserv{4,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{4,1}='C';
            typesOfObserv{4,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{4,1}='C';
            typesOfObserv{4,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{4,1}='C';
            typesOfObserv{4,2}=fazlar;

        end
    end

    %***** QZSS Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'J')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{5,1}='J';
            typesOfObserv{5,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{5,1}='J';
            typesOfObserv{5,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{5,1}='J';
            typesOfObserv{5,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{5,1}='J';
            typesOfObserv{5,2}=fazlar;

        end
    end

    %***** SBAS Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'S')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{6,1}='S';
            typesOfObserv{6,2}=fazlar{1,1};

        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{6,1}='S';
            typesOfObserv{6,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{6,1}='S';
            typesOfObserv{6,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{6,1}='S';
            typesOfObserv{6,2}=fazlar;
        end
    end

    %***** IRNSS Observation Type******
    if strcmp(cellstr(t(ii).line(1:4)),'I')
        if str2double(t(ii).line(5:6))<=13
            fazlar=textscan(t(ii).line(8:60),'%s');
            typesOfObserv{7,1}='I';
            typesOfObserv{7,2}=fazlar{1,1};
        elseif  str2double(t(ii).line(5:6))>13 &&  str2double(t(ii).line(5:6))<=26
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1}];
            typesOfObserv{7,1}='I';
            typesOfObserv{7,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>26 &&  str2double(t(ii).line(5:6))<=39
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1}];
            typesOfObserv{7,1}='I';
            typesOfObserv{7,2}=fazlar;

        elseif  str2double(t(ii).line(5:6))>39 &&  str2double(t(ii).line(5:6))<=52
            fazlar1=textscan(t(ii).line(8:60),'%s');
            fazlar2=textscan(t(ii+1).line(8:60),'%s');
            fazlar3=textscan(t(ii+2).line(8:60),'%s');
            fazlar4=textscan(t(ii+3).line(8:60),'%s');
            fazlar=[fazlar1{1,1};fazlar2{1,1};fazlar3{1,1};fazlar4{1,1}];
            typesOfObserv{7,1}='I';
            typesOfObserv{7,2}=fazlar;
        end
    end

end


%******************************************************************************************
s=1;

for r=lastHeaderLine+1:length(t)
    if strcmp(cellstr(t(r).line(1)),'>') && cell2mat(textscan(t(r).line(31:32),'%f'))==0  %%%% 16.01.2024
        timesPerEpoch(s,:)=cell2mat(textscan(t(r).line(3:29),'%f %f %f %f %f %f'));
        epoch{s,1}=r;
        epoch{s,2}=cell2mat(textscan(t(r).line(34:35),'%f'));
        s=s+1;
    end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
zaman=NaN(length(timesPerEpoch),6);
for i=1:length(timesPerEpoch)
    dtA.year=timesPerEpoch(i,1);
    dtA.month=timesPerEpoch(i,2);
    dtA.day=timesPerEpoch(i,3);
    dtA.hour=timesPerEpoch(i,4);
    dtA.min=timesPerEpoch(i,5);
    dtA.sec=timesPerEpoch(i,6);

    dtA=timeCalculate(dtA);
    %[sec_of_week] =round(dtA.wsec);
    [sec_of_week] =(dtA.wsec);
    zaman(i,1)=sec_of_week;% GPS TIME
    zaman(i,2)=dtA.doy;
    zaman(i,3)=dtA.MJD;
    zaman(i,4)=timesPerEpoch(i,1);
    zaman(i,5)=timesPerEpoch(i,2);
    zaman(i,6)=timesPerEpoch(i,3);
    zaman(i,7)=timesPerEpoch(i,4);
    zaman(i,8)=timesPerEpoch(i,5);
    zaman(i,9)=timesPerEpoch(i,6);
end

aa=1;
bb=1;
satellites=cell(length(timesPerEpoch),1);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for ff=1:length(timesPerEpoch)
    for yy=epoch{ff,1}+1:(epoch{ff,1}+epoch{ff,2})
        satellites{ff,1}{aa,1}=t(yy).line(1:3);
        rawMeasurement{bb,1}=t(yy).line(4:length(t(yy).line));
        bb=bb+1;
        aa=aa+1;
        if aa>epoch{ff,2}
            aa=1;
        end
    end
end

maxdeger=1;
for hh=1:length(typesOfObserv)
    if length(typesOfObserv{hh,2})>maxdeger
        maxdeger=length(typesOfObserv{hh,2});
    end
end

columnWide=16*maxdeger;

newRawMeasurement=cell(length(rawMeasurement),1);
for ff=1:length(rawMeasurement)
    if length(rawMeasurement{ff,1})<=columnWide
        newRawMeasurement{ff,1}=char(string([rawMeasurement{ff,1} blanks(columnWide-length(rawMeasurement{ff,1}))]));
    elseif length(rawMeasurement{ff,1})>columnWide
        newRawMeasurement{ff,1}=char(string(deblank(rawMeasurement{ff,1})));
    end
end

observ=NaN(length(newRawMeasurement),maxdeger);
for vv=1:length(newRawMeasurement)
    if length(newRawMeasurement{vv,1}) < 16*maxdeger-2
        newRawMeasurement{vv,1}=char([newRawMeasurement{vv,1} blanks(16*maxdeger-2-length(newRawMeasurement{vv,1}))]);
    end
    for v2=1:maxdeger
        if str2double(deblank((newRawMeasurement{vv,1}((v2*16-15):(16*v2-2)))))~=0 %%% 15.09.2023
            observ(vv,v2)=str2double(deblank((newRawMeasurement{vv,1}((v2*16-15):(16*v2-2)))));
        end
    end
end

gpsgozlem=NaN; glonassgozlem=NaN; galileogozlem=NaN; beidougozlem=NaN;  qzssgozlem=NaN;
for ll=1:length(typesOfObserv)
    if typesOfObserv{ll,1}=='G'
        gpsgozlem=length(typesOfObserv{ll,2});
        typesGPS=typesOfObserv{ll,2}';
    elseif typesOfObserv{ll,1}=='R'
        glonassgozlem=length(typesOfObserv{ll,2});
        typesGLONASS=typesOfObserv{ll,2}';
    elseif typesOfObserv{ll,1}=='E'
        galileogozlem=length(typesOfObserv{ll,2});
        typesGALILEO=typesOfObserv{ll,2}';
    elseif typesOfObserv{ll,1}=='C'
        beidougozlem=length(typesOfObserv{ll,2});
        typesBEIDOU=typesOfObserv{ll,2}';
    elseif typesOfObserv{ll,1}=='J'
        qzssgozlem=length(typesOfObserv{ll,2});
        typesQZSS=typesOfObserv{ll,2}';
    end
end


gps=0;
glonass=0;
galileo=0;
beidou=0;
qzss=0;
sayac=1;
if ~isnan(gpsgozlem)
    for i=1:gpsgozlem
        gpsgozlemleri{1,i}=NaN(length(timesPerEpoch),32);
    end
end

if ~isnan(glonassgozlem)
    for i=1:glonassgozlem
        glonassgozlemleri{1,i}=NaN(length(timesPerEpoch),26);
    end
end

if ~isnan(galileogozlem)
    for i=1:galileogozlem
        galileogozlemleri{1,i}=NaN(length(timesPerEpoch),36);
    end
end

if ~isnan(beidougozlem)
    for i=1:beidougozlem
        beidougozlemleri{1,i}=NaN(length(timesPerEpoch),65);
    end
end

if ~isnan(qzssgozlem)
    for i=1:qzssgozlem
        qzssgozlemleri{1,i}=NaN(length(timesPerEpoch),10);
    end
end


for r1=1:length(timesPerEpoch)

    for rr=1:length(satellites{r1,1})
        if strcmp(satellites{r1,1}{rr,1}(1:1),'G')
            gps=1;
            sutunyeri=str2double(satellites{r1,1}{rr,1}(2:3));
            for r0=1:gpsgozlem
                gpsgozlemleri{1,r0}(r1,sutunyeri)=observ(sayac,r0);

            end
        end

        if strcmp(satellites{r1,1}{rr,1}(1:1),'R')
            glonass=3;
            sutunyeri=str2double(satellites{r1,1}{rr,1}(2:3));
            for r0=1:glonassgozlem
                glonassgozlemleri{1,r0}(r1,sutunyeri)=observ(sayac,r0);

            end
        end

        if strcmp(satellites{r1,1}{rr,1}(1:1),'E')
            galileo=2;
            sutunyeri=str2double(satellites{r1,1}{rr,1}(2:3));
            for r0=1:galileogozlem
                galileogozlemleri{1,r0}(r1,sutunyeri)=observ(sayac,r0);
            end
        end

        if strcmp(satellites{r1,1}{rr,1}(1:1),'C')
            beidou=4;
            sutunyeri=str2double(satellites{r1,1}{rr,1}(2:3));
            for r0=1:beidougozlem
                beidougozlemleri{1,r0}(r1,sutunyeri)=observ(sayac,r0);

            end
        end


        if strcmp(satellites{r1,1}{rr,1}(1:1),'J')
            qzss=5;
            sutunyeri=str2double(satellites{r1,1}{rr,1}(2:3));
            for r0=1:qzssgozlem
                qzssgozlemleri{1,r0}(r1,sutunyeri)=observ(sayac,r0);

            end
        end
        sayac=sayac+1;
    end
end

sistem=[gps;glonass;galileo;beidou;qzss];
for sst=1:length(sistem)
    if sistem(sst,1)==1
        GPS=[typesGPS;gpsgozlemleri];
        data.GPS=GPS;
    elseif sistem(sst,1)==3
        GLONASS=[typesGLONASS;glonassgozlemleri];
        data.GLONASS=GLONASS;
    elseif sistem(sst,1)==2
        GALILEO=[typesGALILEO;galileogozlemleri];
        data.GALILEO=GALILEO;
    elseif sistem(sst,1)==4
        BEIDOU=[ typesBEIDOU;beidougozlemleri];
        data.BEIDOU=BEIDOU;
    elseif sistem(sst,1)==5
        QZSS=[ typesQZSS;qzssgozlemleri];
        data.QZSS=QZSS;
    end
end
disp('The RINEX file was read...');


end

