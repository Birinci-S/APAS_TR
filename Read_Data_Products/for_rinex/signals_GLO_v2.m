%function [C1columnGLO, C2columnGLO, L1columnGLO,L2columnGLO, GLO_C1, GLO_C2,GLO_L1,GLO_L2]=signals_GLO(rnxdata)
function [rnx_GLO]=signals_GLO_v2(rnxdata)

%%% This function is a component of APAS-TR. 07.02.2024, S. Birinci


GLO_C1=''; GLO_C2=''; GLO_L1=''; GLO_L2='';
C1columnGLO=NaN; C2columnGLO=NaN; L1columnGLO=NaN; L2columnGLO=NaN; SNR1columnGLO=NaN;  SNR2columnGLO=NaN;
GLO_system=0;

if isfield(rnxdata, 'GLONASS')
    %%%%% L1 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GLONASS(1,:),'C1'), 1))
        GLO_C1='C1';
        C1columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'C1'), 1));
        SNR1columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'S1'), 1));

    end




    %%%%% L2 frequency code measurement


    if ~isempty(find(1==contains(rnxdata.GLONASS(1,:),'P2'), 1))
        GLO_C2='P2';
        C2columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'P2'), 1));
        SNR2columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'S2'), 1));

    elseif ~isempty(find(1==contains(rnxdata.GLONASS(1,:),'C2'), 1))
        GLO_C2='C2';
        C2columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'C2'), 1));
        SNR2columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'S2'), 1));
    end





    %%%%% L1 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GLONASS(1,:),'L1'), 1))
        GLO_L1='L1';
        L1columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'L1'), 1));

    end




    %%%%% L2 frequency phase measurement


    if ~isempty(find(1==contains(rnxdata.GLONASS(1,:),'L2'), 1))
        GLO_L2='L2';
        L2columnGLO=(find(1==contains(rnxdata.GLONASS(1,:),'L2'), 1));

    end



    if isnan(C1columnGLO) || isnan(C2columnGLO) || isnan(L1columnGLO) || isnan(L2columnGLO)
        GLO_system=0;
    else
        GLO_system=1;
    end


    rnx.GLO.C1columnGLO=C1columnGLO;
    rnx.GLO.C2columnGLO=C2columnGLO;
    rnx.GLO.L1columnGLO=L1columnGLO;
    rnx.GLO.L2columnGLO=L2columnGLO;
    rnx.GLO.GLO_C1=GLO_C1;
    rnx.GLO.GLO_C2=GLO_C2;
    rnx.GLO.GLO_L1=GLO_L1;
    rnx.GLO.GLO_L2=GLO_L2;
    rnx.GLO.GLO_system=GLO_system;
    rnx.GLO.SNR_L1=SNR1columnGLO;
    rnx.GLO.SNR_L2=SNR2columnGLO;

else
    rnx.GLO.C1columnGLO=C1columnGLO;
    rnx.GLO.C2columnGLO=C2columnGLO;
    rnx.GLO.L1columnGLO=L1columnGLO;
    rnx.GLO.L2columnGLO=L2columnGLO;
    rnx.GLO.GLO_C1=GLO_C1;
    rnx.GLO.GLO_C2=GLO_C2;
    rnx.GLO.GLO_L1=GLO_L1;
    rnx.GLO.GLO_L2=GLO_L2;
    rnx.GLO.GLO_system=GLO_system;
    rnx.GLO.SNR_L1=SNR1columnGLO;
    rnx.GLO.SNR_L2=SNR2columnGLO;


end

rnx_GLO=rnx.GLO;
end