%function [C1columnGPS, C2columnGPS, L1columnGPS,L2columnGPS, GPS_C1, GPS_C2,GPS_L1,GPS_L2]=signals_GPS(rnxdata)
function [rnx_GPS]=signals_GPS_v2(rnxdata)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


GPS_C1=''; GPS_C2=''; GPS_L1=''; GPS_L2='';
C1columnGPS=NaN; C2columnGPS=NaN; L1columnGPS=NaN; L2columnGPS=NaN; SNR1columnGPS=NaN;  SNR2columnGPS=NaN;
GPS_system=0;

if isfield(rnxdata, 'GPS')
    %%%%% L1 frequency code measurement

    % if ~isempty(find(1==contains(rnxdata.GPS(1,:),'P1'), 1))
    %     GPS_C1='P1';
    %     C1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'P1'), 1));
    %     SNR1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S1'), 1));
        
    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'C1'), 1))
        GPS_C1='C1';
        C1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C1'), 1));
        SNR1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S1'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'P2'), 1))
        GPS_C2='P2';
        C2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'P2'), 1));
        SNR2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S2'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GPS(1,:),'C2'), 1))
        GPS_C2='C2';
        C2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'C2'), 1));
        SNR2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'S2'), 1));
    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'L1'), 1))
        GPS_L1='L1';
        L1columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L1'), 1));

    end




    %%%%% L2 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GPS(1,:),'L2'), 1))
        GPS_L2='L2';
        L2columnGPS=(find(1==contains(rnxdata.GPS(1,:),'L2'), 1));

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