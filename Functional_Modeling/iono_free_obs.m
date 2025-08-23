function [iono_free_obs  ]=iono_free_obs (obs_L1,obs_L2,satNum,system)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


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







iono_free_obs = ((freqL1)^2.*obs_L1 - (freqL2)^2.*obs_L2)./((freqL1)^2 - (freqL2)^2);

end





