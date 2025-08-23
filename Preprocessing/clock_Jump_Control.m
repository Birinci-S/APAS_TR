function [rnxdata]=clock_Jump_Control(rnxdata,rnxzaman,rnx_GPS,rnx_GLO,rnx_GAL,rnx_BDS,rnx_QZSS)


%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci


if rnx_GPS.GPS_system==1
    rnxdata =clock_Jump_Det(rnxdata,rnxzaman,rnx_GPS.L1columnGPS,rnx_GPS.L2columnGPS,rnx_GPS.C1columnGPS,rnx_GPS.C2columnGPS,1 );
end

if rnx_GLO.GLO_system==1
    rnxdata =clock_Jump_Det(rnxdata,rnxzaman,rnx_GLO.L1columnGLO,rnx_GLO.L2columnGLO,rnx_GLO.C1columnGLO,rnx_GLO.C2columnGLO,2 );
end

if rnx_GAL.GAL_system==1
    rnxdata =clock_Jump_Det(rnxdata,rnxzaman,rnx_GAL.L1columnGAL,rnx_GAL.L2columnGAL,rnx_GAL.C1columnGAL,rnx_GAL.C2columnGAL,3 );
end

if rnx_BDS.BDS_system==1
    rnxdata =clock_Jump_Det(rnxdata,rnxzaman,rnx_BDS.L1columnBDS,rnx_BDS.L2columnBDS,rnx_BDS.C1columnBDS,rnx_BDS.C2columnBDS,4 );
end

if rnx_QZSS.QZSS_system==1
    rnxdata =clock_Jump_Det(rnxdata,rnxzaman,rnx_QZSS.L1columnQZSS,rnx_QZSS.L2columnQZSS,rnx_QZSS.C1columnQZSS,rnx_QZSS.C2columnQZSS,5 );
end


end
