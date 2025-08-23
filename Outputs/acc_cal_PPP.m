function [rms_values,conv_time,north_PPP,east_PPP,up_PPP]=acc_cal_PPP(output,ground_truth_coor,Lat_ground_trut,Lon_ground_trut,delta_time,conv_criteria)

%%% This function is a component of APAS-TR. 11.02.2024, S. Birinci



for i=1:size(output,1)

    [north,east,up,total_error]=cal_topoError(output(i,5:7)',ground_truth_coor,Lat_ground_trut,Lon_ground_trut);

    north_PPP(i,1)=north;
    east_PPP(i,1)=east;
    up_PPP(i,1)=up;
    total_error_PPP(i,1)=total_error;

end




conv_time=NaN;
for d=1:length(total_error_PPP)
    if total_error_PPP(d,1)<conv_criteria &&  isempty(find(total_error_PPP(d+1:end,1)>conv_criteria, 1 ))
        conv_time=d;
        break;
    end
end




if isnan(conv_time)
    rms_values=[NaN;NaN;NaN;NaN];

elseif ~isnan(conv_time)


    rms_north=rms(north_PPP(conv_time:end));
    rms_east=rms(east_PPP(conv_time:end));
    rms_up=rms(up_PPP(conv_time:end));
    rms_3D=rms(total_error_PPP(conv_time:end));

    rms_values=[rms_north;rms_east;rms_up;rms_3D];
    conv_time=conv_time*delta_time /60;
end

end
