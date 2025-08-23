
function[obs_C_GLO,obs_L_GLO,GLO_SNR]=observation_GLO(rnxdata,rnx_GLO,SNR_cutoff,s)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

obs_C_GLO=[]; obs_L_GLO=[]; GLO_SNR=[];
%++++++++++++++++++++++4
%SNR_cutoff=20;
counter=1;
counter2=1;
for c=1:size(rnxdata.GLONASS{2,rnx_GLO.C1columnGLO},2)
    if ~isnan(rnxdata.GLONASS{2,rnx_GLO.C1columnGLO}(s,c)) && ~isnan(rnxdata.GLONASS{2,rnx_GLO.C2columnGLO}(s,c)) && ~isnan(rnxdata.GLONASS{2,rnx_GLO.L1columnGLO}(s,c)) && ~isnan(rnxdata.GLONASS{2,rnx_GLO.L2columnGLO}(s,c)) ...
            && (rnxdata.GLONASS{2,rnx_GLO.SNR_L1}(s,c))>SNR_cutoff  &&  (rnxdata.GLONASS{2,rnx_GLO.SNR_L2}(s,c))>SNR_cutoff


        [obs_C_GLO(counter,1)  ]=iono_free_obs (rnxdata.GLONASS{2,rnx_GLO.C1columnGLO}(s,c),rnxdata.GLONASS{2,rnx_GLO.C2columnGLO}(s,c),c,2);
        obs_C_GLO(counter,2)=c; %sat Num
        counter=counter+1;


        [obs_L_GLO(counter2,1)  ]=iono_free_obs (rnxdata.GLONASS{2,rnx_GLO.L1columnGLO}(s,c),rnxdata.GLONASS{2,rnx_GLO.L2columnGLO}(s,c),c,2);
        obs_L_GLO(counter2,2)=c;%sat Num

        GLO_SNR(counter2,:)=[rnxdata.GLONASS{2,rnx_GLO.SNR_L1}(s,c),rnxdata.GLONASS{2,rnx_GLO.SNR_L2}(s,c)];

        counter2=counter2+1;
    end
end
end