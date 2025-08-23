function [eclipse] =eclipse_control(The_sun_pos,rot_sat_positon)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

ecl_cont=(dot(rot_sat_positon,The_sun_pos)/(norm(rot_sat_positon)*norm(The_sun_pos)));

ecl_cont2=(norm(rot_sat_positon))*sqrt(1-(ecl_cont)^2);


if ecl_cont<0 && ecl_cont2<6371000
   % disp('eclipseeeee');
    eclipse=1;
else
    eclipse=0;
end
end