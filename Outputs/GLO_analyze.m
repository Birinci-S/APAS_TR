

function GLO_output=GLO_analyze(res,GLO_phase_index)


%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci

GLO_Code_residuals=NaN(size(res,1),32);
GLO_Phase_residuals=NaN(size(res,1),32);
GLO_elevations=NaN(size(res,1),32);
GLO_azimuts=NaN(size(res,1),32);
GLO_Code_stdResiduals=NaN(size(res,1),32);
GLO_Phase_stdResiduals=NaN(size(res,1),32);
GLO_SNR_L1=NaN(size(res,1),32);
GLO_SNR_L2=NaN(size(res,1),32);
visible_GLOsat=NaN(size(res,1),1);


for j=1:size(res,1)  %2880
    visible_GLOsat(j,1)=res{j,1}.order_num(GLO_phase_index,1);
    for jj=1:res{j,1}.order_num(GLO_phase_index,1) %11
        index=jj+sum(res{j,1}.order_num(1:GLO_phase_index-1,1));

        satNum=res{j,1}.elev(index,2);

        GLO_Phase_residuals(j,satNum)=res{j,1}.residual(index,1);
        GLO_elevations(j,satNum)=res{j,1}.elev(index,1);
        GLO_azimuts(j,satNum)=res{j,1}.Azi(index,1);
        GLO_Phase_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
        GLO_SNR_L1(j,satNum)=res{j,1}.SNR(index,1);
        GLO_SNR_L2(j,satNum)=res{j,1}.SNR(index,2);
    end



    for jj=1:res{j,1}.order_num(GLO_phase_index-1,1) %11
        index=jj+sum(res{j,1}.order_num(1:GLO_phase_index-2,1));

        satNum=res{j,1}.elev(index,2);
        GLO_Code_residuals(j,satNum)=res{j,1}.residual(index,1);
        GLO_Code_stdResiduals(j,satNum)=res{j,1}.std_residual(index,1);
    end

end

GLO_output.code_residual=GLO_Code_residuals;
GLO_output.phase_residual=GLO_Phase_residuals;
GLO_output.elevation=GLO_elevations;
GLO_output.azimut=GLO_azimuts;
GLO_output.Code_std_residual=GLO_Code_stdResiduals;
GLO_output.Phase_std_residual=GLO_Phase_stdResiduals;
GLO_output.snrL1=GLO_SNR_L1;
GLO_output.snrL2=GLO_SNR_L2;
GLO_output.vis_Sat=visible_GLOsat;
end
