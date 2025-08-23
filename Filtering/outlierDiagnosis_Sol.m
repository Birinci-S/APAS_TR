
function[xfilter,Cfilter,fin_results]=outlierDiagnosis_Sol_lowCost(combination,xpredicte ,Cpredicte ,l ,A,C,sat_Elev,sat_SNR,sat_Azi)

%%% This function is a component of APAS-TR. 17.05.2024, S. Birinci


if combination==1
    pro_Sec=1;

elseif combination ==2 ;    pro_Sec=2;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;

elseif combination ==3 ;pro_Sec=2;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GAL;   satSNR2=sat_SNR.GAL; satAzi2=sat_Azi.GAL;

elseif combination ==4; pro_Sec=3;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;
    satElevation3=sat_Elev.GAL;   satSNR3=sat_SNR.GAL; satAzi3=sat_Azi.GAL;

elseif combination ==5;  pro_Sec=4;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;
    satElevation3=sat_Elev.GAL;   satSNR3=sat_SNR.GAL; satAzi3=sat_Azi.GAL;
    satElevation4=sat_Elev.BDS2;  satSNR4=sat_SNR.BDS2; satAzi4=sat_Azi.BDS2;

elseif combination ==6 ;  pro_Sec=4;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;
    satElevation3=sat_Elev.GAL;   satSNR3=sat_SNR.GAL; satAzi3=sat_Azi.GAL;
    satElevation4=sat_Elev.BDS3;  satSNR4=sat_SNR.BDS3; satAzi4=sat_Azi.BDS3;

elseif combination ==7; pro_Sec=5;
    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;
    satElevation3=sat_Elev.GAL;   satSNR3=sat_SNR.GAL; satAzi3=sat_Azi.GAL;
    satElevation4=sat_Elev.BDS2;  satSNR4=sat_SNR.BDS2; satAzi4=sat_Azi.BDS2;
    satElevation5=sat_Elev.BDS3;  satSNR5=sat_SNR.BDS3; satAzi5=sat_Azi.BDS3;

elseif combination ==8; pro_Sec=6;

    satElevation1=sat_Elev.GPS;   satSNR1=sat_SNR.GPS; satAzi1=sat_Azi.GPS;
    satElevation2=sat_Elev.GLO;   satSNR2=sat_SNR.GLO; satAzi2=sat_Azi.GLO;
    satElevation3=sat_Elev.GAL;   satSNR3=sat_SNR.GAL; satAzi3=sat_Azi.GAL;
    satElevation4=sat_Elev.BDS2;  satSNR4=sat_SNR.BDS2; satAzi4=sat_Azi.BDS2;
    satElevation5=sat_Elev.BDS3;  satSNR5=sat_SNR.BDS3; satAzi5=sat_Azi.BDS3;
    satElevation6=sat_Elev.QZSS;  satSNR6=sat_SNR.QZSS; satAzi6=sat_Azi.QZSS;
end




%%%%--------------------[G]---------------------------------
if pro_Sec==1

    satElevation1=sat_Elev.GPS;
    satSNR1=sat_SNR.GPS;
    satAzi1=sat_Azi.GPS;

    d=l;

    num_P1=size(satElevation1,1);
    num_L1=size(satElevation1,1);
    ord_meas=[num_P1;num_L1];

    GDOP=sqrt(trace(inv(A(1:num_P1,1:4)'*A(1:num_P1,1:4))));
    PDOP=sqrt(trace(inv(A(1:num_P1,1:3)'*A(1:num_P1,1:3))));

    mcont=all(diag(Cpredicte(6:end,6:end))==(1e2)^2);
    %mcont=0;
    phase_L=d(ord_meas(1,1)+1:end);
    %
    % uyusumsuz=[];
    % if mcont==0 && length(phase_L)>4
    %
    %     uyusumsuz= MADbasedOutlierDet(phase_L,900000000);
    %     reint_Amb=uyusumsuz+5;
    %
    % end
    %
    %
    %
    % if ~isempty(uyusumsuz)
    %     for p=1:size(uyusumsuz,1)
    %         Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %     end
    % end



    code_P=d(1:ord_meas(1,1));
    uyusumsuz_code= MADbasedOutlierDet(code_P,6);
    silsatir=[]; p1_clc=0;
    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)

            silsatir(p,1)=uyusumsuz_code(p,1);
            %num_P1=num_P1-1;
            p1_clc=p1_clc+1;
        end
    end


    ord_meas=[num_P1-p1_clc;num_L1];
    total_elev=[satElevation1;satElevation1];
    total_SNR=[satSNR1;satSNR1];
    total_Azi=[satAzi1;satAzi1];





    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];  total_SNR(silsatir,:)=[];  total_Azi(silsatir,:)=[];
    end



    %%%%--------------------[GR or GE]---------------------------------
elseif pro_Sec==2


    d=l;
    num_P1=size(satElevation1,1);
    num_P2=size(satElevation2,1);
    num_L1=size(satElevation1,1);
    num_L2=size(satElevation2,1);

    ord_meas=[num_P1;num_L1;num_P2;num_L2];

    GDOP_A=A([1:num_P1,1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3,1))],[1:4,6:6]);
    PDOP_A=GDOP_A(:,1:3);

    GDOP=sqrt(trace(inv(GDOP_A'*GDOP_A)));
    PDOP=sqrt(trace(inv(PDOP_A'*PDOP_A)));



    phase_G=d(ord_meas(1,1)+1:sum(ord_meas(1:2,1)));
    phase_R=d(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));

    code_G=d(1:sum(ord_meas(1,1)));
    code_R=d(1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3,1)));
    code_P=[code_G;code_R];
    uyusumsuz_code= MADbasedOutlierDet(code_P,6);


    silsatir=[]; p1_clc=0; p2_clc=0;

    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)
            if uyusumsuz_code(p,1)<=num_P1
                silsatir(p,1)=uyusumsuz_code(p,1);
                % num_P1=num_P1-1;
                p1_clc=p1_clc+1;
            else
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1;
                % num_P2=num_P2-1;
                p2_clc=p2_clc+1;
            end

        end
    end

    ord_meas=[num_P1-p1_clc;num_L1;num_P2-p2_clc;num_L2];

    total_elev=[satElevation1;satElevation1;satElevation2;satElevation2];
    total_SNR=[satSNR1;satSNR1;satSNR2;satSNR2];
    total_Azi=[satAzi1;satAzi1;satAzi2;satAzi2];

    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];
        total_SNR(silsatir,:)=[];
        total_Azi(silsatir,:)=[];
    end



    mcont=all(diag(Cpredicte(7:end,7:end))==(1e2)^2);
  %  mcont=0;
    phase_L=[phase_G;phase_R];
    %
    % uyusumsuz=[];
    % if mcont==0
    %
    %     uyusumsuz= MADbasedOutlierDet(phase_L,90000000000);
    %     reint_Amb=uyusumsuz+6;
    %
    % end
    %
    %
    %
    %
    %
    % if ~isempty(uyusumsuz)
    %     for p=1:size(uyusumsuz,1)
    %         Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %     end
    % end



    %%%%--------------------[GRE]---------------------------------
elseif pro_Sec==3

    d=l;
    num_P1=size(satElevation1,1);
    num_P2=size(satElevation2,1);
    num_P3=size(satElevation3,1);

    num_L1=size(satElevation1,1);
    num_L2=size(satElevation2,1);
    num_L3=size(satElevation3,1);
    ord_meas=[num_P1;num_L1;num_P2;num_L2;num_P3;num_L3];

    GDOP_A=A([1:num_P1,1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3,1)),sum(ord_meas(1:4,1)):sum(ord_meas(1:5,1))],[1:4,6:7]);
    PDOP_A=GDOP_A(:,1:3);


    GDOP=sqrt(trace(inv(GDOP_A'*GDOP_A)));
    PDOP=sqrt(trace(inv(PDOP_A'*PDOP_A)));

    phase_G=d(1+ord_meas(1,1):sum(ord_meas(1:2)));
    phase_R=d(1+sum(ord_meas(1:3)):sum(ord_meas(1:4)));
    phase_E=d(1+sum(ord_meas(1:5)):sum(ord_meas(1:6)));




    code_G=d(1:sum(ord_meas(1:1)));
    code_R=d(1+sum(ord_meas(1:2)):sum(ord_meas(1:3)));
    code_E=d(1+sum(ord_meas(1:4)):sum(ord_meas(1:5)));

    code_P=[code_G;code_R;code_E];
    uyusumsuz_code= MADbasedOutlierDet(code_P,6);

    silsatir=[]; p1_clc=0; p2_clc=0;  p3_clc=0;

    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)
            if uyusumsuz_code(p,1)<=num_P1
                silsatir(p,1)=uyusumsuz_code(p,1);
                p1_clc=p1_clc+1;
                %      num_P1=num_P1-1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1;
                %     num_P2=num_P2-1;
                p2_clc=p2_clc+1;
            else
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2;
                %     num_P3=num_P3-1;
                p3_clc=p3_clc+1;
            end

        end
    end

    ord_meas=[num_P1-p1_clc; num_L1; num_P2-p2_clc; num_L2; num_P3-p3_clc; num_L3];
    total_elev=[satElevation1;satElevation1;satElevation2;satElevation2;satElevation3;satElevation3];
    total_SNR=[satSNR1;satSNR1;satSNR2;satSNR2;satSNR3;satSNR3];
    total_Azi=[satAzi1;satAzi1;satAzi2;satAzi2;satAzi3;satAzi3];

    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];
        total_SNR(silsatir,:)=[];
        total_Azi(silsatir,:)=[];
    end


    mcont=all(diag(Cpredicte(8:end,8:end))==(1e2)^2);
   % mcont=0;
    phase_L=[phase_G;phase_R;phase_E];
    %
    % uyusumsuz=[];
    % if mcont==0
    %
    %     uyusumsuz= MADbasedOutlierDet(phase_L,900000000);
    %     reint_Amb=uyusumsuz+7;
    % end
    %
    %
    %
    % if ~isempty(uyusumsuz)
    %     for p=1:size(uyusumsuz,1)
    %         Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %     end
    % end



    %%%%--------------------[GREC2 or GREC3]---------------------------------
elseif pro_Sec==4

    d=l;
    num_P1=size(satElevation1,1);
    num_P2=size(satElevation2,1);
    num_P3=size(satElevation3,1);
    num_P4=size(satElevation4,1);

    num_L1=size(satElevation1,1);
    num_L2=size(satElevation2,1);
    num_L3=size(satElevation3,1);
    num_L4=size(satElevation4,1);
    ord_meas=[num_P1;num_L1;num_P2;num_L2;num_P3;num_L3;num_P4;num_L4];

    GDOP_A=A([1:num_P1,1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3)),1+sum(ord_meas(1:4)):sum(ord_meas(1:5)),1+sum(ord_meas(1:6)):sum(ord_meas(1:7))],[1:4,6:8]);
    PDOP_A=GDOP_A(:,1:3);

    GDOP=sqrt(trace(inv(GDOP_A'*GDOP_A)));
    PDOP=sqrt(trace(inv(PDOP_A'*PDOP_A)));

    phase_G=d(1+ord_meas(1,1):sum(ord_meas(1:2)));
    phase_R=d(1+sum(ord_meas(1:3)):sum(ord_meas(1:4)));
    phase_E=d(1+sum(ord_meas(1:5)):sum(ord_meas(1:6)));
    phase_C2=d(1+sum(ord_meas(1:7)):sum(ord_meas(1:8)));



    code_G=d(1:sum(ord_meas(1:1)));
    code_R=d(1+sum(ord_meas(1:2)):sum(ord_meas(1:3)));
    code_E=d(1+sum(ord_meas(1:4)):sum(ord_meas(1:5)));
    code_C2=d(1+sum(ord_meas(1:6)):sum(ord_meas(1:7)));


    code_P=[code_G;code_R;code_E;code_C2];

    uyusumsuz_code= MADbasedOutlierDet(code_P,6);


    silsatir=[]; p1_clc=0; p2_clc=0;  p3_clc=0; p4_clc=0;
    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)
            if uyusumsuz_code(p,1)<=num_P1
                silsatir(p,1)=uyusumsuz_code(p,1);
                % num_P1=num_P1-1;
                p1_clc=p1_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1;
                % num_P2=num_P2-1;
                p2_clc=p2_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2;
                % num_P3=num_P3-1;
                p3_clc=p3_clc+1;
            else
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3;
                % num_P4=num_P4-1;
                p4_clc=p4_clc+1;
            end

        end
    end


    ord_meas=[num_P1-p1_clc; num_L1; num_P2-p2_clc; num_L2; num_P3-p3_clc; num_L3;num_P4-p4_clc;num_L4];
    total_elev=[satElevation1;satElevation1;satElevation2;satElevation2;satElevation3;satElevation3;satElevation4;satElevation4];
    total_SNR=[satSNR1;satSNR1;satSNR2;satSNR2;satSNR3;satSNR3;satSNR4;satSNR4];
    total_Azi=[satAzi1;satAzi1;satAzi2;satAzi2;satAzi3;satAzi3;satAzi4;satAzi4];

    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];
        total_SNR(silsatir,:)=[];
        total_Azi(silsatir,:)=[];
    end



    mcont=all(diag(Cpredicte(9:end,9:end))==(1e2)^2);
    %mcont=0;
    phase_L=[phase_G;phase_R;phase_E;phase_C2];
    %
    % uyusumsuz=[];
    % if mcont==0
    %
    %     uyusumsuz= MADbasedOutlierDet(phase_L,6);
    %     reint_Amb=uyusumsuz+8;
    % end
    %
    %
    %
    %
    %
    %
    % if ~isempty(uyusumsuz)
    %     for p=1:size(uyusumsuz,1)
    %         Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %     end
    % end



    %%%%--------------------[GREC2C3]---------------------------------
elseif pro_Sec==5

    d=l;
    num_P1=size(satElevation1,1);
    num_P2=size(satElevation2,1);
    num_P3=size(satElevation3,1);
    num_P4=size(satElevation4,1);
    num_P5=size(satElevation5,1);

    num_L1=size(satElevation1,1);
    num_L2=size(satElevation2,1);
    num_L3=size(satElevation3,1);
    num_L4=size(satElevation4,1);
    num_L5=size(satElevation5,1);

    ord_meas=[num_P1;num_L1;num_P2;num_L2;num_P3;num_L3;num_P4;num_L4;num_P5;num_L5];

    GDOP_A=A([1:num_P1,1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3)),1+sum(ord_meas(1:4)):sum(ord_meas(1:5)),...
        1+sum(ord_meas(1:6)):sum(ord_meas(1:7)),1+sum(ord_meas(1:8)):sum(ord_meas(1:9))],[1:4,6:9]);

    PDOP_A=GDOP_A(:,1:3);
    GDOP=sqrt(trace(inv(GDOP_A'*GDOP_A)));
    PDOP=sqrt(trace(inv(PDOP_A'*PDOP_A)));

    phase_G=d(1+ord_meas(1,1):sum(ord_meas(1:2)));
    phase_R=d(1+sum(ord_meas(1:3)):sum(ord_meas(1:4)));
    phase_E=d(1+sum(ord_meas(1:5)):sum(ord_meas(1:6)));
    phase_C2=d(1+sum(ord_meas(1:7)):sum(ord_meas(1:8)));
    phase_C3=d(1+sum(ord_meas(1:9)):sum(ord_meas(1:10)));



    mcont=all(diag(Cpredicte(10:end,10:end))==(1e2)^2);

    phase_L=[phase_G;phase_R;phase_E;phase_C2;phase_C3];
    %
    % uyusumsuz=[];
    % if mcont==0
    %
    %     uyusumsuz= MADbasedOutlierDet(phase_L,6);
    %     reint_Amb=uyusumsuz+9;
    % end
    %
    %
    %
    %
    % if ~isempty(uyusumsuz)
    %     for p=1:size(uyusumsuz,1)
    %         Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %     end
    % end





    code_G=d(1:sum(ord_meas(1:1)));
    code_R=d(1+sum(ord_meas(1:2)):sum(ord_meas(1:3)));
    code_E=d(1+sum(ord_meas(1:4)):sum(ord_meas(1:5)));
    code_C2=d(1+sum(ord_meas(1:6)):sum(ord_meas(1:7)));
    code_C3=d(1+sum(ord_meas(1:8)):sum(ord_meas(1:9)));

    code_P=[code_G;code_R;code_E;code_C2;code_C3];


    uyusumsuz_code= MADbasedOutlierDet(code_P,6);


    silsatir=[]; p1_clc=0; p2_clc=0;  p3_clc=0; p4_clc=0; p5_clc=0;
    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)
            if uyusumsuz_code(p,1)<=num_P1
                silsatir(p,1)=uyusumsuz_code(p,1);
                %num_P1=num_P1-1;
                p1_clc=p1_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1;
                %num_P2=num_P2-1;
                p2_clc=p2_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2;
                %num_P3=num_P3-1;
                p3_clc=p3_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3+num_P4
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3;
                %num_P4=num_P4-1;
                p4_clc=p4_clc+1;
            else
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3+num_L4;
                %num_P5=num_P5-1;
                p5_clc=p5_clc+1;
            end

        end
    end


    ord_meas=[num_P1-p1_clc; num_L1; num_P2-p2_clc; num_L2; num_P3-p3_clc; num_L3;num_P4-p4_clc;num_L4;num_P5-p5_clc;num_L5];
    total_elev=[satElevation1;satElevation1;satElevation2;satElevation2;satElevation3;satElevation3;...
        satElevation4;satElevation4;satElevation5;satElevation5];
    total_SNR=[satSNR1;satSNR1;satSNR2;satSNR2;satSNR3;satSNR3;satSNR4;satSNR4;satSNR5;satSNR5];
    total_Azi=[satAzi1;satAzi1;satAzi2;satAzi2;satAzi3;satAzi3;satAzi4;satAzi4;satAzi5;satAzi5];

    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];
        total_SNR(silsatir,:)=[];
        total_Azi(silsatir,:)=[];
    end



    %%%%--------------------[GREC2C3J]---------------------------------
elseif pro_Sec==6
    d=l;
    num_P1=size(satElevation1,1);
    num_P2=size(satElevation2,1);
    num_P3=size(satElevation3,1);
    num_P4=size(satElevation4,1);
    num_P5=size(satElevation5,1);
    num_P6=size(satElevation6,1);

    num_L1=size(satElevation1,1);
    num_L2=size(satElevation2,1);
    num_L3=size(satElevation3,1);
    num_L4=size(satElevation4,1);
    num_L5=size(satElevation5,1);
    num_L6=size(satElevation6,1);


    ord_meas=[num_P1;num_L1;num_P2;num_L2;num_P3;num_L3;num_P4;num_L4;num_P5;num_L5;num_P6;num_L6];


    GDOP_A=A([1:num_P1,1+sum(ord_meas(1:2,1)):sum(ord_meas(1:3)),1+sum(ord_meas(1:4)):sum(ord_meas(1:5)),...
        1+sum(ord_meas(1:6)):sum(ord_meas(1:7)),1+sum(ord_meas(1:8)):sum(ord_meas(1:9)), 1+sum(ord_meas(1:10)):sum(ord_meas(1:11))],[1:4,6:10]);

    PDOP_A=GDOP_A(:,1:3);
    GDOP=sqrt(trace(inv(GDOP_A'*GDOP_A)));
    PDOP=sqrt(trace(inv(PDOP_A'*PDOP_A)));

    phase_G=d(1+ord_meas(1,1):sum(ord_meas(1:2)));
    phase_R=d(1+sum(ord_meas(1:3)):sum(ord_meas(1:4)));
    phase_E=d(1+sum(ord_meas(1:5)):sum(ord_meas(1:6)));
    phase_C2=d(1+sum(ord_meas(1:7)):sum(ord_meas(1:8)));
    phase_C3=d(1+sum(ord_meas(1:9)):sum(ord_meas(1:10)));
    phase_J=d(1+sum(ord_meas(1:11)):sum(ord_meas(1:12)));

    code_G=d(1:sum(ord_meas(1:1)));
    code_R=d(1+sum(ord_meas(1:2)):sum(ord_meas(1:3)));
    code_E=d(1+sum(ord_meas(1:4)):sum(ord_meas(1:5)));
    code_C2=d(1+sum(ord_meas(1:6)):sum(ord_meas(1:7)));
    code_C3=d(1+sum(ord_meas(1:8)):sum(ord_meas(1:9)));
    code_J=d(1+sum(ord_meas(1:10)):sum(ord_meas(1:11)));

    code_P=[code_G;code_R;code_E;code_C2;code_C3;code_J];
    uyusumsuz_code= MADbasedOutlierDet(code_P,6);


    silsatir=[]; p1_clc=0; p2_clc=0;  p3_clc=0; p4_clc=0; p5_clc=0; p6_clc=0;
    if ~isempty(uyusumsuz_code)
        for p=1:size(uyusumsuz_code,1)
            if uyusumsuz_code(p,1)<=num_P1
                silsatir(p,1)=uyusumsuz_code(p,1);
                %num_P1=num_P1-1;
                p1_clc=p1_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1;
                %num_P2=num_P2-1;
                p2_clc=p2_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2;
                %num_P3=num_P3-1;
                p3_clc=p3_clc+1;
            elseif uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3+num_P4
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3;
                %num_P4=num_P4-1;
                p4_clc=p4_clc+1;
            elseif  uyusumsuz_code(p,1)<=num_P1+num_P2+num_P3+num_P4+num_P5
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3+num_L4;
                %num_P5=num_P5-1;
                p5_clc=p5_clc+1;
            else
                silsatir(p,1)=uyusumsuz_code(p,1)+num_L1+num_L2+num_L3+num_L4+num_L5;
                %num_P6=num_P6-1;
                p6_clc=p6_clc+1;
            end

        end
    end

    ord_meas=[num_P1-p1_clc; num_L1; num_P2-p2_clc; num_L2; num_P3-p3_clc; num_L3;num_P4-p4_clc;num_L4;num_P5-p5_clc;num_L5;num_P6-p6_clc;num_L6];
    total_elev=[satElevation1;satElevation1;satElevation2;satElevation2;satElevation3;satElevation3;...
        satElevation4;satElevation4;satElevation5;satElevation5;satElevation6;satElevation6];

    total_SNR=[satSNR1;satSNR1;satSNR2;satSNR2;satSNR3;satSNR3;satSNR4;satSNR4;satSNR5;satSNR5;satSNR6;satSNR6];
    total_Azi=[satAzi1;satAzi1;satAzi2;satAzi2;satAzi3;satAzi3;satAzi4;satAzi4;satAzi5;satAzi5;satAzi6;satAzi6];


    if ~isempty(silsatir)
        A(silsatir,:)=[]; l(silsatir,:)=[]; C(silsatir,:)=[]; C(:,silsatir)=[];
        total_elev(silsatir,:)=[];
        total_SNR(silsatir,:)=[];
        total_Azi(silsatir,:)=[];
    end



    mcont=all(diag(Cpredicte(11:end,11:end))==(1e2)^2);

    phase_L=[phase_G;phase_R;phase_E;phase_C2;phase_C3;phase_J];
    %
    %     uyusumsuz=[];
    %     if mcont==0
    %
    %         uyusumsuz= MADbasedOutlierDet(phase_L,6);
    %         reint_Amb=uyusumsuz+10;
    %     end
    %
    %
    %
    %
    %
    %     if ~isempty(uyusumsuz)
    %         for p=1:size(uyusumsuz,1)
    %             Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;
    %
    %         end
    %     end
    %
    %
    %
end




%%%%%%%%%%%%%%%for residual control %%%%%%%%%%%%%%
d= l;
%Qdd= (C +( A*Cpredicte*A'));
alfak =1;
Gain2=((1/alfak).*(A*Cpredicte*A'))+C;
if rcond(Gain2)>10^-15
    Gain21=((1/alfak).*Cpredicte*A')/(Gain2);
else
    Gain21=((1/alfak).*Cpredicte*A')*pinv(Gain2);
end

x0=Gain21*d;
vi = abs(A*x0 -l);

if combination ==1
    faz_control=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    frac_part=5;

elseif combination ==2 ||  combination ==3

    faz_control1=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    faz_control2=vi(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));
    faz_control=[faz_control1;faz_control2];
    frac_part=6;

elseif combination ==4

    faz_control1=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    faz_control2=vi(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));
    faz_control3=vi(1+sum(ord_meas(1:5,1)):sum(ord_meas(1:6,1)));
    faz_control=[faz_control1;faz_control2;faz_control3];

    frac_part=7;

elseif combination ==5 ||   combination ==6
    faz_control1=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    faz_control2=vi(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));
    faz_control3=vi(1+sum(ord_meas(1:5,1)):sum(ord_meas(1:6,1)));
    faz_control4=vi(1+sum(ord_meas(1:7,1)):sum(ord_meas(1:8,1)));
    faz_control=[faz_control1;faz_control2;faz_control3;faz_control4];

    frac_part=8;

elseif combination ==7
    faz_control1=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    faz_control2=vi(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));
    faz_control3=vi(1+sum(ord_meas(1:5,1)):sum(ord_meas(1:6,1)));
    faz_control4=vi(1+sum(ord_meas(1:7,1)):sum(ord_meas(1:8,1)));
    faz_control5=vi(1+sum(ord_meas(1:9,1)):sum(ord_meas(1:10,1)));
    faz_control=[faz_control1;faz_control2;faz_control3;faz_control4;faz_control5];

    frac_part=9;


elseif combination ==8
    faz_control1=vi(1+ord_meas(1,1):sum(ord_meas(1:2,1)));
    faz_control2=vi(1+sum(ord_meas(1:3,1)):sum(ord_meas(1:4,1)));
    faz_control3=vi(1+sum(ord_meas(1:5,1)):sum(ord_meas(1:6,1)));
    faz_control4=vi(1+sum(ord_meas(1:7,1)):sum(ord_meas(1:8,1)));
    faz_control5=vi(1+sum(ord_meas(1:9,1)):sum(ord_meas(1:10,1)));
    faz_control6=vi(1+sum(ord_meas(1:11,1)):sum(ord_meas(1:12,1)));
    faz_control=[faz_control1;faz_control2;faz_control3;faz_control4;faz_control5;faz_control6];

    frac_part=10;

end

%%%%%%%%%%%%%%% phase residual final check %%%%%%%%%%%%%%

if mcont==0 && any(faz_control>=0.06) || (max(abs(phase_L))-min(abs(phase_L)))>=0.09


    % disp('new sigmaaa')
    % if length(phase_L)<=5
    %     uyusumsuz= MADbasedOutlierDet(phase_L,12);
    % else


    uyusumsuz= MADbasedOutlierDet(phase_L,3);
    % end
    reint_Amb=uyusumsuz+frac_part;

    if ~isempty(uyusumsuz)
        for p=1:size(uyusumsuz,1)
            Cpredicte(reint_Amb(p,1),:)=0;  Cpredicte(:,reint_Amb(p,1))=0;  Cpredicte(reint_Amb(p,1),reint_Amb(p,1))=(1e2)^2;

        end
    end

end





%%%-----------------------Estimation Step ----------------

d= l;
Qdd= (C +( A*Cpredicte*A'));
alfak =1;


Gain2=((1/alfak).*(A*Cpredicte*A'))+C;
%   [Gain2] = validateCovMatrix(Gain2);
if rcond(Gain2)>10^-15
    Gain21=((1/alfak).*Cpredicte*A')/(Gain2);

else
    Gain21=((1/alfak).*Cpredicte*A')*pinv(Gain2);
end


x0=Gain21*d;
xfilter=xpredicte+x0;
vi = abs(A*x0 -l);
vi_raw=(A*x0 -l);
Cfilter1 = (eye(size(A,2)) - Gain21*A)*Cpredicte * (eye(size(A,2)) - Gain21*A)' + (Gain21*C*Gain21');

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Cfilter] = validateCovMatrix(Cfilter1);
%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


sigmakare= ((d'*pinv(Qdd)*d)/size(A,1));
Qvv = abs(C - (A*Cfilter*A'));

% Qvvyeni = (C - (A*(Cfilter)*A'));
% for i=1:length(vi); hh(i)=vi(i)/sqrt(Qvv(i,i));end

for i=1:size(vi,1)
    robust1(i,1)=vi(i,1)/(sqrt(sigmakare*Qvv(i,i)));
end

%%%%%%Results-------
fin_results.elev=total_elev;
fin_results.residual=vi_raw;
fin_results.std_residual=robust1;
fin_results.SNR=total_SNR;
fin_results.Azi=total_Azi;
fin_results.order_num=ord_meas;
fin_results.DOPS=[GDOP, PDOP];



end