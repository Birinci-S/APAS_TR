
function [sec_Rel_Eff]=second_rel_Eff(rot_sat_positon,recPosition)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


lightSpeed=299792458;
sec_Rel_Eff=3986004.418e8*2/lightSpeed^2*log((norm(rot_sat_positon)+norm(recPosition)+norm(recPosition-rot_sat_positon))/(norm(rot_sat_positon)+norm(recPosition)-norm(recPosition-rot_sat_positon)));



end 