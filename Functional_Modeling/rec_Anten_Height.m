function [anten_height]=rec_Anten_Height(station,satPos,latitude,longitude,antennaPosition)

%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci


recAnten(1,1)=antennaPosition(1,2); recAnten(2,1)=antennaPosition(1,3); recAnten(3,1)=antennaPosition(1,1);

translate=[-sind(longitude) -cosd(longitude)*sind(latitude) cosd(longitude)*cosd(latitude);...
    cosd(longitude) -sind(longitude)*sind(latitude) sind(longitude)*cosd(latitude);...
    0 cosd(latitude) sind(latitude)];

anten_height=translate*recAnten;



Mat=(station-satPos);
aci=atan2(norm(cross(Mat,anten_height)),dot(Mat,anten_height));
anten_height=norm(anten_height)*cos(aci);




end