

function ISB_Plot(output,combination,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


gloColor='#ce1256';
galColor='#cc4c02';
bds2Color='#225ea8';
bds3Color='#810f7c';
qzssColor='#238443';
figure
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;

if combination==1
    msgbox('Only GPS PPP solution ! No Inter System Bias')

elseif combination==2

    GLO_ISB=output(:,10);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)')

    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)

elseif combination==3

    GAL_ISB=output(:,11);
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    grid on
    legend('Galileo ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)


elseif combination==4

    GLO_ISB=output(:,10);
    GAL_ISB=output(:,11);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    hold on
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)','Galileo ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)



elseif combination==5

    GLO_ISB=output(:,10);
    GAL_ISB=output(:,11);
    BDS2_ISB=output(:,12);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    hold on
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    plot(hours,BDS2_ISB,'Color',bds2Color,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)','Galileo ISB (m)','BDS2 ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)



elseif combination==6

    GLO_ISB=output(:,10);
    GAL_ISB=output(:,11);
    BDS3_ISB=output(:,13);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    hold on
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    plot(hours,BDS3_ISB,'Color',bds3Color,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)','Galileo ISB (m)','BDS3 ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)


elseif combination==7

    GLO_ISB=output(:,10);
    GAL_ISB=output(:,11);
    BDS2_ISB=output(:,12);
    BDS3_ISB=output(:,13);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    hold on
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    plot(hours,BDS2_ISB,'Color',bds2Color,'LineWidth',1.5);
    plot(hours,BDS3_ISB,'Color',bds3Color,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)','Galileo ISB (m)','BDS2 ISB (m)','BDS3 ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)


elseif combination==8

    GLO_ISB=output(:,10);
    GAL_ISB=output(:,11);
    BDS2_ISB=output(:,12);
    BDS3_ISB=output(:,13);
    QZSS_ISB=output(:,14);
    plot(hours,GLO_ISB,'Color',gloColor,'LineWidth',1.5);
    hold on
    plot(hours,GAL_ISB,'Color',galColor,'LineWidth',1.5);
    plot(hours,BDS2_ISB,'Color',bds2Color,'LineWidth',1.5);

    plot(hours,BDS3_ISB,'Color',bds3Color,'LineWidth',1.5);
    plot(hours,QZSS_ISB,'Color',qzssColor,'LineWidth',1.5);
    grid on
    legend('GLONASS ISB (m)','Galileo ISB (m)','BDS2 ISB (m)','BDS3 ISB (m)','QZSS ISB (m)')
    xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
    xlabel(xlabel_title)

end

% xlabel('Epochs')
ylabel(' Error [m]');
title('Inter System Biases');

end