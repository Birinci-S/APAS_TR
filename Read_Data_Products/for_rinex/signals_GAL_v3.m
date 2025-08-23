% function [C1columnGAL, C2columnGAL, L1columnGAL,L2columnGAL, GAL_C1, GAL_C2,GAL_L1,GAL_L2]=signals_GAL_v3(rnxdata)
function [rnx_GAL]=signals_GAL_v3(rnxdata)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


GAL_C1=''; GAL_C2=''; GAL_L1=''; GAL_L2='';
C1columnGAL=NaN; C2columnGAL=NaN; L1columnGAL=NaN; L2columnGAL=NaN; SNR1columnGAL=NaN;  SNR2columnGAL=NaN;
GAL_system=0;

if isfield(rnxdata, 'GALILEO')
    %%%%% L1 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'C1X'), 1))
        GAL_C1='C1X';
        C1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'C1X'), 1));
        SNR1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'S1X'), 1));


    elseif ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'C1C'), 1))
        GAL_C1='C1C';
        C1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'C1C'), 1));
        SNR1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'S1C'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'C5X'), 1))
        GAL_C2='C5X';
        C2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'C5X'), 1));
        SNR2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'S5X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'C5Q'), 1))
        GAL_C2='C5Q';
        C2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'C5Q'), 1));
        SNR2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'S5Q'), 1));
    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'L1X'), 1))
        GAL_L1='L1X';
        L1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'L1X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'L1C'), 1))
        GAL_L1='L1C';
        L1columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'L1C'), 1));
    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'L5X'), 1))
        GAL_L2='L5X';
        L2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'L5X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GALILEO(1,:),'L5Q'), 1))
        GAL_L2='L5Q';
        L2columnGAL=(find(1==contains(rnxdata.GALILEO(1,:),'L5Q'), 1));
    end

    if isnan(C1columnGAL) ||  isnan(C2columnGAL) || isnan(L1columnGAL) || isnan(L2columnGAL)
        GAL_system=0;
    else
        GAL_system=1;
    end


    rnx.GAL.C1columnGAL=C1columnGAL;
    rnx.GAL.C2columnGAL=C2columnGAL;
    rnx.GAL.L1columnGAL=L1columnGAL;
    rnx.GAL.L2columnGAL=L2columnGAL;
    rnx.GAL.GAL_C1=GAL_C1;
    rnx.GAL.GAL_C2=GAL_C2;
    rnx.GAL.GAL_L1=GAL_L1;
    rnx.GAL.GAL_L2=GAL_L2;
    rnx.GAL.GAL_system=GAL_system;
    rnx.GAL.SNR_L1=SNR1columnGAL;
    rnx.GAL.SNR_L2=SNR2columnGAL;

else
    rnx.GAL.C1columnGAL=C1columnGAL;
    rnx.GAL.C2columnGAL=C2columnGAL;
    rnx.GAL.L1columnGAL=L1columnGAL;
    rnx.GAL.L2columnGAL=L2columnGAL;
    rnx.GAL.GAL_C1=GAL_C1;
    rnx.GAL.GAL_C2=GAL_C2;
    rnx.GAL.GAL_L1=GAL_L1;
    rnx.GAL.GAL_L2=GAL_L2;
    rnx.GAL.GAL_system=GAL_system;
    rnx.GAL.SNR_L1=SNR1columnGAL;
    rnx.GAL.SNR_L2=SNR2columnGAL;



end
rnx_GAL=rnx.GAL;
end
