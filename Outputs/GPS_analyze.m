

function GPS_output=GPS_analyze(res,GPS_phase_index)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

GPS_Code_residuals=NaN(size(res,1),32);
GPS_Phase_residuals=NaN(size(res,1),32);
GPS_elevations=NaN(size(res,1),32);
GPS_azimuts=NaN(size(res,1),32);
GPS_Code_stdResiduals=NaN(size(res,1),32);
GPS_Phase_stdResiduals=NaN(size(res,1),32);
GPS_SNR_L1=NaN(size(res,1),32);
GPS_SNR_L2=NaN(size(res,1),32);
visible_GPSsat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_GPSsat(j,1)=res{j,1}.order_num(GPS_phase_index,1);
    for jj=1:res{j,1}.order_num(GPS_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:GPS_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        GPS_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        GPS_elevations(j,satNum)=res{j,1}.elev(index,1);
        GPS_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        GPS_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        GPS_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        GPS_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(GPS_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:GPS_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        GPS_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        GPS_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

GPS_output.code_residual=GPS_Code_residuals;
GPS_output.phase_residual=GPS_Phase_residuals;
GPS_output.elevation=GPS_elevations;
GPS_output.azimut=GPS_azimuts;
GPS_output.Code_std_residual=GPS_Code_stdResiduals;
GPS_output.Phase_std_residual=GPS_Phase_stdResiduals;
GPS_output.snrL1=GPS_SNR_L1;
GPS_output.snrL2=GPS_SNR_L2;
GPS_output.vis_Sat=visible_GPSsat;
end
