function [satElevation, satAzimuth]=calElev(enlem,boylam,satPos,recPosition)

%%% This function is a component of APAS-TR. 08.02.2024, S. Birinci

satPosX=satPos(1,1);
satPosY=satPos(2,1);
satPosZ=satPos(3,1);
X=recPosition(1,1);
Y=recPosition(2,1);
Z=recPosition(3,1);

deltaX=[satPosX-X  ;  satPosY-Y    ;satPosZ-Z ];


Rtopo=[-sind(enlem)*cosd(boylam) -sind(enlem)*sind(boylam) cosd(enlem)
    -sind(boylam) cosd(boylam) 0
    cosd(enlem)*cosd(boylam) cosd(enlem)*sind(boylam) sind(enlem)];

toposentrik=Rtopo*deltaX;


[azimuth, elevation,~]=enu2aer(toposentrik(2,1),toposentrik(1,1),toposentrik(3,1));
satElevation=elevation;
satAzimuth=azimuth;


end