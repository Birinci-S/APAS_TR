
%function [C1columnGPS, C2columnGPS, L1columnGPS,L2columnGPS, GPS_C1, GPS_C2,GPS_L1,GPS_L2]=signals_GPS(rnxdata)
function [rnx_GPS]=signals_GPS_v3(rnxdata)


%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


GPS_C1=''; GPS_C2=''; GPS_L1=''; GPS_L2='';
C1columnGPS=NaN; C2columnGPS=NaN; L1columnGPS=NaN; L2columnGPS=NaN; SNR1columnGPS=NaN;  SNR2columnGPS=NaN;
GPS_system=0;

if isfield(rnxdata, 'GPS')
    %%%%% L1 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'C1W'), 1))
        GPS_C1='C1W';
        C1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C1W'), 1));
        SNR1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S1W'), 1));

        % elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'C1X'), 1))
        %     GPS_C1='C1X';
        %     C1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C1X'), 1));
        %SNR1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S1X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'C1C'), 1))
        GPS_C1='C1C';
        C1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C1C'), 1));
        SNR1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S1C'), 1));
    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'C2W'), 1))
        GPS_C2='C2W';
        C2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C2W'), 1));

        SNR2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S2W'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'C2X'), 1))
        GPS_C2='C2X';
        C2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C2X'), 1));
        SNR2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S2X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'C2C'), 1))
        GPS_C2='C2C';
        C2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C2C'), 1));
        SNR2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S2C'), 1));
    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'L1W'), 1))
        GPS_L1='L1W';
        L1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L1W'), 1));

    % elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'L1X'), 1))
    %     GPS_L1='L1X';
    %     L1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L1X'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'L1C'), 1))
        GPS_L1='L1C';
        L1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L1C'), 1));
    end




    %%%%% L2 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'L2W'), 1))
        GPS_L2='L2W';
        L2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L2W'), 1));
    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'L2X'), 1))
        GPS_L2='L2X';
        L2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L2X'), 1));
    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'L2C'), 1))
        GPS_L2='L2C';
        L2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L2C'), 1));
    end



    if isnan(C1columnGPS) || isnan(C2columnGPS) || isnan(L1columnGPS) || isnan(L2columnGPS)
        GPS_system=0;
    else
        GPS_system=1;
    end


    rnx.GPS.C1columnGPS=C1columnGPS;
    rnx.GPS.C2columnGPS=C2columnGPS;
    rnx.GPS.L1columnGPS=L1columnGPS;
    rnx.GPS.L2columnGPS=L2columnGPS;
    rnx.GPS.GPS_C1=GPS_C1;
    rnx.GPS.GPS_C2=GPS_C2;
    rnx.GPS.GPS_L1=GPS_L1;
    rnx.GPS.GPS_L2=GPS_L2;
    rnx.GPS.GPS_system=GPS_system;
    rnx.GPS.SNR_L1=SNR1columnGPS;
    rnx.GPS.SNR_L2=SNR2columnGPS;

else
    rnx.GPS.C1columnGPS=C1columnGPS;
    rnx.GPS.C2columnGPS=C2columnGPS;
    rnx.GPS.L1columnGPS=L1columnGPS;
    rnx.GPS.L2columnGPS=L2columnGPS;
    rnx.GPS.GPS_C1=GPS_C1;
    rnx.GPS.GPS_C2=GPS_C2;
    rnx.GPS.GPS_L1=GPS_L1;
    rnx.GPS.GPS_L2=GPS_L2;
    rnx.GPS.GPS_system=GPS_system;
    rnx.GPS.SNR_L1=SNR1columnGPS;
    rnx.GPS.SNR_L2=SNR2columnGPS;


end

rnx_GPS=rnx.GPS;
end