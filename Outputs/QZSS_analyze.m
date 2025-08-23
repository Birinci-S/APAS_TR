

function QZSS_output=QZSS_analyze(res,QZSS_phase_index)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


QZSS_Code_residuals=NaN(size(res,1),32);
QZSS_Phase_residuals=NaN(size(res,1),32);
QZSS_elevations=NaN(size(res,1),32);
QZSS_azimuts=NaN(size(res,1),32);
QZSS_Code_stdResiduals=NaN(size(res,1),32);
QZSS_Phase_stdResiduals=NaN(size(res,1),32);
QZSS_SNR_L1=NaN(size(res,1),32);
QZSS_SNR_L2=NaN(size(res,1),32);
visible_QZSSsat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_QZSSsat(j,1)=res{j,1}.order_num(QZSS_phase_index,1);
    for jj=1:res{j,1}.order_num(QZSS_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:QZSS_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        QZSS_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        QZSS_elevations(j,satNum)=res{j,1}.elev(index,1);
        QZSS_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        QZSS_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        QZSS_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        QZSS_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(QZSS_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:QZSS_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        QZSS_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        QZSS_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

QZSS_output.code_residual=QZSS_Code_residuals;
QZSS_output.phase_residual=QZSS_Phase_residuals;
QZSS_output.elevation=QZSS_elevations;
QZSS_output.azimut=QZSS_azimuts;
QZSS_output.Code_std_residual=QZSS_Code_stdResiduals;
QZSS_output.Phase_std_residual=QZSS_Phase_stdResiduals;
QZSS_output.snrL1=QZSS_SNR_L1;
QZSS_output.snrL2=QZSS_SNR_L2;
QZSS_output.vis_Sat=visible_QZSSsat;
end
