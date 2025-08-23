
function[obs_C_GAL,obs_L_GAL,GAL_SNR]=observation_GAL(rnxdata,rnx_GAL,SNR_cutoff,s)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci



obs_C_GAL=[]; obs_L_GAL=[]; GAL_SNR=[];
%SNR_cutoff=20;
%++++++++++++++++++++++
counter=1;
counter2=1;
for c=1:size(rnxdata.GALILEO{2,rnx_GAL.C1columnGAL},2)
    if ~isnan(rnxdata.GALILEO{2,rnx_GAL.C1columnGAL}(s,c)) && ~isnan(rnxdata.GALILEO{2,rnx_GAL.C2columnGAL}(s,c)) && ~isnan(rnxdata.GALILEO{2,rnx_GAL.L1columnGAL}(s,c)) && ~isnan(rnxdata.GALILEO{2,rnx_GAL.L2columnGAL}(s,c)) ...
            && (rnxdata.GALILEO{2,rnx_GAL.SNR_L1}(s,c))>SNR_cutoff && (rnxdata.GALILEO{2,rnx_GAL.SNR_L2}(s,c))>SNR_cutoff

        [obs_C_GAL(counter,1)  ]=iono_free_obs (rnxdata.GALILEO{2,rnx_GAL.C1columnGAL}(s,c),rnxdata.GALILEO{2,rnx_GAL.C2columnGAL}(s,c),[],3);
        obs_C_GAL(counter,2)=c; %sat Num
        counter=counter+1;


        [obs_L_GAL(counter2,1)  ]=iono_free_obs (rnxdata.GALILEO{2,rnx_GAL.L1columnGAL}(s,c),rnxdata.GALILEO{2,rnx_GAL.L2columnGAL}(s,c),[],3);
        obs_L_GAL(counter2,2)=c;%sat Num

        GAL_SNR(counter2,:)=[rnxdata.GALILEO{2,rnx_GAL.SNR_L1}(s,c), rnxdata.GALILEO{2,rnx_GAL.SNR_L2}(s,c)];

        counter2=counter2+1;
    end
end
end