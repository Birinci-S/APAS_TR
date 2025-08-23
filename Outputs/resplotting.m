

function resplotting(system_output,plot_sel,satSys,rnxtime)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

%system_output=GPS_output;

std_res_Selection=0; %for standardized residuals
if std_res_Selection==1

    system_output.code_residual=system_output.Code_std_residual;
    system_output.phase_residual=system_output.Phase_std_residual;
end

Colors=distinguishable_colors(size(system_output.elevation,2)) ;
hours=rnxtime(:,7)+rnxtime(:,8)/60+rnxtime(:,9)/3600;

if plot_sel==1
    figure
    count=1;
    for satNum=1:size(system_output.elevation,2)


        if ~isempty(find(system_output.elevation(:,satNum)>0, 1))
            plot(hours,system_output.code_residual(:,satNum),'*','Color',Colors(satNum,:));
            sat(count,1)=satSys+string(satNum);
            hold on
            rms_code_meas(count,1)=rms(system_output.code_residual(:,satNum),'omitNaN');
            count=count+1;

        end
    end

    code_RMS=mean(rms_code_meas,'omitNaN');
    str_code_rms=sprintf("%.3f", code_RMS);


    legend(sat,'Location','eastoutside');
    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.05;
    text(NE(1), NE(2),"RMS:"+str_code_rms+" m", 'VerticalAlignment','top', 'HorizontalAlignment','right','FontSize',10,'FontWeight','bold');

    grid on
    if strcmp(satSys,'G')
        title('GPS Code Observation Residuals');
    elseif strcmp(satSys,'R')
        title('GLONASS Code Observation Residuals');
    elseif strcmp(satSys,'E')
        title('Galileo Code Observation Residuals');
    elseif strcmp(satSys,'C2-')
        title('BDS-2 Code Observation Residuals');
    elseif strcmp(satSys,'C3-')
        title('BDS-3 Code Observation Residuals');
    elseif strcmp(satSys,'J')
        title('QZSS Code Observation Residuals');
    end

    if std_res_Selection==0
        ylabel('Residuals (m)');
    elseif std_res_Selection==1
        ylabel('Standardized Residuals');
    end



elseif plot_sel==2

    figure
    count=1;
    for satNum=1:size(system_output.elevation,2)


        if ~isempty(find(system_output.elevation(:,satNum)>0, 1))
            plot(hours,system_output.phase_residual(:,satNum),'*','Color',Colors(satNum,:));
            sat(count,1)=satSys+string(satNum);
            rms_phase_meas(count,1)=rms(system_output.phase_residual(:,satNum),'omitNaN');
            hold on
            count=count+1;
        end
    end


    grid on
    legend(sat,'Location','eastoutside');


    phase_RMS=mean(rms_phase_meas,'omitNaN');

    str_phase_rms=sprintf("%.3f", phase_RMS);
    NE = [max(xlim) max(ylim)]-[diff(xlim) diff(ylim)]*0.05;
    text(NE(1), NE(2),"RMS:"+str_phase_rms+" m", 'VerticalAlignment','top', 'HorizontalAlignment','right','FontSize',10,'FontWeight','bold');

    if strcmp(satSys,'G')
        title('GPS Phase Observation Residuals');
    elseif strcmp(satSys,'R')
        title('GLONASS Phase Observation Residuals');
    elseif strcmp(satSys,'E')
        title('Galileo Phase Observation Residuals');
    elseif strcmp(satSys,'C2-')
        title('BDS-2 Phase Observation Residuals');
    elseif strcmp(satSys,'C3-')
        title('BDS-3 Phase Observation Residuals');
    elseif strcmp(satSys,'J')
        title('QZSS Phase Observation Residuals');
    end


    if std_res_Selection==0
        ylabel('Residuals (m)');
    elseif std_res_Selection==1
        ylabel('Standardized Residuals');
    end



end
xlabel_title=sprintf(' GPS Time (hours of %d.%d.%d)',rnxtime(1,6),rnxtime(1,5),rnxtime(1,4));
xlabel(xlabel_title)


end
