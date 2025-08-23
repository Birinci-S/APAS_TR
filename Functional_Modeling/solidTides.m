function [solTid1]=solidTides(~,station,satPos,sunPos ,moonPos)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci



X=station(1,1);%X coordinate
Y=station(2,1);%Y coordinate
Z=station(3,1);%Z coordinate
%GRS80 elipsoit
a=6378137;
b=6356752.3141;
% c=6399593.6259;
eussukare=0.00673949677548;
e = 0.081819191043422;
ekare=e^2;


q=atan((Z*a)/(b*sqrt(X^2+Y^2)))*180/pi; %
latitude=atan((Z+eussukare*b*(sind(q))^3)/(sqrt(X^2+Y^2)-ekare*a*(cosd(q))^3))*180/pi; %








Msun_Mearth=332946.0;
Mmoon_Mearth=0.01230002;
Rearth=6378136.6;
h2=0.6078-0.0006*((3*(sind(latitude))^2-1)/2);
h3=0.292;
l2=0.0847-0.0002*((3*(sind(latitude))^2-1)/2);
l3=0.015;
disSun=norm(sunPos);
disMoon=norm(moonPos);
disStation=norm(station);
unitSun=sunPos./disSun;
unitMoon=moonPos./disMoon;
unitStation=station./disStation;



term1=Mmoon_Mearth*Rearth^4/disMoon^3;
term2=h2.*unitStation.*(3/2*(dot(unitMoon,unitStation))^2-(1/2));
term3=3*l2*(dot(unitMoon,unitStation))*(unitMoon-(dot(unitMoon,unitStation)).*unitStation);
term_moon=term1*(term2+term3);




term10=Mmoon_Mearth*Rearth^5/disMoon^4;
term20=h3.*unitStation.*(5/2*(dot(unitMoon,unitStation))^3-(3/2*dot(unitMoon,unitStation)));
term30=l3*(15/2*(dot(unitMoon,unitStation))^2-3/2)*(unitMoon-(dot(unitMoon,unitStation)).*unitStation);
term_moon0=term10*(term20+term30);





term4=Msun_Mearth*Rearth^4/disSun^3;
term5=h2.*unitStation.*(3/2*(dot(unitSun,unitStation))^2-1/2);
term6=3*l2*(dot(unitSun,unitStation))*(unitSun-(dot(unitSun,unitStation)).*unitStation);
term_sun=term4*(term5+term6);


term40=Msun_Mearth*Rearth^5/disSun^4;
term50=h3.*unitStation.*(5/2*(dot(unitSun,unitStation))^3-(3/2*dot(unitSun,unitStation)));
term60=l3*(15/2*(dot(unitSun,unitStation))^2-3/2)*(unitSun-(dot(unitSun,unitStation)).*unitStation);
term_sun0=term40*(term50+term60);


solid_tides=term_moon+term_sun;
solid_tides0=term_moon0+term_sun0;
solid_tides=solid_tides+solid_tides0;

% mat1=(satPos-station);
% mat2=(satPos-station+solid_tides);
%aci2=atan2(norm(cross(mat1,mat2)),dot(mat1,mat2));

Mat=(satPos-station);
aci=atan2(norm(cross(Mat,solid_tides)),dot(Mat,solid_tides));
solTid1=norm(solid_tides)*cos(aci);

end








