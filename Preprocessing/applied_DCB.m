function [rnxdata]=applied_DCB(rnxdata,rnx_GPS,rnx_GLO, DCBFilename)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

lightSpeed=299792458;
[DCB_GPS,DCB_GLO, ~, ~]=read_DCB_File(DCBFilename);

for satellite=1:length(DCB_GPS{2,9})
    if strcmp(rnx_GPS.GPS_C1,'C1C')
        disp('C1C to C1W for GPS code measurements')
        rnxdata.GPS{2,rnx_GPS.C1columnGPS}(:,satellite)=rnxdata.GPS{2,rnx_GPS.C1columnGPS}(:,satellite)-(DCB_GPS{2,1}(1,satellite)*(10^-9*lightSpeed));
    end

    if strcmp(rnx_GPS.GPS_C2,'C2C')
        disp('C2C to C2W for GPS code measurements')
        rnxdata.GPS{2,rnx_GPS.C2columnGPS}(:,satellite)=rnxdata.GPS{2,rnx_GPS.C2columnGPS}(:,satellite)-(DCB_GPS{2,2}(1,satellite)*(10^-9*lightSpeed));

    end
end




for satellite=1:length(DCB_GLO{2,5})

    if strcmp(rnx_GLO.GLO_C1,'C1C')
        rnxdata.GLONASS{2,rnx_GLO.C1columnGLO}(:,satellite)=rnxdata.GLONASS{2,rnx_GLO.C1columnGLO}(:,satellite)-(DCB_GLO{2,1}(1,satellite)*(10^-9*lightSpeed));
        disp('C1C to C1P for GLONASS code measurements')
    end


    if strcmp(rnx_GLO.GLO_C2,'C2C')
        rnxdata.GLONASS{2,rnx_GLO.C2columnGLO}(:,satellite)=rnxdata.GLONASS{2,rnx_GLO.C2columnGLO}(:,satellite)-(DCB_GLO{2,2}(1,satellite)*(10^-9*lightSpeed));
        disp('C2C to C2P for GLONASS')

    end


end

end

