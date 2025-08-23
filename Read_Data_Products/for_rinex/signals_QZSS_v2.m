% function [C1columnQZSS, C2columnQZSS, L1columnQZSS,L2columnQZSS, QZSS_C1, QZSS_C2,QZSS_L1,QZSS_L2]=signals_QZSS_v3(rnxdata)

function [rnx_QZSS]=signals_QZSS_v2

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


QZSS_C1=''; QZSS_C2=''; QZSS_L1=''; QZSS_L2='';
C1columnQZSS=NaN; C2columnQZSS=NaN; L1columnQZSS=NaN;L2columnQZSS=NaN; SNR1columnQZSS=NaN;  SNR2columnQZSS=NaN;
QZSS_system=0;

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

rnx_QZSS=rnx.QZSS;
end