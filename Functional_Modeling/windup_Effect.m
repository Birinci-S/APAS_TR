function wup2 = windup_Effect(The_sun_pos,rot_sat_positon,recPosition,prev,latitude,longitude)
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%wind-up effect
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

sun=The_sun_pos';
sat=rot_sat_positon';
rec=recPosition';
phi=latitude;
lam=longitude;
esun = sun - sat;
esun = esun./norm(esun);
ez   = -1.*sat; ez = ez./norm(ez);
ey   = cross(ez,esun); ey = ey./norm(ey);
ex   = cross(ey,ez);   ex = ex./norm(ex);
xs   = ex; ys = ey;


xr   = [(-sind(phi)*cosd(lam)) (-sind(phi)*sind(lam)) cosd(phi)];
yr   = [  sind(lam) -cosd(lam) 0];

k = rec - sat; k = k./norm(k);

Ds = xs - k.*(dot(k,xs)) - cross(k,ys);
Dr = xr - k.*(dot(k,xr)) + cross(k,yr);
wup= sign(dot(k,(cross(Ds,Dr))))*acos(dot(Ds,Dr)/norm(Ds)/norm(Dr));

if prev == 0

    wup2=wup;
else
    wup2=(nearest((prev-wup)/2/pi)*2*pi)+wup;
end


end
