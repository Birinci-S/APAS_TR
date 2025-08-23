
function visible_sat_Plot(combination,GPS_output,GLO_output,GAL_output,BDS2_output,BDS3_output,QZSS_output,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

figure
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;

gpsColor='#54278f';
gloColor='#a65628';
galColor='#f16913';
bds2Color='#225ea8';
bds3Color='#810f7c';
qzssColor='#238443';
totalColor='#ce1256';

if combination ==1

    satG=GPS_output.vis_Sat;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    grid on
    title('Visible Satellite Number')
    legend('GPS')

elseif combination ==2

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    total_sat= satG+satR;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','GR')


elseif combination ==3

    satG=GPS_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    total_sat= satG+satE;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','Galileo','GE')



elseif combination ==4

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    total_sat= satG+satR+satE;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','Galileo','GRE')


elseif combination ==5

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    satC2=BDS2_output.vis_Sat;
    total_sat= satG+satR+satE+satC2;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,satC2,'Color',bds2Color,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','Galileo','BDS2','GREC2')


elseif combination ==6

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    satC3=BDS3_output.vis_Sat;
    total_sat= satG+satR+satE+satC3;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,satC3,'Color',bds3Color,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','Galileo','BDS3','GREC3')


elseif combination ==7

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    satC2=BDS2_output.vis_Sat;
    satC3=BDS3_output.vis_Sat;
    total_sat= satG+satR+satE+satC2+satC3;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,satC2,'Color',bds2Color,'LineWidth',1.5)
    plot(hours,satC3,'Color',bds3Color,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','Galileo','BDS2','BDS3','GREC2C3')




elseif combination ==8

    satG=GPS_output.vis_Sat;
    satR=GLO_output.vis_Sat;
    satE=GAL_output.vis_Sat;
    satC2=BDS2_output.vis_Sat;
    satC3=BDS3_output.vis_Sat;
    satJ=QZSS_output.vis_Sat;
    total_sat= satG+satR+satE+satC2+satC3+satJ;
    plot(hours,satG,'Color',gpsColor,'LineWidth',1.5)
    hold on
    plot(hours,satR,'Color',gloColor,'LineWidth',1.5)
    plot(hours,satE,'Color',galColor,'LineWidth',1.5)
    plot(hours,satC2,'Color',bds2Color,'LineWidth',1.5)
    plot(hours,satC3,'Color',bds3Color,'LineWidth',1.5)
    plot(hours,satJ,'Color',qzssColor,'LineWidth',1.5)
    plot(hours,total_sat,'Color',totalColor,'LineWidth',1.5)
    title('Visible Satellite Number')
    legend('GPS','GLONASS','Galileo','BDS2','BDS3','QZSS','GREC2C3J')
end

xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)
ylabel('Satellite Number');
grid on

end



