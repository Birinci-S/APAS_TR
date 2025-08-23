
function[obs_C_QZSS,obs_L_QZSS, QZSS_SNR]=observation_QZSS(rnxdata,rnx_QZSS,SNR_cutoff,s)

%%% This function is a component of APAS-TR. 10.02.2024, S. Birinci

obs_C_QZSS=[]; obs_L_QZSS=[]; QZSS_SNR=[];
%SNR_cutoff=20;

%++++++++++++++++++++++
counter=1;
counter2=1;
for c=1:size(rnxdata.QZSS{2,rnx_QZSS.C1columnQZSS},2)
    if ~isnan(rnxdata.QZSS{2,rnx_QZSS.C1columnQZSS}(s,c)) && ~isnan(rnxdata.QZSS{2,rnx_QZSS.C2columnQZSS}(s,c)) && ~isnan(rnxdata.QZSS{2,rnx_QZSS.L1columnQZSS}(s,c)) && ~isnan(rnxdata.QZSS{2,rnx_QZSS.L2columnQZSS}(s,c)) && ...
            (rnxdata.QZSS{2,rnx_QZSS.SNR_L1}(s,c))>SNR_cutoff && (rnxdata.QZSS{2,rnx_QZSS.SNR_L2}(s,c))>SNR_cutoff


        [obs_C_QZSS(counter,1)  ]=iono_free_obs (rnxdata.QZSS{2,rnx_QZSS.C1columnQZSS}(s,c),rnxdata.QZSS{2,rnx_QZSS.C2columnQZSS}(s,c),[],5);
        obs_C_QZSS(counter,2)=c; %sat Num
        counter=counter+1;


        [obs_L_QZSS(counter2,1)  ]=iono_free_obs (rnxdata.QZSS{2,rnx_QZSS.L1columnQZSS}(s,c),rnxdata.QZSS{2,rnx_QZSS.L2columnQZSS}(s,c),[],5);
        obs_L_QZSS(counter2,2)=c;%sat Num
        QZSS_SNR(counter2,:)=[rnxdata.QZSS{2,rnx_QZSS.SNR_L1}(s,c), rnxdata.QZSS{2,rnx_QZSS.SNR_L2}(s,c)];


        counter2=counter2+1;
    end
end
end