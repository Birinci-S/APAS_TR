function [ZTD_rms,int_ZTD]=trop_rms(ref_ZTD,rnxtime,trop_PPP)

%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci



if ~isempty(ref_ZTD)

    PPP_ZTD=[rnxtime(:,2)+rnxtime(:,7)/24+rnxtime(:,8)/24/60+ rnxtime(:,9)/24/60/60 trop_PPP];

    int_ZTD=interp1(PPP_ZTD(:,1), PPP_ZTD(:,2),ref_ZTD(1:end-1,1));

    dx=int_ZTD-ref_ZTD(1:end-1,2);
    ZTD_rms=rms(dx(2:end)); %%% after convergence time 

elseif isempty(ref_ZTD)
    ZTD_rms=0;
    msgbox('Reference Troposphere File was not used ..Therefore ZTD RMS can not be calculated...');
    int_ZTD=[];

end


if isnan(ZTD_rms)
    ZTD_rms=0;
    msgbox('Reference Troposphere File might belong to a different day.. ..Therefore ZTD RMS can not be calculated...');
    int_ZTD=[];
end

end




