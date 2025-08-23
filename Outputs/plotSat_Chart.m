
function plotSat_Chart(combination,GPS_output,GLO_output,GAL_output,BDS2_output,BDS3_output,QZSS_output,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;

if combination <9



    azimuthGPS=GPS_output.azimut;

    visdataGPS=NaN(size(azimuthGPS,1),size(azimuthGPS,2));
    for i=1:size(azimuthGPS,2)
        for j=1:size(azimuthGPS,1)
            if ~isnan(azimuthGPS(j,i)) && azimuthGPS(j,i)~=0
                visdataGPS(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthGPS,2);
    plot(hours,visdataGPS,'LineWidth',2)
    yticks(1:size(azimuthGPS,2))
    ylim([0 size(azimuthGPS,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('GPS Satellite Visibility Chart')
    ylabel('GPS PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)

end



if combination ==2 || (combination>=4 && combination<=8)

    azimuthGLO=GLO_output.azimut;

    visdataGLO=NaN(size(azimuthGLO,1),size(azimuthGLO,2));
    for i=1:size(azimuthGLO,2)
        for j=1:size(azimuthGLO,1)
            if ~isnan(azimuthGLO(j,i)) && azimuthGLO(j,i)~=0
                visdataGLO(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthGLO,2);
    plot(hours,visdataGLO,'LineWidth',2)
    yticks(1:size(azimuthGLO,2))
    ylim([0 size(azimuthGLO,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('GLONASS Satellite Visibility Chart')
    ylabel('GLONASS PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)


end





if combination >2

    azimuthGAL=GAL_output.azimut;

    visdataGAL=NaN(size(azimuthGAL,1),size(azimuthGAL,2));

    for i=1:size(azimuthGAL,2)
        for j=1:size(azimuthGAL,1)
            if ~isnan(azimuthGAL(j,i))  && azimuthGAL(j,i)~=0
                visdataGAL(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthGAL,2);
    plot(hours,visdataGAL,'LineWidth',2)
    yticks(1:size(azimuthGAL,2))
    ylim([0 size(azimuthGAL,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('Galileo Satellite Visibility Chart')
    ylabel('Galileo PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)

end






if combination==5 || combination==7 || combination==8
    azimuthBDS2=BDS2_output.azimut;

    visdataBDS2=NaN(size(azimuthBDS2,1),size(azimuthBDS2,2));
    for i=1:size(azimuthBDS2,2)
        for j=1:size(azimuthBDS2,1)
            if ~isnan(azimuthBDS2(j,i))  && azimuthBDS2(j,i)~=0
                visdataBDS2(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthBDS2,2);
    plot(hours,visdataBDS2,'LineWidth',2)
    yticks(1:size(azimuthBDS2,2))
    ylim([0 size(azimuthBDS2,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('BDS-2 Satellite Visibility Chart')
    ylabel('BDS-2 PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)

end





if combination>5
    azimuthBDS3=BDS3_output.azimut;

    visdataBDS3=NaN(size(azimuthBDS3,1),size(azimuthBDS3,2));
    for i=1:size(azimuthBDS3,2)
        for j=1:size(azimuthBDS3,1)
            if ~isnan(azimuthBDS3(j,i))  && azimuthBDS3(j,i)~=0
                visdataBDS3(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthBDS3,2);
    plot(hours,visdataBDS3,'LineWidth',2)
    yticks(1:size(azimuthBDS3,2))
    ylim([0 size(azimuthBDS3,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('BDS-3 Satellite Visibility Chart')
    ylabel('BDS-3 PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)
end




if combination>7
    azimuthQZSS=QZSS_output.azimut;

    visdataQZSS=NaN(size(azimuthQZSS,1),size(azimuthQZSS,2));
    for i=1:size(azimuthQZSS,2)
        for j=1:size(azimuthQZSS,1)
            if ~isnan(azimuthQZSS(j,i))  && azimuthQZSS(j,i)~=0
                visdataQZSS(j,i)=i;
            end

        end
    end



    figure;
    satIDs=1:1:size(azimuthQZSS,2);
    plot(hours,visdataQZSS,'LineWidth',2)
    yticks(1:size(azimuthQZSS,2))
    ylim([0 size(azimuthQZSS,2)+1])
    yticklabels(string(satIDs))
    axis tight
    grid on


    title ('QZSS Satellite Visibility Chart')
    ylabel('QZSS PRN')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)
end






end