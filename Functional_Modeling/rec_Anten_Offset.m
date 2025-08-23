function [anten]=rec_Anten_Offset(station,satPos,latitude,longitude,rec_Offset,satNum,system)


%%% This function is a component of APAS-TR. 09.02.2024, S. Birinci

L1neu=rec_Offset{1,1}./1000;
L1rec(1,1)=L1neu(2,1);   L1rec(2,1)=L1neu(1,1);   L1rec(3,1)=L1neu(3,1);
L2neu=rec_Offset{2,1}./1000;
L2rec(1,1)=L2neu(2,1);   L2rec(2,1)=L2neu(1,1);   L2rec(3,1)=L2neu(3,1);
translate=[-sind(longitude) -cosd(longitude)*sind(latitude) cosd(longitude)*cosd(latitude);...
    cosd(longitude) -sind(longitude)*sind(latitude) sind(longitude)*cosd(latitude);...
    0 cosd(latitude) sind(latitude)];

L1=translate*L1rec;
L2=translate*L2rec;


[iono_free_rec_Off  ]=iono_free_obs (L1,L2,satNum,system);





Mat=(station-satPos);
aci=atan2(norm(cross(Mat,iono_free_rec_Off)),dot(Mat,iono_free_rec_Off));
anten=norm(iono_free_rec_Off)*cos(aci);


end