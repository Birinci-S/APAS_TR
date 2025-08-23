function each_satRes(system_output,satNum,observation,Accto,rnxtime)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;


std_res_Selection=0; %for standardized residuals
if std_res_Selection==1

    system_output.code_residual=system_output.Code_std_residual;
    system_output.phase_residual=system_output.Phase_std_residual;
end


if observation==1 && Accto==1  %%%  Code Res- Elevation

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))
        length_obs=size(system_output.elevation,1);
        figure
        yyaxis left
        plot(hours,system_output.code_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);

        if std_res_Selection==0
            ylabel('Code Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Code Standardized Residuals');
        end





        yyaxis right
        %
        plot(hours,system_output.elevation(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);

        ylabel('Satellite Elavation Angle (°)')

        ax = gca;
        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')

        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)


    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);

    end




elseif observation==1 && Accto==2  %%%  Code Res- SNRL1

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))

        length_obs=size(system_output.elevation,1);
        figure
        yyaxis left
        plot(hours,system_output.code_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);
        if std_res_Selection==0
            ylabel('Code Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Code Standardized Residuals');
        end

        yyaxis right
        plot(hours,system_output.snrL1(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);

        ylabel('Satellite C/N0 Values (dB-Hz)')
        ylim([-30 65])
        yticks([-30 -20 -10 0 10 20 30 40 50 60])
        yticklabels({'','','','','10','20','30','40','50','60'})

        ax = gca;
        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')
        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)

    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);
    end



elseif observation==1 && Accto==3   %%% Code Res- SNRL2

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))

        length_obs=size(system_output.elevation,1);
        figure
        yyaxis left
        plot(hours,system_output.code_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);
        if std_res_Selection==0
            ylabel('Code Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Code Standardized Residuals');
        end

        yyaxis right

        plot(hours,system_output.snrL2(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);
        ylabel('Satellite C/N0 Values(dB-Hz)')

        ylim([-30 65])
        yticks([-30 -20 -10 0 10 20 30 40 50 60])
        yticklabels({'','','','','10','20','30','40','50','60'})

        ax = gca;
        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')
        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)

    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);

    end




elseif observation==2 && Accto==1  %%%Phase res-Elevation

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))


        length_obs=size(system_output.elevation,1);
        figure
        yyaxis left

        plot(hours,system_output.phase_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);
        if std_res_Selection==0
            ylabel('Phase Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Phase Standardized Residuals');
        end

        yyaxis right

        plot(hours,system_output.elevation(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);
        ylabel('Satellite Elavation Angle (°)')

        ax = gca;

        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')
        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)

    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);

    end



elseif observation==2 && Accto==2  %%% Phase Res.-SNRL1

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))
        length_obs=size(system_output.elevation,1);
        figure
        yyaxis left

        plot(hours,system_output.phase_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);
        if std_res_Selection==0
            ylabel('Phase Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Phase Standardized Residuals');
        end

        yyaxis right

        plot(hours,system_output.snrL1(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);
        ylabel('Satellite C/N0 Values (dB-Hz)')

        ylim([-30 65])
        yticks([-30 -20 -10 0 10 20 30 40 50 60])
        yticklabels({'','','','','10','20','30','40','50','60'})

        ax = gca;
        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')
        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)

    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);

    end


elseif observation==2 && Accto==3  %%% Phase Res. - SNRL2

    if     ~isempty(find(system_output.elevation(:,satNum)>0, 1))
        length_obs=size(system_output.elevation,1);
        figure

        yyaxis left

        plot(hours,system_output.phase_residual(1:length_obs,satNum),'Color',[136/256, 65/256, 157/256],'LineWidth',1.3);
        if std_res_Selection==0
            ylabel('Phase Observation Residuals [m]');
        elseif std_res_Selection==1
            ylabel('Phase Standardized Residuals');
        end

        yyaxis right

        plot(hours,system_output.snrL2(1:length_obs,satNum),'Color',[35/256, 139/256, 69/256],'LineWidth',1.3);
        ylabel('Satellite C/N0 Values(dB-Hz)')

        ylim([-30 65])
        yticks([-30 -20 -10 0 10 20 30 40 50 60])
        yticklabels({'','','','','10','20','30','40','50','60'})

        ax = gca;
        ax.YAxis(1).Color = [136/256, 65/256, 157/256];
        ax.YAxis(2).Color = [35/256, 139/256, 69/256];
        ax.YAxis(1).LineWidth=1.3;
        ax.YAxis(2).LineWidth=1.3;
        ax.FontWeight='bold';
        xlabel('Epoch','FontWeight','bold')
        grid on
        xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
        xlabel(xlabel_title)

    elseif isempty(find(system_output.elevation(:,satNum)>0, 1))

        msgResidual="No Observation for PRN No:"+string(satNum);
        msgbox(msgResidual);

    end


end
