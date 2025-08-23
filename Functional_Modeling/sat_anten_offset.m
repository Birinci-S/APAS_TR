function[MCoffset]=sat_anten_offset(The_sun_pos,satOffset,sat_position,satName,system)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


normSat=norm(sat_position);
if normSat ==0
    MCoffset=[0;0;0];
    return
end



k=-(sat_position./normSat);
e=(The_sun_pos-sat_position)./(norm(The_sun_pos-sat_position));
jj=cross(k,e)/norm(cross(k,e));
iii=cross(jj,k);
%R=[i j k];
R2=[iii jj k];

ii=satName;
if system==4 %%% for BDS frequency
    offsetL1= satOffset{1,ii}{1,2}./1000;
    offsetL2= satOffset{1,ii}{1,4}./1000;
elseif system==3 %%% for Galileo frequency
    offsetL1= satOffset{1,ii}{1,4}./1000;
    offsetL2= satOffset{1,ii}{1,1}./1000;
else %%% for GPS, GLONASS, and QZSS frequency
    offsetL1= satOffset{1,ii}{1,1}./1000;
    offsetL2= satOffset{1,ii}{1,2}./1000;
end


[freeL1L2  ]=iono_free_obs (offsetL1,offsetL2,satName,system);
MCoffset=(R2*freeL1L2);
end