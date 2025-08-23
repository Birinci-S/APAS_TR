

function BDS2_output=BDS2_analyze(res,BDS2_phase_index)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


BDS2_Code_residuals=NaN(size(res,1),32);
BDS2_Phase_residuals=NaN(size(res,1),32);
BDS2_elevations=NaN(size(res,1),32);
BDS2_azimuts=NaN(size(res,1),32);
BDS2_Code_stdResiduals=NaN(size(res,1),32);
BDS2_Phase_stdResiduals=NaN(size(res,1),32);
BDS2_SNR_L1=NaN(size(res,1),32);
BDS2_SNR_L2=NaN(size(res,1),32);
visible_BDS2sat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_BDS2sat(j,1)=res{j,1}.order_num(BDS2_phase_index,1);
    for jj=1:res{j,1}.order_num(BDS2_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:BDS2_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        BDS2_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        BDS2_elevations(j,satNum)=res{j,1}.elev(index,1);
        BDS2_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        BDS2_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        BDS2_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        BDS2_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(BDS2_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:BDS2_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        BDS2_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        BDS2_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

BDS2_output.code_residual=BDS2_Code_residuals;
BDS2_output.phase_residual=BDS2_Phase_residuals;
BDS2_output.elevation=BDS2_elevations;
BDS2_output.azimut=BDS2_azimuts;
BDS2_output.Code_std_residual=BDS2_Code_stdResiduals;
BDS2_output.Phase_std_residual=BDS2_Phase_stdResiduals;
BDS2_output.snrL1=BDS2_SNR_L1;
BDS2_output.snrL2=BDS2_SNR_L2;
BDS2_output.vis_Sat=visible_BDS2sat;
end
