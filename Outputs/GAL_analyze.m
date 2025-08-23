

function GAL_output=GAL_analyze(res,GAL_phase_index)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


GAL_Code_residuals=NaN(size(res,1),36);
GAL_Phase_residuals=NaN(size(res,1),36);
GAL_elevations=NaN(size(res,1),36);
GAL_azimuts=NaN(size(res,1),36);
GAL_Code_stdResiduals=NaN(size(res,1),36);
GAL_Phase_stdResiduals=NaN(size(res,1),36);
GAL_SNR_L1=NaN(size(res,1),36);
GAL_SNR_L2=NaN(size(res,1),36);
visible_GALsat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_GALsat(j,1)=res{j,1}.order_num(GAL_phase_index,1);
    for jj=1:res{j,1}.order_num(GAL_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:GAL_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        GAL_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        GAL_elevations(j,satNum)=res{j,1}.elev(index,1);
        GAL_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        GAL_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        GAL_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        GAL_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(GAL_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:GAL_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        GAL_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        GAL_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

GAL_output.code_residual=GAL_Code_residuals;
GAL_output.phase_residual=GAL_Phase_residuals;
GAL_output.elevation=GAL_elevations;
GAL_output.azimut=GAL_azimuts;
GAL_output.Code_std_residual=GAL_Code_stdResiduals;
GAL_output.Phase_std_residual=GAL_Phase_stdResiduals;
GAL_output.snrL1=GAL_SNR_L1;
GAL_output.snrL2=GAL_SNR_L2;
GAL_output.vis_Sat=visible_GALsat;
end
