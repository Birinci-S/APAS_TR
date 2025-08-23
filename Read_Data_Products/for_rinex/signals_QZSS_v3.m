% function [C1columnQZSS, C2columnQZSS, L1columnQZSS,L2columnQZSS, QZSS_C1, QZSS_C2,QZSS_L1,QZSS_L2]=signals_QZSS_v3(rnxdata)

function [rnx_QZSS]=signals_QZSS_v3(rnxdata)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


QZSS_C1=''; QZSS_C2=''; QZSS_L1=''; QZSS_L2='';
C1columnQZSS=NaN; C2columnQZSS=NaN; L1columnQZSS=NaN;L2columnQZSS=NaN; SNR1columnQZSS=NaN;  SNR2columnQZSS=NaN;
QZSS_system=0;
if isfield(rnxdata, 'QZSS')
    %%%%% L1 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C1C'), 1))
        QZSS_C1='C1C';
        C1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C1C'), 1));
        SNR1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S1C'), 1));


    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C1L'), 1))
        QZSS_C1='C1L';
        C1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C1L'), 1));
        SNR1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S1L'), 1));

    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C1X'), 1))
        QZSS_C1='C1X';
        C1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C1X'), 1));
        SNR1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S1X'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C2S'), 1))
        QZSS_C2='C2S';
        C2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C2S'), 1));
        SNR2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S2S'), 1));

    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C2L'), 1))
        QZSS_C2='C2L';
        C2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C2L'), 1));
        SNR2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S2L'), 1));


    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'C2X'), 1))
        QZSS_C2='C2X';
        C2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'C2X'), 1));
        SNR2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'S2X'), 1));


    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L1C'), 1))
        QZSS_L1='L1C';
        L1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L1C'), 1));


    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L1L'), 1))
        QZSS_L1='L1L';
        L1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L1L'), 1));

    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L1X'), 1))
        QZSS_L1='L1X';
        L1columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L1X'), 1));

    end




    %%%%% L2 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L2S'), 1))
        QZSS_L2='L2S';
        L2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L2S'), 1));

    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L2L'), 1))
        QZSS_L2='L2L';
        L2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L2L'), 1));


    elseif ~isempty(find(1==contains(rnxdata.QZSS(1,:),'L2X'), 1))
        QZSS_L2='L2X';
        L2columnQZSS=(find(1==contains(rnxdata.QZSS(1,:),'L2X'), 1));


    end



    if isnan(C1columnQZSS) || isnan(C2columnQZSS) || isnan(L1columnQZSS) || isnan(L2columnQZSS)
        QZSS_system=0;
    else
        QZSS_system=1;
    end

    rnx.QZSS.C1columnQZSS=C1columnQZSS;
    rnx.QZSS.C2columnQZSS=C2columnQZSS;
    rnx.QZSS.L1columnQZSS=L1columnQZSS;
    rnx.QZSS.L2columnQZSS=L2columnQZSS;
    rnx.QZSS.QZSS_C1=QZSS_C1;
    rnx.QZSS.QZSS_C2=QZSS_C2;
    rnx.QZSS.QZSS_L1=QZSS_L1;
    rnx.QZSS.QZSS_L2=QZSS_L2;
    rnx.QZSS.QZSS_system=QZSS_system;
    rnx.QZSS.SNR_L1=SNR1columnQZSS;
    rnx.QZSS.SNR_L2=SNR2columnQZSS;


else

    rnx.QZSS.C1columnQZSS=C1columnQZSS;
    rnx.QZSS.C2columnQZSS=C2columnQZSS;
    rnx.QZSS.L1columnQZSS=L1columnQZSS;
    rnx.QZSS.L2columnQZSS=L2columnQZSS;
    rnx.QZSS.QZSS_C1=QZSS_C1;
    rnx.QZSS.QZSS_C2=QZSS_C2;
    rnx.QZSS.QZSS_L1=QZSS_L1;
    rnx.QZSS.QZSS_L2=QZSS_L2;
    rnx.QZSS.QZSS_system=QZSS_system;
    rnx.QZSS.SNR_L1=SNR1columnQZSS;
    rnx.QZSS.SNR_L2=SNR2columnQZSS;

end

rnx_QZSS=rnx.QZSS;
end