
function [rnxdata]=cycle_Slip_Control(clockdata, clocktime, sp3data, sp3time,rnxdata,rnxzaman,recPosition1,rnx_GPS,rnx_GLO,rnx_GAL,rnx_BDS,rnx_QZSS,elev_cut,Smooth)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci


disp('ROTI-based GF Combination + FBMWA MW Combination cycle slip algorithm')

if rnx_GPS.GPS_system==1 && ~isempty(sp3data.GPS)
    [fh,ph, th]=wait_bar_process_CS(1);

    disp('Cycle slip is being searched in GPS observations with ROTI-based GF Combination + FBMWA MW Combination...')
    for satNum=1:size(rnxdata.GPS{2,1},2)

        if ~isempty(rmmissing(rnxdata.GPS{2,rnx_GPS.L2columnGPS}(:,satNum))) && ~isempty(rmmissing(rnxdata.GPS{2,rnx_GPS.L1columnGPS}(:,satNum)))

            [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,rnx_GPS.L1columnGPS,rnx_GPS.L2columnGPS,rnx_GPS.C1columnGPS,rnx_GPS.C2columnGPS,rnxdata,rnxzaman,recPosition1,elev_cut,1,Smooth,satNum);
        else

            rnxdata.GPS{2,rnx_GPS.L2columnGPS}(:,satNum)=NaN;
            rnxdata.GPS{2,rnx_GPS.L1columnGPS}(:,satNum)=NaN;
            rnxdata.GPS{2,rnx_GPS.C2columnGPS}(:,satNum)=NaN;
            rnxdata.GPS{2,rnx_GPS.C1columnGPS}(:,satNum)=NaN;
        end


        waitbar(satNum/size(rnxdata.GPS{2,1},2),fh);
        ph.XData = [0 satNum/size(rnxdata.GPS{2,1},2) satNum/size(rnxdata.GPS{2,1},2) 0];
        th.String = sprintf('%.0f%%',round(satNum/size(rnxdata.GPS{2,1},2)*100));

    end
    delete(fh)
    disp('Cycle slip was detected and repaired in GPS observations ...')
end

drawnow %update graphics



if rnx_GLO.GLO_system==1 && ~isempty(sp3data.GLONASS)
    [fh,ph, th]=wait_bar_process_CS(2);
    disp('Cycle slip is being searched in GLONASS observations with ROTI-based GF Combination + FBMWA MW Combination...')
    for satNum=1:size(rnxdata.GLONASS{2,1},2)
        if ~isempty(rmmissing(rnxdata.GLONASS{2,rnx_GLO.L2columnGLO}(:,satNum))) &&  ~isempty(rmmissing(rnxdata.GLONASS{2,rnx_GLO.L1columnGLO}(:,satNum)))

            [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,rnx_GLO.L1columnGLO,rnx_GLO.L2columnGLO,rnx_GLO.C1columnGLO,rnx_GLO.C2columnGLO,rnxdata,rnxzaman,recPosition1,elev_cut,2,Smooth,satNum);
        else

            rnxdata.GLONASS{2,rnx_GLO.L2columnGLO}(:,satNum)=NaN;
            rnxdata.GLONASS{2,rnx_GLO.L1columnGLO}(:,satNum)=NaN;
            rnxdata.GLONASS{2,rnx_GLO.C2columnGLO}(:,satNum)=NaN;
            rnxdata.GLONASS{2,rnx_GLO.C1columnGLO}(:,satNum)=NaN;



        end


        waitbar(satNum/size(rnxdata.GLONASS{2,1},2),fh);
        ph.XData = [0 satNum/size(rnxdata.GLONASS{2,1},2) satNum/size(rnxdata.GLONASS{2,1},2) 0];
        th.String = sprintf('%.0f%%',round(satNum/size(rnxdata.GLONASS{2,1},2)*100));

    end
    delete(fh)
    disp('Cycle slip was detected and repaired in GLONASS observations ...')
end
drawnow %update graphics



if rnx_GAL.GAL_system==1 && ~isempty(sp3data.GALILEO)
    [fh,ph, th]=wait_bar_process_CS(3);
    disp('Cycle slip is being searched in Galileo observations with ROTI-based GF Combination + FBMWA MW Combination...')
    for satNum=1:size(rnxdata.GALILEO{2,1},2)
        if ~isempty(rmmissing(rnxdata.GALILEO{2,rnx_GAL.L2columnGAL}(:,satNum))) && ~isempty(rmmissing(rnxdata.GALILEO{2,rnx_GAL.L1columnGAL}(:,satNum)))

            [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,rnx_GAL.L1columnGAL,rnx_GAL.L2columnGAL,rnx_GAL.C1columnGAL,rnx_GAL.C2columnGAL,rnxdata,rnxzaman,recPosition1,elev_cut,3,Smooth,satNum);
        else

            rnxdata.GALILEO{2,rnx_GAL.L2columnGAL}(:,satNum)=NaN;
            rnxdata.GALILEO{2,rnx_GAL.L1columnGAL}(:,satNum)=NaN;
            rnxdata.GALILEO{2,rnx_GAL.C2columnGAL}(:,satNum)=NaN;
            rnxdata.GALILEO{2,rnx_GAL.C1columnGAL}(:,satNum)=NaN;



        end

        waitbar(satNum/size(rnxdata.GALILEO{2,1},2),fh);
        ph.XData = [0 satNum/size(rnxdata.GALILEO{2,1},2) satNum/size(rnxdata.GALILEO{2,1},2) 0];
        th.String = sprintf('%.0f%%',round(satNum/size(rnxdata.GALILEO{2,1},2)*100));

    end
    delete(fh)
    disp('Cycle slip was detected and repaired in Galileo observations ...')
end
drawnow %update graphics



if rnx_BDS.BDS_system==1 && ~isempty(sp3data.BEIDOU)
    [fh,ph, th]=wait_bar_process_CS(4);

    disp('Cycle slip is being searched in BDS observations with ROTI-based GF Combination + FBMWA MW Combination...')

    for satNum=1:size(rnxdata.BEIDOU{2,1},2)
        if ~isempty(rmmissing(rnxdata.BEIDOU{2,rnx_BDS.L2columnBDS}(:,satNum))) &&  ~isempty(rmmissing(rnxdata.BEIDOU{2,rnx_BDS.L1columnBDS}(:,satNum)))

            [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,rnx_BDS.L1columnBDS,rnx_BDS.L2columnBDS,rnx_BDS.C1columnBDS,rnx_BDS.C2columnBDS,rnxdata,rnxzaman,recPosition1,elev_cut,4,Smooth,satNum);
        else

            rnxdata.BEIDOU{2,rnx_BDS.L2columnBDS}(:,satNum)=NaN;
            rnxdata.BEIDOU{2,rnx_BDS.L1columnBDS}(:,satNum)=NaN;
            rnxdata.BEIDOU{2,rnx_BDS.C2columnBDS}(:,satNum)=NaN;
            rnxdata.BEIDOU{2,rnx_BDS.C1columnBDS}(:,satNum)=NaN;


        end

        waitbar(satNum/size(rnxdata.BEIDOU{2,1},2),fh);
        ph.XData = [0 satNum/size(rnxdata.BEIDOU{2,1},2) satNum/size(rnxdata.BEIDOU{2,1},2) 0];
        th.String = sprintf('%.0f%%',round(satNum/size(rnxdata.BEIDOU{2,1},2)*100));

    end
    delete(fh)
    disp('Cycle slip was detected and repaired in BDS observations ...')
end
drawnow %update graphics



if rnx_QZSS.QZSS_system==1 && ~isempty(sp3data.QZSS)
    [fh,ph, th]=wait_bar_process_CS(5);
    disp('Cycle slip is being searched in QZSS observations with ROTI-based GF Combination + FBMWA MW Combination..')
    for satNum=1:size(rnxdata.QZSS{2,1},2)
        if ~isempty(rmmissing(rnxdata.QZSS{2,rnx_QZSS.L2columnQZSS}(:,satNum))) && ~isempty(rmmissing(rnxdata.QZSS{2,rnx_QZSS.L1columnQZSS}(:,satNum)))

            [rnxdata]=cycle_slip_Det_Repair(clockdata, clocktime, sp3data, sp3time,rnx_QZSS.L1columnQZSS,rnx_QZSS.L2columnQZSS,rnx_QZSS.C1columnQZSS,rnx_QZSS.C2columnQZSS,rnxdata,rnxzaman,recPosition1,elev_cut,5,Smooth,satNum);
        else

            rnxdata.QZSS{2,rnx_QZSS.L2columnQZSS}(:,satNum)=NaN;
            rnxdata.QZSS{2,rnx_QZSS.L1columnQZSS}(:,satNum)=NaN;
            rnxdata.QZSS{2,rnx_QZSS.C2columnQZSS}(:,satNum)=NaN;
            rnxdata.QZSS{2,rnx_QZSS.C1columnQZSS}(:,satNum)=NaN;


        end

        waitbar(satNum/size(rnxdata.QZSS{2,1},2),fh);
        ph.XData = [0 satNum/size(rnxdata.QZSS{2,1},2) satNum/size(rnxdata.QZSS{2,1},2) 0];
        th.String = sprintf('%.0f%%',round(satNum/size(rnxdata.QZSS{2,1},2)*100));

    end
    delete(fh)
    disp('Cycle slip was detected and repaired in QZSS observations ...')
end
drawnow %update graphics

end
