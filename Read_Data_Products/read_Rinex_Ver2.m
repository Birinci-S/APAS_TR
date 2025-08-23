
function [data, zaman, recposition, antennaPosition, antenType, markerName]=read_Rinex_Ver2(filename)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


disp('Reading the RINEX file............');


t=struct('line',{});


File=fopen(filename,'r');

if File<0
    error('The RINEX file is not found. The RINEX file name is false!!')
end


i=1;
rows=fgets(File);
while ischar (rows)
    t(i).line=rows;

    if strcmp(cellstr(t(i).line(61:length(t(i).line))),'END OF HEADER')
        lastHeaderLine=i;
    end
    rows=fgets(File);
    i=i+1;

end

fclose(File);

for ii=1:lastHeaderLine

    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'MARKER NAME')
        markerName=string(textscan(t(ii).line(1:4),'%s'));
    end

    %     if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'REC # / TYPE / VERS')
    %         recieverType=string((textscan(t(ii).line(21:40),'%20c')));
    %     end
    %
    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'ANT # / TYPE')
        antenType=string((textscan(t(ii).line(21:40),'%20c')));
    end

    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'APPROX POSITION XYZ')
        approxPosition=cell2mat((textscan(t(ii).line(1:60),'%f %f %f')));
        recposition=approxPosition';
    end

    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'ANTENNA: DELTA H/E/N')
        antennaPosition=cell2mat((textscan(t(ii).line(1:60),'%f %f %f')));
    end

    if strcmp(cellstr((t(ii).line(61:length(t(ii).line)))),'TIME OF FIRST OBS')
        timeOfFirstObservation=cell2mat((textscan(t(ii).line(1:48),'%f %f %f %f %f %f')));
    end

end


for j=1:lastHeaderLine
    if strcmp((cellstr(t(j).line(61:length(t(j).line)))),'# / TYPES OF OBSERV')
        numberOftypesObservation=str2double(t(j).line(1:10));

        if  numberOftypesObservation<=9
            typesOfObservation=textscan(t(j).line(10:60),'%s');
            typesOfObservation=typesOfObservation{1,1};
        elseif  numberOftypesObservation>9 &&  numberOftypesObservation<=18
            typesOfObservation1=textscan(t(j).line(10:60),'%s');
            typesOfObservation2=textscan(t(j+1).line(10:60),'%s');
            typesOfObservation=[typesOfObservation1{1,1};typesOfObservation2{1,1}];
        elseif  numberOftypesObservation>18 &&  numberOftypesObservation<=27
            typesOfObservation1=textscan(t(j).line(10:60),'%s');
            typesOfObservation2=textscan(t(j+1).line(10:60),'%s');
            typesOfObservation3=textscan(t(j+2).line(10:60),'%s');
            typesOfObservation=[typesOfObservation1{1,1};typesOfObservation2{1,1};typesOfObservation3{1,1}];

        end
        typesOfObservation=typesOfObservation';

        break
    end
end




stringYear=num2str(timeOfFirstObservation);
sss=1;
for k=(lastHeaderLine+1):length(t)
    if length(t(k).line)>=3
        if strcmp (t(k).line(1:4), ([ ' ' stringYear(3:4) ' ' ]))
            constrows=ceil(str2double(t(k).line(30:32))/12);
            if constrows==1
                epochbilgi{sss,1}=t(k).line;
                epochbilgi{sss,2}=constrows;
                epochbilgi{sss,3}=k;
                sss=sss+1;

            elseif constrows==2
                epochbilgi{sss,1}=[t(k).line  t(k+1).line(33:length(t(k+1).line))];
                epochbilgi{sss,2}=constrows;
                epochbilgi{sss,3}=k;
                sss=sss+1;
            elseif constrows==3
                epochbilgi{sss,1}=[t(k).line  t(k+1).line(33:length(t(k+1).line)) t(k+2).line(33:length(t(k+2).line))];
                epochbilgi{sss,2}=constrows;
                epochbilgi{sss,3}=k;
                sss=sss+1;
            end
        end
    end

end
satellitesPerEpoch=cell(length(epochbilgi(:,1)),1);
timesPerEpoch=zeros(length(epochbilgi(:,1)),6);
for ff=1:length(epochbilgi(:,1))
    satellitesPerEpoch(ff,1)=textscan(strrep(epochbilgi{ff,1}(33:length(epochbilgi{ff,1})),' ','0'),'%3s');
    timesPerEpoch(ff,:)=cell2mat(textscan(epochbilgi{ff,1}(1:27),'%f %f %f %f %f %f'));
end



ekleyil=2000;
zaman=zeros(length(timesPerEpoch),4);
for i=1:length(timesPerEpoch)
    dtA.year=timesPerEpoch(i,1)+ekleyil;
    dtA.month=timesPerEpoch(i,2);
    dtA.day=timesPerEpoch(i,3);
    dtA.hour=timesPerEpoch(i,4);
    dtA.min=timesPerEpoch(i,5);
    dtA.sec=timesPerEpoch(i,6);

    dtA=timeCalculate(dtA);
    [sec_of_week] =(dtA.wsec);
    zaman(i,1)=sec_of_week;%  GPS TIME
    zaman(i,2)=dtA.doy;
    zaman(i,3)=dtA.MJD;
    zaman(i,4)=timesPerEpoch(i,1)+ekleyil;
    zaman(i,5)=timesPerEpoch(i,2);
    zaman(i,6)=timesPerEpoch(i,3);
    zaman(i,7)=timesPerEpoch(i,4);
    zaman(i,8)=timesPerEpoch(i,5);
    zaman(i,9)=timesPerEpoch(i,6);
end


%------------
sabitgozlem=ceil(numberOftypesObservation/5);
obsLine=1;
beginPerPoch=zeros(length(epochbilgi),1);
lastPerEpoch=zeros(length(epochbilgi),1);
for ll=1:length(epochbilgi)
    beginPerPoch(ll,1)=epochbilgi{ll,2}+epochbilgi{ll,3};
    lastPerEpoch(ll,1)=str2double(t(epochbilgi{ll,3}).line(30:32))*sabitgozlem+epochbilgi{ll,2}+epochbilgi{ll,3}-1;
    for bb=beginPerPoch(ll,1):lastPerEpoch(ll,1)
        if length(t(bb).line)<=80
            observationLines{obsLine,1}=string([t(bb).line blanks(80-length(t(bb).line))]);
            obsLine=1+obsLine;
        elseif length(t(bb).line)>80
            kontrol=deblank(t(bb).line);

            observationLines{obsLine,1}=string(deblank(t(bb).line));

            if length(kontrol) <80
                observationLines{obsLine,1}=string([t(bb).line blanks(80-length(t(bb).line))]);
            end
            obsLine=1+obsLine;
        end
    end

end

rawObservation=cell(length(observationLines)/sabitgozlem,1);
for nn=1:length(observationLines)/sabitgozlem

    rawObservation{nn,1}=char(strcat(observationLines{((nn*sabitgozlem-(sabitgozlem-1)):(nn*sabitgozlem)),1}));
end
observ=NaN(length(rawObservation),numberOftypesObservation);
for yy=1:length(rawObservation)
    for pp=1:numberOftypesObservation
        if str2double(deblank(rawObservation{yy,1}((pp*16-15):(pp*16-1)))) ~= 0
            observ(yy,pp)=str2double(deblank(rawObservation{yy,1}((pp*16-15):(pp*16-1))));
        end
    end
end


sayac=1;
gps=0;
glonass=0;
galileo=0;
beidou=0;
gpsgozlemleri=cell(1,numberOftypesObservation );
galileogozlemleri=cell(1,numberOftypesObservation );
glonassgozlemleri=cell(1,numberOftypesObservation );
beidougozlemleri=cell(1,numberOftypesObservation );
for i=1:numberOftypesObservation
    gpsgozlemleri{1,i}=NaN(length(timesPerEpoch),32);
    glonassgozlemleri{1,i}=NaN(length(timesPerEpoch),26);
    galileogozlemleri{1,i}=NaN(length(timesPerEpoch),36);
    beidougozlemleri{1,i}=NaN(length(timesPerEpoch),30);
end
for r=1:length(timesPerEpoch)

    for rr=1:length(satellitesPerEpoch{r,1})
        if strcmp(satellitesPerEpoch{r,1}{rr,1}(1:1),'G')
            gps=1;
            sutunyeri=str2double(satellitesPerEpoch{r,1}{rr,1}(2:3));

            for r0=1:numberOftypesObservation

                gpsgozlemleri{1,r0}(r,sutunyeri)=observ(sayac,r0);

            end
        end

        if strcmp(satellitesPerEpoch{r,1}{rr,1}(1:1),'E')
            galileo=3;
            sutunyeri=str2double(satellitesPerEpoch{r,1}{rr,1}(2:3));
            for r0=1:numberOftypesObservation
                galileogozlemleri{1,r0}(r,sutunyeri)=observ(sayac,r0);

            end
        end

        if strcmp(satellitesPerEpoch{r,1}{rr,1}(1:1),'R')
            glonass=2;
            sutunyeri=str2double(satellitesPerEpoch{r,1}{rr,1}(2:3));
            for r0=1:numberOftypesObservation
                glonassgozlemleri{1,r0}(r,sutunyeri)=observ(sayac,r0);

            end
        end
        if strcmp(satellitesPerEpoch{r,1}{rr,1}(1:1),'C')
            beidou=4;
            sutunyeri=str2double(satellitesPerEpoch{r,1}{rr,1}(2:3));
            for r0=1:numberOftypesObservation
                beidougozlemleri{1,r0}(r,sutunyeri)=observ(sayac,r0);

            end
        end

        sayac=sayac+1;
    end
end


sistem=[gps;glonass;galileo;beidou];
for sst=1:length(sistem)
    if sistem(sst,1)==1
        GPS=[typesOfObservation;gpsgozlemleri];
        data.GPS=GPS;
    elseif sistem(sst,1)==2
        GLONASS=[typesOfObservation;glonassgozlemleri];
        data.GLONASS=GLONASS;
    elseif sistem(sst,1)==3
        GALILEO=[typesOfObservation;galileogozlemleri];
        data.GALILEO=GALILEO;
    elseif sistem(sst,1)==4
        BEIDOU=[typesOfObservation;beidougozlemleri];
        data.BEIDOU=BEIDOU;
    end

end
disp('The RINEX file was read...');
end
