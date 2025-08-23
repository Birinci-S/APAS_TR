
function[obs_C_BDS3,obs_L_BDS3,BDS3_SNR]=observation_BDS3(rnxdata,rnx_BDS,SNR_cutoff,s)


%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci

obs_C_BDS3=[]; obs_L_BDS3=[]; BDS3_SNR=[];
%SNR_cutoff=20;
%++++++++++++++++++++++
counter=1;
counter2=1;
for c=1:size(rnxdata.BEIDOU{2,rnx_BDS.C1columnBDS},2)
    if ~isnan(rnxdata.BEIDOU{2,rnx_BDS.C1columnBDS}(s,c)) && ~isnan(rnxdata.BEIDOU{2,rnx_BDS.C2columnBDS}(s,c)) && ~isnan(rnxdata.BEIDOU{2,rnx_BDS.L1columnBDS}(s,c)) && ~isnan(rnxdata.BEIDOU{2,rnx_BDS.L2columnBDS}(s,c)) && c>=19  && ...
            (rnxdata.BEIDOU{2,rnx_BDS.SNR_L1}(s,c))>SNR_cutoff && (rnxdata.BEIDOU{2,rnx_BDS.SNR_L2}(s,c))>SNR_cutoff


        [obs_C_BDS3(counter,1)  ]=iono_free_obs (rnxdata.BEIDOU{2,rnx_BDS.C1columnBDS}(s,c),rnxdata.BEIDOU{2,rnx_BDS.C2columnBDS}(s,c),[],4);
        obs_C_BDS3(counter,2)=c; %sat Num
        counter=counter+1;


        [obs_L_BDS3(counter2,1)  ]=iono_free_obs (rnxdata.BEIDOU{2,rnx_BDS.L1columnBDS}(s,c),rnxdata.BEIDOU{2,rnx_BDS.L2columnBDS}(s,c),[],4);
        obs_L_BDS3(counter2,2)=c;%sat Num


        BDS3_SNR(counter2,:)=[rnxdata.BEIDOU{2,rnx_BDS.SNR_L1}(s,c), rnxdata.BEIDOU{2,rnx_BDS.SNR_L2}(s,c)];

        counter2=counter2+1;
    end
end
end