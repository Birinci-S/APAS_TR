function [clockdata,clocktime ] = read_ClockFile(filename)
disp('Reading the Clock file............');

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci
clockdata.GPS_clkbias={};
clockdata.GLONASS_clkbias={};
clockdata.GALILEO_clkbias={};
clockdata.BEIDOU_clkbias={};
clockdata.QZSS_clkbias={};




t =struct('line',{}); 
File =fopen (filename,'r');
if File<0 
     error('The clock file is not found. The clock file name is false!!')
end

rows = fgets(File);
i=1;

while ischar(rows)
    t(i).line =rows; 
    if strcmp(cellstr(t(i).line(61:length(t(i).line))),'END OF HEADER')
        lastHeaderLine=i;
    end
    
    rows=fgets(File);
    i=i+1;
end
fclose(File);


for r=lastHeaderLine+1:length(t)
    if strcmp((t(r).line(1:3)),'AS ')
        cyc_value=string(textscan(t(r).line(4:6),'%s'));
        break;
    end
end

sayac=1;
for ii=lastHeaderLine+1:length(t)
    if strcmp((t(ii).line(4:6)),cyc_value)
        zaman(sayac,:)= cell2mat(textscan(t(ii).line(9:34),'%f %f %f %f %f %f'));
        epochbilgi(sayac,1)=ii;
        sayac=sayac+1;
    end
    epochbilgi(sayac,1)=length(t);
end



gps=0;
glonass=0;
galileo=0;
beidou=0;
for p=1:length(zaman)
    for pp=epochbilgi(p,1): epochbilgi(p+1,1)-1
        if strcmp((t(pp).line(1:4)),'AS G')
            gps=1;
            columns=cell2mat(textscan(t(pp).line(5:6),'%f'));
            GPS_clk_bias(p,columns)=cell2mat(textscan(t(pp).line(41:59),'%f'));
        elseif strcmp((t(pp).line(1:4)),'AS R')
            glonass=1;
            columns=cell2mat(textscan(t(pp).line(5:6),'%f'));
            GLONASS_clk_bias(p,columns)=cell2mat(textscan(t(pp).line(41:59),'%f'));
            
        elseif strcmp((t(pp).line(1:4)),'AS E')
            galileo=1;
            columns=cell2mat(textscan(t(pp).line(5:6),'%f'));
            GAlILEO_clk_bias(p,columns)=cell2mat(textscan(t(pp).line(41:59),'%f'));
        elseif strcmp((t(pp).line(1:4)),'AS C')
            beidou=1;
            columns=cell2mat(textscan(t(pp).line(5:6),'%f'));
            BEIDOU_clk_bias(p,columns)=cell2mat(textscan(t(pp).line(41:59),'%f'));
        end
    end
end

clocktime=zeros(length(zaman),1);
 for i=1:length(zaman)
 dtA.year=zaman(i,1);
 dtA.month=zaman(i,2);
 dtA.day=zaman(i,3);
 dtA.hour=zaman(i,4);
 dtA.min=zaman(i,5);
 dtA.sec=zaman(i,6);
 
 dtA=timeCalculate(dtA);
     [sec_of_week] =(dtA.wsec);
     clocktime(i,1)=sec_of_week;%  GPS clocktime 
     %zaman(i,2)=dtA.doy;
 end
 
 if gps==1
 clockdata.GPS_clkbias=GPS_clk_bias;
 end
 if glonass==1
 clockdata.GLONASS_clkbias=GLONASS_clk_bias;
 end
 if galileo==1  
 clockdata.GALILEO_clkbias=GAlILEO_clk_bias;
 end
 if beidou==1
 clockdata.BEIDOU_clkbias=BEIDOU_clk_bias;
 end
 
disp('The Clock file was read...');
 toc;
end




