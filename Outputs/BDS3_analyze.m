

function BDS3_output=BDS3_analyze(res,BDS3_phase_index)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


BDS3_Code_residuals=NaN(size(res,1),65);
BDS3_Phase_residuals=NaN(size(res,1),65);
BDS3_elevations=NaN(size(res,1),65);
BDS3_azimuts=NaN(size(res,1),65);
BDS3_Code_stdResiduals=NaN(size(res,1),65);
BDS3_Phase_stdResiduals=NaN(size(res,1),65);
BDS3_SNR_L1=NaN(size(res,1),65);
BDS3_SNR_L2=NaN(size(res,1),65);
visible_BDS3sat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_BDS3sat(j,1)=res{j,1}.order_num(BDS3_phase_index,1);
    for jj=1:res{j,1}.order_num(BDS3_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:BDS3_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        BDS3_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        BDS3_elevations(j,satNum)=res{j,1}.elev(index,1);
        BDS3_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        BDS3_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        BDS3_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        BDS3_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(BDS3_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:BDS3_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        BDS3_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        BDS3_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

BDS3_output.code_residual=BDS3_Code_residuals;
BDS3_output.phase_residual=BDS3_Phase_residuals;
BDS3_output.elevation=BDS3_elevations;
BDS3_output.azimut=BDS3_azimuts;
BDS3_output.Code_std_residual=BDS3_Code_stdResiduals;
BDS3_output.Phase_std_residual=BDS3_Phase_stdResiduals;
BDS3_output.snrL1=BDS3_SNR_L1;
BDS3_output.snrL2=BDS3_SNR_L2;
BDS3_output.vis_Sat=visible_BDS3sat;
end
