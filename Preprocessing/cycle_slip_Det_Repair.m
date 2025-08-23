function [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,L1column,L2column,C1column,C2column,rnxdata,rnxzaman,recPosition1,elev_cut,system,Smooth,satNum)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci


lightSpeed=299792458; %light speed


switch system
    case 1  %%%% GPS System
        %disp('GPS DATA')
        freqL1=1575.42;
        freqL2=1227.60;

    case 2 %%% GLONASS System
        %disp('GLONASS DATA')
        [freqL1, freqL2]= GLONASS_freq(satNum);

    case 3 %%% Galileo System
        % disp('Galileo DATA')
        freqL1=154*10.23;
        freqL2=115*10.23;

    case 4 %%% BDS System
        % disp('BDS DATA')
        freqL1=1561.098;
        freqL2=1268.52;

    case 5 %% QZSS System
        % disp('QZSS DATA')
        freqL1=1575.42;
        freqL2=1227.60;
end

lambdaL1=lightSpeed/freqL1/1e6;
lambdaL2=lightSpeed/freqL2/1e6;
lambdaW=lightSpeed/(freqL1-freqL2)*1e-6;


m=5; %forward window size
n=5; %backward window size

%%%obtaining GNSS arc data
VTEC= {}; elev={}; rot_res=[]; ROT=[];
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
[L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,30);
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

switch system
    case 1  %%%% GPS System
        %%% rinex data NaN;
        rnxdata.GPS{2,C1column}(:,satNum)=NaN;
        rnxdata.GPS{2,C2column}(:,satNum)=NaN;
        rnxdata.GPS{2,L1column}(:,satNum)=NaN;
        rnxdata.GPS{2,L2column}(:,satNum)=NaN;
    case 2
        rnxdata.GLONASS{2,C1column}(:,satNum)=NaN;
        rnxdata.GLONASS{2,C2column}(:,satNum)=NaN;
        rnxdata.GLONASS{2,L1column}(:,satNum)=NaN;
        rnxdata.GLONASS{2,L2column}(:,satNum)=NaN;

    case 3
        rnxdata.GALILEO{2,C1column}(:,satNum)=NaN;
        rnxdata.GALILEO{2,C2column}(:,satNum)=NaN;
        rnxdata.GALILEO{2,L1column}(:,satNum)=NaN;
        rnxdata.GALILEO{2,L2column}(:,satNum)=NaN;

    case 4

        rnxdata.BEIDOU{2,C1column}(:,satNum)=NaN;
        rnxdata.BEIDOU{2,C2column}(:,satNum)=NaN;
        rnxdata.BEIDOU{2,L1column}(:,satNum)=NaN;
        rnxdata.BEIDOU{2,L2column}(:,satNum)=NaN;

    case 5

        rnxdata.QZSS{2,C1column}(:,satNum)=NaN;
        rnxdata.QZSS{2,C2column}(:,satNum)=NaN;
        rnxdata.QZSS{2,L1column}(:,satNum)=NaN;
        rnxdata.QZSS{2,L2column}(:,satNum)=NaN;
end

%%%Geometry-Free Inputs
freq1=freqL1*1e6;  freq2=freqL2*1e6;
S=freq1^2*freq2^2/(40.309*(freq1^2-freq2^2));

if ~isempty(L1dataNew)
    [L1dataNew, L2dataNew, P1dataNew, P2dataNew,elev]=obs_cutof_elev(clockdata, clocktime, sp3data, sp3time,L1dataNew, L2dataNew, P1dataNew, P2dataNew,rnxzaman,recPosition1,elev_cut,system,satNum);


    L1dataNew(cellfun('length',L1dataNew)<m+n+5) = [];
    L2dataNew(cellfun('length',L2dataNew)<m+n+5) = [];
    P1dataNew(cellfun('length',P1dataNew)<m+n+5) = [];
    P2dataNew(cellfun('length',P2dataNew)<m+n+5) = [];
    elev(cellfun('length',elev)<m+n+5) = [];
end


if ~isempty(L1dataNew)


    for p=1:size(L1dataNew,1)

        LW=(freqL1.*L1dataNew{p,1}(:,1)-freqL2*L2dataNew{p,1}(:,1))./(freqL1-freqL2);
        RN=(freqL1*P1dataNew{p,1}(:,1)+freqL2*P2dataNew{p,1}(:,1))./(freqL1+freqL2);
        LMW=(LW-RN);
        Nwl=LMW./lambdaW; %widelane ambiguty
        geoFree1=L1dataNew{p,1}(:,1)-L2dataNew{p,1}(:,1);
        %geoFreeTime=rnxzaman(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),1);

        %%%initial
        sBw=lambdaW/2;
        mBw=Nwl(1,1);
        skareBw=sBw^2;
        count1=2;   %sigmaMW=lambdaW;

        meanMW_pre=Nwl(1,1);
        sigmakareMW_pre=sBw^2;




        for r=2:length(Nwl)-1
            %  mwCS=0;

            meanMW_cur = meanMW_pre + (1/count1) * ( Nwl(r,1) - meanMW_pre);

            if abs(Nwl(r,1)-meanMW_pre)>5*sqrt(sigmakareMW_pre)   && abs(Nwl(r,1)-Nwl(r+1,1))<=1
                % mwCS=1;
                A=[lambdaL1  -lambdaL2 ; 1 -1];
                l=[geoFree1(r-1)-geoFree1(r) ; round(Nwl(r-1)-Nwl(r,1))];
                cs=inv(A)*l;
                csL1=round(cs(1,1));
                csL2=round(cs(2,1));


                L1dataNew{p,1}((r:end),1)=L1dataNew{p,1}((r:end),1)+csL1*lambdaL1;
                L2dataNew{p,1}((r:end),1)=L2dataNew{p,1}((r:end),1)+csL2*lambdaL2;
                LW=(freqL1.*L1dataNew{p,1}(:,1)-freqL2*L2dataNew{p,1}(:,1))./(freqL1-freqL2);
                RN=(freqL1*P1dataNew{p,1}(:,1)+freqL2*P2dataNew{p,1}(:,1))./(freqL1+freqL2);
                LMW=(LW-RN);
                Nwl=LMW./lambdaW;
                geoFree1=L1dataNew{p,1}(:,1)-L2dataNew{p,1}(:,1);
                meanMW_cur = meanMW_pre + (1/count1) * ( Nwl(r,1) - meanMW_pre);


                skareBw=(count1-1)/count1*skareBw+1/count1*(Nwl(r,1)-mBw)^2;
                mBw=(count1-1)/count1*mBw+1/count1*Nwl(r,1);
                sBw=sqrt(skareBw);
            end




            count1=count1+1;     meanMW_pre=meanMW_cur;
            sigmakareMW_pre = sigmakareMW_pre + (1/count1) * ( (Nwl(r,1)-meanMW_pre)^2 - sigmakareMW_pre );


            if rem(r,50)==0
                sigmakareMW_pre=sBw^2;
                meanMW_pre=Nwl(r,1);
            end
        end


        %%%%ROTI GEOMETRY-FREE

        for r=1:size(L1dataNew{p,1},1)

            STEC=S.*(geoFree1(r,1))*1e-16;
            % M=sqrt(1-(6378*cosd(elev{p,1}(r,1))/(6378+350))^2);
            %%%%STEC to VTEC using M
            VTEC{p,1}(r,1)=STEC;

            ROT{p,1}=diff(VTEC{p,1})/((rnxzaman(2,1)-rnxzaman(1,1))/60);

        end



        for r=2:length(Nwl)

            % gfCS=0;

            if  r<=11
                d=r;
                ROTI=sqrt(mean((ROT{p,1}(1:d-1)).^2)-(mean(ROT{p,1}(1:d-1)))^2    );

            elseif r>11
                d=r;
                ROTI=sqrt(mean((ROT{p,1}(d-11:d-1)).^2)-(mean(ROT{p,1}(d-11:d-1)))^2    );
            end
            %   ROTI=sqrt( (sum(((ROT{p,1}(d-10:d-1)) - mean(ROT{p,1}(d-10:d-1))).^2))/10 );

            %rot_res{p,1}(r,1)=ROTI;

            if ROTI<=0.5
                th1=0.104;
            elseif ROTI>0.5 && ROTI<=3
                th1= -0.018 * ROTI^2 + 0.260 * ROTI - 0.021;
            else
                th1=0.594;
            end

            kiyas=abs(geoFree1(r)-geoFree1(r-1));

            if kiyas>th1

                % gfCS=1;
                %disp('gfCYCLESLİP');
                A=[lambdaL1  -lambdaL2 ; 1 -1];

                l=[geoFree1(r-1)-geoFree1(r) ; round(Nwl(r-1)-Nwl(r,1))];

                cs=inv(A)*l;

                csL1=round(cs(1,1));
                csL2=round(cs(2,1));


                L1dataNew{p,1}((r:end),1)=L1dataNew{p,1}((r:end),1)+csL1*lambdaL1;
                L2dataNew{p,1}((r:end),1)=L2dataNew{p,1}((r:end),1)+csL2*lambdaL2;

                LW=(freqL1.*L1dataNew{p,1}(:,1)-freqL2*L2dataNew{p,1}(:,1))./(freqL1-freqL2);
                RN=(freqL1*P1dataNew{p,1}(:,1)+freqL2*P2dataNew{p,1}(:,1))./(freqL1+freqL2);
                LMW=(LW-RN);
                Nwl=LMW./lambdaW;
                geoFree1=L1dataNew{p,1}(:,1)-L2dataNew{p,1}(:,1);
                skareBw=(count1-1)/count1*skareBw+1/count1*(Nwl(r,1)-mBw)^2;
                mBw=(count1-1)/count1*mBw+1/count1*Nwl(r,1);
                sBw=sqrt(skareBw);


                for r=1:size(L1dataNew{p,1},1)
                    STEC=S.*(geoFree1(r,1))*1e-16;
                    M=sqrt(1-(6378*cosd(elev{p,1}(r,1))/(6378+350))^2);

                    VTEC{p,1}(r,1)=STEC;
                    ROT{p,1}=diff(VTEC{p,1})/((rnxzaman(2,1)-rnxzaman(1,1))/60);
                end
            end

        end



        %Forward and backward moving window averaging algorithm

        control=1;
        geoFree=geoFree1./lambdaL1;
        while control<2
            sayac=1;
            for x=m+1:length(Nwl)-(n+1)
                NwlBwd(x,1)=mean(Nwl(x-m:x-1));
                NwlFwd(x,1)=mean(Nwl(x:x+n-1));
                deltaNwl(sayac,1)=NwlFwd(x,1)-NwlBwd(x,1);
                zaman(sayac,1)=x;
                deltaP(sayac,1)=geoFree(x,1)-2*geoFree(x-1,1)+geoFree(x-2,1);
                zaman2(sayac,1)=x;
                elev_control(sayac,1)=elev{p,1}(x,1);
                sayac=sayac+1;
            end

            outNwl=[NaN NaN];


            th_Nwl=1.1;

            zaman=find(abs(deltaNwl)>th_Nwl);
            outNwl=[deltaNwl(zaman,:) zaman];

            if ~isempty(outNwl)
                ep_x=outNwl(abs(outNwl(:,1))==max(abs(outNwl(:,1))),2);
                d=ep_x+m;
                value1=round(deltaNwl(ep_x));
                value2=(deltaP(ep_x));
                l=[value1;value2];
                A=[1 -1; 1 -lambdaL2/lambdaL1];
                cs=inv(A)*l;
                csL1=round(cs(1,1));
                csL2=round(cs(2,1));

                L1dataNew{p,1}((d:end),1)=L1dataNew{p,1}((d:end),1)-csL1*lambdaL1;
                L2dataNew{p,1}((d:end),1)=L2dataNew{p,1}((d:end),1)-csL2*lambdaL2;
                LW=(freqL1.*L1dataNew{p,1}(:,1)-freqL2*L2dataNew{p,1}(:,1))./(freqL1-freqL2);
                RN=(freqL1*P1dataNew{p,1}(:,1)+freqL2*P2dataNew{p,1}(:,1))./(freqL1+freqL2);
                LMW=(LW-RN);
                Nwl=LMW./lambdaW;
                geoFree1=L1dataNew{p,1}(:,1)-L2dataNew{p,1}(:,1);
                geoFree=geoFree1./lambdaL1;
                control=1;
                deltaP=[]; zaman=[];  zaman2=[]; deltaNwl=[]; NwlBwd=[]; NwlFwd=[]; elev_control=[];


            else

                control=2;
                deltaP=[]; zaman=[];  zaman2=[]; deltaNwl=[]; NwlBwd=[]; NwlFwd=[]; elev_control=[];
            end

        end






        L1=L1dataNew{p,1};
        L2=L2dataNew{p,1};
        C1=P1dataNew{p,1};
        C2=P2dataNew{p,1};

        for i=1:length(C1)


            % Bernese Smoothing

            meanCL1=mean(C1(:,1)-L1(:,1));
            meanCL2=mean(C2(:,1)-L2(:,1));


            C1Smooth(i,1)=L1(i,1)+meanCL1+((2*freqL2^2)/(freqL1^2-freqL2^2))*((L1(i,1)-mean(L1(:,1)))-(L2(i,1)-mean(L2(:,1))));
            C2Smooth(i,1)=L2(i,1)+meanCL2+((2*freqL1^2)/(freqL1^2-freqL2^2))*((L1(i,1)-mean(L1(:,1)))-(L2(i,1)-mean(L2(:,1))));
            if Smooth==1
                switch system
                    case 1
                        rnxdata.GPS{2,C1column}(L2(i,2),satNum)= C1Smooth(i,1);
                        rnxdata.GPS{2,C2column}(L2(i,2),satNum)= C2Smooth(i,1);
                    case 2
                        rnxdata.GLONASS{2,C1column}(L2(i,2),satNum)= C1Smooth(i,1);
                        rnxdata.GLONASS{2,C2column}(L2(i,2),satNum)= C2Smooth(i,1);
                    case 3
                        rnxdata.GALILEO{2,C1column}(L2(i,2),satNum)= C1Smooth(i,1);
                        rnxdata.GALILEO{2,C2column}(L2(i,2),satNum)= C2Smooth(i,1);

                    case 4
                        rnxdata.BEIDOU{2,C1column}(L2(i,2),satNum)= C1Smooth(i,1);
                        rnxdata.BEIDOU{2,C2column}(L2(i,2),satNum)= C2Smooth(i,1);

                    case 5
                        rnxdata.QZSS{2,C1column}(L2(i,2),satNum)= C1Smooth(i,1);
                        rnxdata.QZSS{2,C2column}(L2(i,2),satNum)= C2Smooth(i,1);

                end

            else

                switch system
                    case 1
                        rnxdata.GPS{2,C1column}(L2(i,2),satNum)= C1(i,1);
                        rnxdata.GPS{2,C2column}(L2(i,2),satNum)= C2(i,1);
                    case 2
                        rnxdata.GLONASS{2,C1column}(L2(i,2),satNum)= C1(i,1);
                        rnxdata.GLONASS{2,C2column}(L2(i,2),satNum)= C2(i,1);
                    case 3
                        rnxdata.GALILEO{2,C1column}(L2(i,2),satNum)= C1(i,1);
                        rnxdata.GALILEO{2,C2column}(L2(i,2),satNum)= C2(i,1);

                    case 4
                        rnxdata.BEIDOU{2,C1column}(L2(i,2),satNum)= C1(i,1);
                        rnxdata.BEIDOU{2,C2column}(L2(i,2),satNum)= C2(i,1);

                    case 5
                        rnxdata.QZSS{2,C1column}(L2(i,2),satNum)= C1(i,1);
                        rnxdata.QZSS{2,C2column}(L2(i,2),satNum)= C2(i,1);

                end
            end

            switch system
                case 1
                    rnxdata.GPS{2,L1column}(L2(i,2),satNum)= L1(i,1);
                    rnxdata.GPS{2,L2column}(L2(i,2),satNum)= L2(i,1);
                case 2
                    rnxdata.GLONASS{2,L1column}(L2(i,2),satNum)= L1(i,1);
                    rnxdata.GLONASS{2,L2column}(L2(i,2),satNum)= L2(i,1);
                case 3
                    rnxdata.GALILEO{2,L1column}(L2(i,2),satNum)= L1(i,1);
                    rnxdata.GALILEO{2,L2column}(L2(i,2),satNum)= L2(i,1);

                case 4
                    rnxdata.BEIDOU{2,L1column}(L2(i,2),satNum)= L1(i,1);
                    rnxdata.BEIDOU{2,L2column}(L2(i,2),satNum)= L2(i,1);

                case 5
                    rnxdata.QZSS{2,L1column}(L2(i,2),satNum)= L1(i,1);
                    rnxdata.QZSS{2,L2column}(L2(i,2),satNum)= L2(i,1);

            end
        end




    end
end



