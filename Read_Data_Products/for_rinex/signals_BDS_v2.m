% function [C1columnBDS, C2columnBDS, L1columnBDS,L2columnBDS, BDS_C1, BDS_C2,BDS_L1,BDS_L2]=signals_BDS_v3(rnxdata)
function [rnx_BDS]=signals_BDS_v2

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


BDS_C1=''; BDS_C2=''; BDS_L1=''; BDS_L2='';
C1columnBDS=NaN; C2columnBDS=NaN; L1columnBDS=NaN;L2columnBDS=NaN; SNR1columnBDS=NaN;  SNR2columnBDS=NaN;
BDS_system=0;

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


rnx_BDS=rnx.BDS;
end