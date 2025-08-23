% function [C1columnBDS, C2columnBDS, L1columnBDS,L2columnBDS, BDS_C1, BDS_C2,BDS_L1,BDS_L2]=signals_BDS_v3(rnxdata)
function [rnx_BDS]=signals_BDS_v3(rnxdata)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


BDS_C1=''; BDS_C2=''; BDS_L1=''; BDS_L2='';
C1columnBDS=NaN; C2columnBDS=NaN; L1columnBDS=NaN;L2columnBDS=NaN; SNR1columnBDS=NaN;  SNR2columnBDS=NaN;
BDS_system=0;
if isfield(rnxdata, 'BEIDOU')
    %%%%% L1 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C2I'), 1))
        BDS_C1='C2I';
        C1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C2I'), 1));
        SNR1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S2I'), 1));


    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C2Q'), 1))
        BDS_C1='C2Q';
        C1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C2Q'), 1));
        SNR1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S2Q'), 1));

    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C2X'), 1))
        BDS_C1='C2X';
        C1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C2X'), 1));
        SNR1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S2X'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C6I'), 1))
        BDS_C2='C6I';
        C2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C6I'), 1));
        SNR2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S6I'), 1));

    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C6Q'), 1))
        BDS_C2='C6Q';
        C2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C6Q'), 1));
        SNR2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S6Q'), 1));


    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'C6X'), 1))
        BDS_C2='C6X';
        C2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'C6X'), 1));
        SNR2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'S6X'), 1));


    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L2I'), 1))
        BDS_L1='L2I';
        L1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L2I'), 1));


    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L2Q'), 1))
        BDS_L1='L2Q';
        L1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L2Q'), 1));

    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L2X'), 1))
        BDS_L1='L2X';
        L1columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L2X'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L6I'), 1))
        BDS_L2='L6I';
        L2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L6I'), 1));

    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L6Q'), 1))
        BDS_L2='L6Q';
        L2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L6Q'), 1));


    elseif ~isempty(find(1==contains(rnxdata.BEIDOU(1,:),'L6X'), 1))
        BDS_L2='L6X';
        L2columnBDS=(find(1==contains(rnxdata.BEIDOU(1,:),'L6X'), 1));


    end

    if isnan(C1columnBDS)||  isnan(C2columnBDS) ||  isnan(L1columnBDS) ||  isnan(L2columnBDS)
        BDS_system=0;
    else
        BDS_system=1;
    end


    rnx.BDS.C1columnBDS=C1columnBDS;
    rnx.BDS.C2columnBDS=C2columnBDS;
    rnx.BDS.L1columnBDS=L1columnBDS;
    rnx.BDS.L2columnBDS=L2columnBDS;
    rnx.BDS.BDS_C1=BDS_C1;
    rnx.BDS.BDS_C2=BDS_C2;
    rnx.BDS.BDS_L1=BDS_L1;
    rnx.BDS.BDS_L2=BDS_L2;
    rnx.BDS.BDS_system=BDS_system;
    rnx.BDS.SNR_L1=SNR1columnBDS;
    rnx.BDS.SNR_L2=SNR2columnBDS;




else
    rnx.BDS.C1columnBDS=C1columnBDS;
    rnx.BDS.C2columnBDS=C2columnBDS;
    rnx.BDS.L1columnBDS=L1columnBDS;
    rnx.BDS.L2columnBDS=L2columnBDS;
    rnx.BDS.BDS_C1=BDS_C1;
    rnx.BDS.BDS_C2=BDS_C2;
    rnx.BDS.BDS_L1=BDS_L1;
    rnx.BDS.BDS_L2=BDS_L2;
    rnx.BDS.BDS_system=BDS_system;
    rnx.BDS.SNR_L1=SNR1columnBDS;
    rnx.BDS.SNR_L2=SNR2columnBDS;

end
rnx_BDS=rnx.BDS;
end