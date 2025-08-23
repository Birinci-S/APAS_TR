function [C]=weighting_phase(Std_Phase_GPS,phase_GPS_weight,satElevation,SNR_L1,SNR_L2,stoc_Mod)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

% stoc_Mod=3;
% Std_Phase_GPS=1;
% satElevation=30;
% SNR_L1=55;
% SNR_L2=45;

Vf=10;
Cf=150^2;
Std_Phase_GPS=Std_Phase_GPS*phase_GPS_weight;
if stoc_Mod==1
    sigmaL1=sqrt(Std_Phase_GPS.^2/(sind(satElevation))^2);
    sigmaL2=sqrt(Std_Phase_GPS.^2/(sind(satElevation))^2);

    C=6.481*sigmaL1^2+2.389*sigmaL2^2;

elseif stoc_Mod==2

    sigmaL1=Std_Phase_GPS*sqrt(Vf+Cf*10^(-SNR_L1/10));
    sigmaL2=Std_Phase_GPS*sqrt(Vf+Cf*10^(-SNR_L2/10));

    C=6.481*sigmaL1^2+2.389*sigmaL2^2;


elseif stoc_Mod==3

    sigmaL1=Std_Phase_GPS*sqrt(Vf+Cf*(10^(-SNR_L1/10))/(sind(satElevation))^2);
    sigmaL2=Std_Phase_GPS*sqrt(Vf+Cf*(10^(-SNR_L2/10))/(sind(satElevation))^2);
    C=6.481*sigmaL1^2+2.389*sigmaL2^2;

elseif stoc_Mod==4

    sigmaL1=Std_Phase_GPS;
    sigmaL2=Std_Phase_GPS;
    C=6.481*sigmaL1^2+2.389*sigmaL2^2;


end

end