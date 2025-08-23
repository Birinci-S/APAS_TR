
function CN0_analyze(combination,GPS_output,GLO_output,GAL_output,BDS2_output,BDS3_output,QZSS_output)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci



if combination <9

    G_SNRL1=GPS_output.snrL1;
    G_SNRL2=GPS_output.snrL2;



    elev_GPS=GPS_output.elevation;


    Colors= distinguishable_colors(size(G_SNRL1,2)) ;

    countG=1;
    for i=1:size(G_SNRL1,2)

        if ~isempty(find(elev_GPS(:,i)>0, 1))

            snr1elec=[elev_GPS(:,i) G_SNRL1(:,i)];

            G_elevSNR=sortrows(snr1elec,1);
			
            plot(G_elevSNR(:,1),G_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1.2)
            hold on
            satG(countG,1)="G"+string(i);
            countG=countG+1;
        end


    end
    grid on
    title('GPS L1 Frequency C/N0 Values Acc. to Elevation Angle')
    legend(satG,'Location','southoutside','NumColumns',floor(countG/5));
    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');

end






if combination ==2 || (combination>=4 && combination<=8)
    R_SNRL1=GLO_output.snrL1;
    R_SNRL2=GLO_output.snrL2;



    elev_GLO=GLO_output.elevation;

    figure

    Colors=distinguishable_colors(size(R_SNRL1,2)) ;

    countR=1;
    for i=1:size(R_SNRL1,2)

        if ~isempty(find(elev_GLO(:,i)>0, 1))

            snr1elec=[elev_GLO(:,i) R_SNRL1(:,i)];

            R_elevSNR=sortrows(snr1elec,1);
            plot(R_elevSNR(:,1),R_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1.2)
            hold on

            satR(countR,1)="R"+string(i);
            countR=countR+1;
        end
    end
    title('GLONASS L1 Frequency C/N0 Values Acc. to Elevation Angle')
    grid on
    legend(satR,'Location','southoutside','NumColumns',floor(countR/5));

    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');

end





if combination >2
    E_SNRL1=GAL_output.snrL1;
    E_SNRL2=GAL_output.snrL2;

    countE=1;

    elev_GAL=GAL_output.elevation;

    figure
    Colors=distinguishable_colors(size(E_SNRL1,2)) ;

    for i=1:size(E_SNRL1,2)

        if ~isempty(find(elev_GAL(:,i)>0, 1))

            snr1elec=[elev_GAL(:,i) E_SNRL1(:,i)];

            E_elevSNR=sortrows(snr1elec,1);
            plot(E_elevSNR(:,1),E_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1.2)
            hold on

            satE(countE,1)="E"+string(i);
            countE=countE+1;

        end
    end

    legend(satE,'Location','southoutside','NumColumns',floor(countE/5));
    title('Galileo L1 Frequency C/N0 Values Acc. to Elevation Angle')
    grid on
    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');

end




if combination==5 || combination==7 || combination==8

    C2_SNRL1=BDS2_output.snrL1;
    C2_SNRL2=BDS2_output.snrL2;

    countC2=1;

    elev_BDS2=BDS2_output.elevation;

    figure
    Colors=distinguishable_colors(size(C2_SNRL1,2)) ;

    for i=1:size(C2_SNRL1,2)
        if ~isempty(find(elev_BDS2(:,i)>0, 1))

            snr1elec=[elev_BDS2(:,i) C2_SNRL1(:,i)];

            C2_elevSNR=sortrows(snr1elec,1);
            plot(C2_elevSNR(:,1),C2_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1.2)
            hold on

            satC2(countC2,1)="C2-"+string(i);
            countC2=countC2+1;
        end
    end
    legend(satC2,'Location','southoutside','NumColumns',floor(countC2/5));

    title('BDS-2 L1 Frequency C/N0 Values Acc. to Elevation Angle')
    grid on
    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');

end






if combination>5

    C3_SNRL1=BDS3_output.snrL1;
    C3_SNRL2=BDS3_output.snrL2;

    countC3=1;

    elev_BDS3=BDS3_output.elevation;

    figure
    Colors=distinguishable_colors(size(C3_SNRL1,2)) ;

    for i=1:size(C3_SNRL1,2)
        if ~isempty(find(elev_BDS3(:,i)>0, 1))

            snr1elec=[elev_BDS3(:,i) C3_SNRL1(:,i)];

            C3_elevSNR=sortrows(snr1elec,1);
            plot(C3_elevSNR(:,1),C3_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1.2)
            hold on

            satBDS3(countC3,1)="C3-"+string(i);
            countC3=countC3+1;

        end
    end
    legend(satBDS3,'Location','southoutside','NumColumns',floor(countC3/5));
    title('BDS-3 L1 Frequency C/N0 Values Acc. to Elevation Angle')
    grid on
    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');



end





if combination>7

    J_SNRL1=QZSS_output.snrL1;
    J_SNRL2=QZSS_output.snrL2;
    countJ=1;


    elev_QZSS=QZSS_output.elevation;

    figure
    Colors=distinguishable_colors(size(J_SNRL1,2)) ;


    for i=1:size(J_SNRL1,2)
        if ~isempty(find(elev_QZSS(:,i)>0, 1))


            snr1elec=[elev_QZSS(:,i) J_SNRL1(:,i)];

            J_elevSNR=sortrows(snr1elec,1);
            plot(J_elevSNR(:,1),J_elevSNR(:,2),'.','Color',Colors(i,:),'LineWidth',1)
            hold on

            satJ(countJ,1)="J"+string(i);
            countJ=countJ+1;
        end
    end
    legend(satJ,'Location','southoutside');
    title('QZSS L1 Frequency C/N0 Values Acc. to Elevation Angle')
    grid on
    xlabel('Satellite Elevation Angle (°)');
    ylabel('C/N0 Values');

end


xlabel('Satellite Elevation Angle (°)');
ylabel('C/N0 Values');


end
