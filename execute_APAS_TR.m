%%%%%--------------------------------------------
%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci
%%%%%%%%%%%%------APAS-TR---%%%%%%%%%%%%%%

fclose all;
clc



%%%%----------------------------------------
apas_tr_Info=what('APAS_TR');
apas_tr_path=apas_tr_Info.path;
cd(apas_tr_path);

%%%%----------------------------------------
addpath(genpath(pwd))
APAS_TR();
cd(apas_tr_path);

%%%%----------------------------------------


