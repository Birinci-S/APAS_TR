
function [GPS_output,GLO_output,GAL_output,BDS2_output,BDS3_output,QZSS_output]=final_results(combination,res)

%%% This function is a component of APAS-TR. 12.02.2024, S. Birinci


GPS_output=[];  GLO_output=[]; GAL_output=[];  BDS2_output=[];  BDS3_output=[];  QZSS_output=[];


if combination==1

    GPS_phase_index= 2;
    GPS_output=GPS_analyze(res,GPS_phase_index);


elseif combination==2

    GPS_phase_index= 2;
    GLO_phase_index= 4;

    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);



elseif combination==3

    GPS_phase_index= 2;
    GAL_phase_index= 4;

    GPS_output=GPS_analyze(res,GPS_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);


elseif combination ==4

    GPS_phase_index= 2;
    GLO_phase_index= 4;
    GAL_phase_index= 6;



    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);




elseif combination ==5

    GPS_phase_index= 2;
    GLO_phase_index= 4;
    GAL_phase_index= 6;
    BDS2_phase_index= 8;


    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);
    BDS2_output=BDS2_analyze(res,BDS2_phase_index);



elseif combination ==6

    GPS_phase_index= 2;
    GLO_phase_index= 4;
    GAL_phase_index= 6;
    BDS3_phase_index= 8;


    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);
    BDS3_output=BDS3_analyze(res,BDS3_phase_index);


elseif combination ==7

    GPS_phase_index= 2;
    GLO_phase_index= 4;
    GAL_phase_index= 6;
    BDS2_phase_index= 8;
    BDS3_phase_index= 10;

    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);
    BDS2_output=BDS2_analyze(res,BDS2_phase_index);
    BDS3_output=BDS3_analyze(res,BDS3_phase_index);


elseif combination ==8

    GPS_phase_index= 2;
    GLO_phase_index= 4;
    GAL_phase_index= 6;
    BDS2_phase_index= 8;
    BDS3_phase_index= 10;
    QZSS_phase_index= 12;

    GPS_output=GPS_analyze(res,GPS_phase_index);
    GLO_output=GLO_analyze(res,GLO_phase_index);
    GAL_output=GAL_analyze(res,GAL_phase_index);
    BDS2_output=BDS2_analyze(res,BDS2_phase_index);
    BDS3_output=BDS3_analyze(res,BDS3_phase_index);
    QZSS_output=QZSS_analyze(res,QZSS_phase_index);



end
end