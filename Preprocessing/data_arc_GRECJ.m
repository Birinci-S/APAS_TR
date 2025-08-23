function [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,minLength)


%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

lightSpeed=299792458;
L1dataNew={}; L2dataNew={}; P1dataNew={}; P2dataNew={};
switch system
    case 1  %%%% GPS System
%disp('GPS DATA')

        freqL1=1575.42;
        freqL2=1227.60;

        lambdaL1=lightSpeed/freqL1/1e6; % GPS L1 wavelength
        lambdaL2=lightSpeed/freqL2/1e6; % GPS L2 wavelength
        L1data=rnxdata.GPS{2,L1column}(:,satNum).*lambdaL1;%L1 m
        L2data=rnxdata.GPS{2,L2column}(:,satNum).*lambdaL2;%L2 m
        P1data=rnxdata.GPS{2,C1column}(:,satNum);%P1 m
        P2data=rnxdata.GPS{2,C2column}(:,satNum);%P2 m

    case 2 %%% GLONASS System
    %    disp('GLONASS DATA')
        [freqL1, freqL2]= GLONASS_freq(satNum);

        lambdaL1=lightSpeed/freqL1/1e6;  % GLONASS L1 wavelength
        lambdaL2=lightSpeed/freqL2/1e6;  % GLONASS L2 wavelength
        L1data=rnxdata.GLONASS{2,L1column}(:,satNum).*lambdaL1;%L1 m
        L2data=rnxdata.GLONASS{2,L2column}(:,satNum).*lambdaL2;%L2 m
        P1data=rnxdata.GLONASS{2,C1column}(:,satNum);%P1 m
        P2data=rnxdata.GLONASS{2,C2column}(:,satNum);%P2 m

    case 3 %%% Galileo System
    %    disp('Galileo DATA')
        freqL1=154*10.23;
        freqL2=115*10.23;

        lambdaL1=lightSpeed/freqL1/1e6; % Galileo L1 wavelength
        lambdaL2=lightSpeed/freqL2/1e6; %Galileo L2 wavelength
        L1data=rnxdata.GALILEO{2,L1column}(:,satNum).*lambdaL1;%L1 m
        L2data=rnxdata.GALILEO{2,L2column}(:,satNum).*lambdaL2;%L2 m
        P1data=rnxdata.GALILEO{2,C1column}(:,satNum);%P1 m
        P2data=rnxdata.GALILEO{2,C2column}(:,satNum);%P2 m

    case 4 %%% BDS System
     %   disp('BDS DATA')
        freqL1=1561.098;
        freqL2=1268.52;

        lambdaL1=lightSpeed/freqL1/1e6; % BDS L1 wavelength
        lambdaL2=lightSpeed/freqL2/1e6; % BDS L1 wavelength

        L1data=rnxdata.BEIDOU{2,L1column}(:,satNum).*lambdaL1;%L1 m
        L2data=rnxdata.BEIDOU{2,L2column}(:,satNum).*lambdaL2;%L2 m
        P1data=rnxdata.BEIDOU{2,C1column}(:,satNum);%P1 m
        P2data=rnxdata.BEIDOU{2,C2column}(:,satNum);%P2 m

    case 5 %% QZSS System
    %    disp('QZSS DATA')
        freqL1=1575.42;
        freqL2=1227.60;

        lambdaL1=lightSpeed/freqL1/1e6; %QZSS L1 wavelength
        lambdaL2=lightSpeed/freqL2/1e6; %QZSS L1 wavelength
        L1data=rnxdata.QZSS{2,L1column}(:,satNum).*lambdaL1;%L1 m
        L2data=rnxdata.QZSS{2,L2column}(:,satNum).*lambdaL2;%L2 m
        P1data=rnxdata.QZSS{2,C1column}(:,satNum);%P1 m
        P2data=rnxdata.QZSS{2,C2column}(:,satNum);%P2 m

end



%//////////////////////////////////////////////////////////////////////////////
%ARC data
%/////////////////////////////////////////////////////////////////////////////////


kontrol=0;
sayac1=1;
sayac2=1;
for i=1:length(L1data)
    if ~isnan( L1data(i,1)) && ~isnan( L2data(i,1)) && ~isnan( P1data(i,1)) && ~isnan( P2data(i,1))
        % if ( L1data(i,1))~=0 && ( L2data(i,1))~=0 && ( P1data(i,1))~=0 && ( P2data(i,1))~=0 &&  P2data(i,1)~=0
        L1dataNew{sayac1,1}(sayac2,1)=L1data(i,1);
        L1dataNew{sayac1,1}(sayac2,2)=i;
        L2dataNew{sayac1,1}(sayac2,1)=L2data(i,1);
        L2dataNew{sayac1,1}(sayac2,2)=i;
        P1dataNew{sayac1,1}(sayac2,1)=P1data(i,1);
        P1dataNew{sayac1,1}(sayac2,2)=i;
        P2dataNew{sayac1,1}(sayac2,1)=P2data(i,1);
        P2dataNew{sayac1,1}(sayac2,2)=i;
        sayac2=sayac2+1;
        kontrol=1;
        %elseif (isnan( L1data(i,1)) && kontrol ==1) || (isnan( L2data(i,1)) && kontrol ==1) || (isnan( P1data(i,1)) && kontrol ==1) || (isnan( P2data(i,1)) && kontrol ==1)
        %elseif ( L1data(i,1))==0 && kontrol ==1 % buraya bak
    else
        kontrol=kontrol+1;
        sayac2=1;
        sayac1=sayac1+1 ;

    end
end

L1dataNew(cellfun('length',L1dataNew)<minLength) = [];
L2dataNew(cellfun('length',L2dataNew)<minLength) = [];
P1dataNew(cellfun('length',P1dataNew)<minLength) = [];
P2dataNew(cellfun('length',P2dataNew)<minLength) = [];
end




