
function rnxdata =clock_Jump_Det(rnxdata,rnxzaman,L1column,L2column,C1column,C2column,system )

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

cJump=NaN;

lightSpeed=299792458; %light speed

switch system
    case 1  %%%% GPS System
       
        freqL1=1575.42;
        freqL2=1227.60;

        lambdaL1=lightSpeed/freqL1/1e6; %gps l1 frekansı için
        lambdaL2=lightSpeed/freqL2/1e6; %gps l2 frekansı için


        L1kontrol=rnxdata.GPS{2,L1column}.*lambdaL1;
        %L2kontrol=rnxdata.GPS{2,L2column}.*lambdaL2;
        deltaP=diff(rnxdata.GPS{2,C1column});
        deltaL=diff(L1kontrol);
        S=deltaP-deltaL;
        satNumber=size(rnxdata.GPS{2,1},2);


    case 2 %%% GLONASS System
       
        for s_glo=1:size(rnxdata.GLONASS{2,1},2)
            [freqL1, freqL2]= GLONASS_freq(s_glo);

            lambdaL1=lightSpeed/freqL1/1e6; %GLONASS l1 frekansı için
            lambdaL2=lightSpeed/freqL2/1e6; %GLONASS l2 frekansı için
            L1kontrol(:,s_glo)=rnxdata.GLONASS{2,L1column}(:,s_glo).*lambdaL1;
            %  L2kontrol(:,s_glo)=rnxdata.GLONASS{2,L2column}(:,s_glo).*lambdaL2;
        end
        deltaP=diff(rnxdata.GLONASS{2,C1column});
        deltaL=diff(L1kontrol);
        S=deltaP-deltaL;
        satNumber=size(rnxdata.GLONASS{2,1},2);



    case 3 %%% Galileo System
        % disp('Galileo DATA')
        freqL1=154*10.23;
        freqL2=115*10.23;

        lambdaL1=lightSpeed/freqL1/1e6; %GALILEO l1 frekansı için
        lambdaL2=lightSpeed/freqL2/1e6; %GALILEO l2 frekansı için


        L1kontrol=rnxdata.GALILEO{2,L1column}.*lambdaL1;
        %L2kontrol=rnxdata.GALILEO{2,L2column}.*lambdaL2;
        deltaP=diff(rnxdata.GALILEO{2,C1column});
        deltaL=diff(L1kontrol);
        S=deltaP-deltaL;
        satNumber=size(rnxdata.GALILEO{2,1},2);



    case 4 %%% BDS System
        %  disp('BDS DATA')
        freqL1=1561.098;
        freqL2=1268.52;

        lambdaL1=lightSpeed/freqL1/1e6; %BEIDOU l1 frekansı için
        lambdaL2=lightSpeed/freqL2/1e6; %BEIDOU l2 frekansı için


        L1kontrol=rnxdata.BEIDOU{2,L1column}.*lambdaL1;
        %L2kontrol=rnxdata.BEIDOU{2,L2column}.*lambdaL2;
        deltaP=diff(rnxdata.BEIDOU{2,C1column});
        deltaL=diff(L1kontrol);
        S=deltaP-deltaL;
        satNumber=size(rnxdata.BEIDOU{2,1},2);



    case 5 %% QZSS System
        %   disp('QZSS DATA')
        freqL1=1575.42;
        freqL2=1227.60;

        lambdaL1=lightSpeed/freqL1/1e6; %QZSS l1 frekansı için
        lambdaL2=lightSpeed/freqL2/1e6; %QZSS l2 frekansı için


        L1kontrol=rnxdata.QZSS{2,L1column}.*lambdaL1;
        %L2kontrol=rnxdata.QZSS{2,L2column}.*lambdaL2;
        deltaP=diff(rnxdata.QZSS{2,C1column});
        deltaL=diff(L1kontrol);
        S=deltaP-deltaL;
        satNumber=size(rnxdata.QZSS{2,1},2);


end



k1=10^-3*lightSpeed-15;
k2=10^-5;



sayac2=1;
for r=2:length(rnxzaman)
    sayac1=0;
    visSat=length(rmmissing(S(r-1,:)));
    for rr=1:satNumber

        if abs(S(r-1,rr))>k1 && ~isnan(S(r-1,rr))
            sayac1=sayac1+1;
            MS(sayac1,1)=S(r-1,rr);

        end
    end
    if sayac1>1 && size(MS,1)>visSat*0.5
        M=10^3*sum(MS)/(sayac1*lightSpeed);
        if abs(M-round(M))<=k2

            cJump(sayac2,1)=round(M);
            cJump(sayac2,2)=r;
            sayac2=sayac2+1;

        end
    end
    MS=[];
end



if ~isempty(find(isnan(cJump), 1)) && system ==1; disp('No clock jump GPS observations');
elseif ~isempty(find(isnan(cJump), 1)) && system ==2; disp('No clock jump GLONASS observations');
elseif ~isempty(find(isnan(cJump), 1)) && system ==3; disp('No clock jump Galileo observations');
elseif ~isempty(find(isnan(cJump), 1)) && system ==4; disp('No clock jump BDS observations');
elseif ~isempty(find(isnan(cJump), 1))&& system ==5; disp('No clock jump QZSS observations');
end


%position=NaN;
if ~isnan(cJump)

    switch system
        case 1
            disp('Clock jump detect in GPS observations')
            for satNum=1:satNumber
                if ~isempty(rmmissing(rnxdata.GPS{2,C2column}(:,satNum)))
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,2);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    rnxdata.GPS{2,L1column}(:,satNum)=NaN;
                    rnxdata.GPS{2,L2column}(:,satNum)=NaN;

                    for p=1:size(L1dataNew,1)
                        for pp=1:size(cJump,1)
                            position=find(L1dataNew{p,1}(:,2)==cJump(pp,2));
                            if ~isnan(position)
                                L1dataNew{p,1}(position:end,1)= (L1dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));
                                L2dataNew{p,1}(position:end,1)= (L2dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));

                                rnxdata.GPS{2,L1column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L1dataNew{p,1}(:,1)./lambdaL1; %%cycle
                                rnxdata.GPS{2,L2column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L2dataNew{p,1}(:,1)./lambdaL2; %%cycle

                            end

                        end
                    end
                end
            end




        case 2
            disp('Clock jump detect in GLONASS observations')


            for satNum=1:satNumber
                if ~isempty(rmmissing(rnxdata.GLONASS{2,C2column}(:,satNum)))
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,2);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    rnxdata.GLONASS{2,L1column}(:,satNum)=NaN;
                    rnxdata.GLONASS{2,L2column}(:,satNum)=NaN;

                    for p=1:size(L1dataNew,1)
                        for pp=1:size(cJump,1)
                            position=find(L1dataNew{p,1}(:,2)==cJump(pp,2));
                            if ~isnan(position)
                                L1dataNew{p,1}(position:end,1)= (L1dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));
                                L2dataNew{p,1}(position:end,1)= (L2dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));


                                [freqL1, freqL2]= GLONASS_freq(satNum);

                                lambdaL1=lightSpeed/freqL1/1e6; %GLONASS l1 frekansı için
                                lambdaL2=lightSpeed/freqL2/1e6; %GLONASS l2 frekansı için


                                rnxdata.GLONASS{2,L1column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L1dataNew{p,1}(:,1)./lambdaL1; %cycle
                                rnxdata.GLONASS{2,L2column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L2dataNew{p,1}(:,1)./lambdaL2; %cycle

                            end

                        end
                    end
                end
            end


        case 3

            disp('Clock jump detect in Galileo observations')

            for satNum=1:satNumber
                if ~isempty(rmmissing(rnxdata.GALILEO{2,C2column}(:,satNum)))
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,2);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    rnxdata.GALILEO{2,L1column}(:,satNum)=NaN;
                    rnxdata.GALILEO{2,L2column}(:,satNum)=NaN;

                    for p=1:size(L1dataNew,1)
                        for pp=1:size(cJump,1)
                            position=find(L1dataNew{p,1}(:,2)==cJump(pp,2));
                            if ~isnan(position)
                                L1dataNew{p,1}(position:end,1)= (L1dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));
                                L2dataNew{p,1}(position:end,1)= (L2dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));

                                rnxdata.GALILEO{2,L1column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L1dataNew{p,1}(:,1)./lambdaL1; %cycle
                                rnxdata.GALILEO{2,L2column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L2dataNew{p,1}(:,1)./lambdaL2; %cycle

                            end

                        end
                    end
                end
            end





        case 4
            disp('Clock jump detect in BDS observations')
            for satNum=1:satNumber
                if ~isempty(rmmissing(rnxdata.BEIDOU{2,C2column}(:,satNum)))
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,2);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    rnxdata.BEIDOU{2,L1column}(:,satNum)=NaN;
                    rnxdata.BEIDOU{2,L2column}(:,satNum)=NaN;

                    for p=1:size(L1dataNew,1)
                        for pp=1:size(cJump,1)
                            position=find(L1dataNew{p,1}(:,2)==cJump(pp,2));
                            if ~isnan(position)
                                L1dataNew{p,1}(position:end,1)= (L1dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));
                                L2dataNew{p,1}(position:end,1)= (L2dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));

                                rnxdata.BEIDOU{2,L1column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L1dataNew{p,1}(:,1)./lambdaL1; %cycle
                                rnxdata.BEIDOU{2,L2column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L2dataNew{p,1}(:,1)./lambdaL2; %cycle

                            end

                        end
                    end
                end
            end



        case 5
            disp('Clock jump detect in QZSS observations')
            for satNum=1:satNumber
                if ~isempty(rmmissing(rnxdata.QZSS{2,C2column}(:,satNum)))
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [L1dataNew, L2dataNew, P1dataNew, P2dataNew]=data_arc_GRECJ(rnxdata,L1column,L2column,C1column,C2column,system,satNum,2);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    rnxdata.QZSS{2,L1column}(:,satNum)=NaN;
                    rnxdata.QZSS{2,L2column}(:,satNum)=NaN;

                    for p=1:size(L1dataNew,1)
                        for pp=1:size(cJump,1)
                            position=find(L1dataNew{p,1}(:,2)==cJump(pp,2));
                            if ~isnan(position)
                                L1dataNew{p,1}(position:end,1)= (L1dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));
                                L2dataNew{p,1}(position:end,1)= (L2dataNew{p,1}(position:end,1)+(10^-3*cJump(pp,1)*lightSpeed));

                                rnxdata.QZSS{2,L1column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L1dataNew{p,1}(:,1)./lambdaL1; %cycle
                                rnxdata.QZSS{2,L2column}(L1dataNew{p,1}(1,2):L1dataNew{p,1}(end,2),satNum)=L2dataNew{p,1}(:,1)./lambdaL2; %cycle

                            end

                        end
                    end
                end
            end
    end
end


end
