
function[obs_C_GPS,obs_L_GPS,GPS_SNR]=observation_GPS(rnxdata,rnx_GPS,SNR_cutoff,s)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


obs_C_GPS=[]; obs_L_GPS=[]; GPS_SNR=[];
%SNR_cutoff=05.0;
%++++++++++++++++++++++4
counter=1;
counter2=1;


for c=1:size(rnxdata.GPS{2,rnx_GPS.C1columnGPS},2)
    if ~isnan(rnxdata.GPS{2,rnx_GPS.C1columnGPS}(s,c)) && ~isnan(rnxdata.GPS{2,rnx_GPS.C2columnGPS}(s,c)) && ~isnan(rnxdata.GPS{2,rnx_GPS.L1columnGPS}(s,c)) && ~isnan(rnxdata.GPS{2,rnx_GPS.L2columnGPS}(s,c)) ...
            && (rnxdata.GPS{2,rnx_GPS.SNR_L1}(s,c))>SNR_cutoff  &&  (rnxdata.GPS{2,rnx_GPS.SNR_L2}(s,c))>SNR_cutoff

        [obs_C_GPS(counter,1)  ]=iono_free_obs (rnxdata.GPS{2,rnx_GPS.C1columnGPS}(s,c),rnxdata.GPS{2,rnx_GPS.C2columnGPS}(s,c),[],1);
        obs_C_GPS(counter,2)=c; %sat Num
        counter=counter+1;


        [obs_L_GPS(counter2,1)  ]=iono_free_obs (rnxdata.GPS{2,rnx_GPS.L1columnGPS}(s,c),rnxdata.GPS{2,rnx_GPS.L2columnGPS}(s,c),[],1);
        obs_L_GPS(counter2,2)=c;%sat Num
        GPS_SNR(counter2,:)=[rnxdata.GPS{2,rnx_GPS.SNR_L1}(s,c),rnxdata.GPS{2,rnx_GPS.SNR_L2}(s,c)];

        counter2=counter2+1;



    end
end
end